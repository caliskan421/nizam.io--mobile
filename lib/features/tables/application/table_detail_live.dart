part of 'table_detail_controller.dart';

mixin _TableDetailLive on Notifier<TableDetailState> {
  String get id;
  Object get _epoch;
  TableLocation? get _location;
  TableLocation get location;
  TablesRepository get repository;
  bool get _visible;
  bool _current(Object epoch);
  Future<void> refresh({bool more = false, bool previous = false});

  Object _connection = Object();
  StreamSubscription<TableLiveEvent>? _stream;
  Timer? _presence;
  Timer? _presenceSelection;
  final _presenceAge = Stopwatch();
  bool _sendingPresence = false;
  Timer? _reconnect;
  int _attempt = 0;
  int? _eventCursor;
  String? _selectedRow;
  String? _selectedColumn;
  Future<void> select(String? row, String? column) async {
    _selectedRow = row;
    _selectedColumn = column;
    unawaited(_publishPresence());
  }

  Future<void> _publishPresence() async {
    if (!ref.mounted ||
        !_visible ||
        _location == null ||
        _sendingPresence ||
        state.deleted) {
      return;
    }
    if (_presenceAge.isRunning &&
        _presenceAge.elapsed < const Duration(seconds: 1)) {
      _presenceSelection?.cancel();
      _presenceSelection = Timer(
        const Duration(seconds: 1) - _presenceAge.elapsed,
        () => unawaited(_publishPresence()),
      );
      return;
    }
    _presenceAge.reset();
    _presenceAge.start();
    _sendingPresence = true;
    final epoch = _epoch;
    try {
      await repository.presence(
        location,
        id,
        row: _selectedRow,
        column: _selectedColumn,
      );
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (_current(epoch) && error.code == 'tables.not_found') {
        unawaited(refresh());
      }
    } finally {
      _sendingPresence = false;
    }
  }

  void _connect() {
    if (_location == null || !ref.mounted || !_visible || state.deleted) return;
    final epoch = _epoch;
    final connection = Object();
    _connection = connection;
    state = state.copy(live: false, participants: []);
    _stream = repository
        .watch(location, id)
        .listen(
          (event) {
            if (!_current(epoch) || !identical(connection, _connection)) return;
            _attempt = 0;
            state = state.copy(live: true, participants: event.participants);
            if (event.sequence != null &&
                event.sequence! > (state.data?.sequence ?? 0)) {
              unawaited(_sync());
            }
          },
          onError: (Object e, StackTrace st) {
            final error = toReportedApiError(
              e,
              st,
              source: ReportSource.provider,
            );
            if (!_current(epoch) || !identical(connection, _connection)) return;
            state = state.copy(live: false, participants: []);
            unawaited(_stream?.cancel());
            _stream = null;
            if (error.code == 'tables.not_found' ||
                error.code == 'tables.forbidden') {
              unawaited(refresh());
              return;
            }
            _scheduleReconnect(error.retryAfter);
          },
          onDone: () {
            if (!_current(epoch) || !identical(connection, _connection)) return;
            _stream = null;
            state = state.copy(live: false, participants: []);
            _scheduleReconnect();
          },
        );
    _presence?.cancel();
    _presence = Timer.periodic(
      const Duration(seconds: 15),
      (_) => unawaited(_publishPresence()),
    );
    unawaited(_publishPresence());
  }

  void _scheduleReconnect([Duration? retryAfter]) {
    if (!_visible) return;
    _reconnect?.cancel();
    final epoch = _epoch;
    final delay = [2, 4, 8, 16, 30][_attempt.clamp(0, 4)];
    _attempt++;
    final wait = retryAfter != null && retryAfter > Duration(seconds: delay)
        ? retryAfter
        : Duration(seconds: delay);
    _reconnect = Timer(wait, () {
      if (_current(epoch)) _connect();
    });
  }

  bool _syncing = false;
  bool _syncAgain = false;
  Future<void> _sync() async {
    if (!ref.mounted || state.deleted) return;
    if (_syncing || state.busy) {
      _syncAgain = true;
      return;
    }
    _syncing = true;
    _syncAgain = false;
    final epoch = _epoch;
    try {
      TableChangePage page;
      do {
        page = await repository.changes(
          location,
          id,
          _eventCursor ?? state.data!.sequence,
        );
        if (!_current(epoch)) return;
        _eventCursor = page.cursor;
        final changes = [...state.changes, ...page.items];
        state = state.copy(
          changes: changes.length > 1000
              ? changes.sublist(changes.length - 1000)
              : changes,
        );
      } while (page.more);
      await refresh();
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (error.code == 'tables.replay_expired') _eventCursor = null;
      if (_current(epoch)) await refresh();
    } finally {
      _syncing = false;
      if (_current(epoch) && _syncAgain && !state.busy) unawaited(_sync());
    }
  }
}
