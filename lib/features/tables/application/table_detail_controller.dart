import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'tables_controller.dart';
import 'tables_server.dart';

part 'table_detail_live.dart';
part 'table_detail_state.dart';

final tableDetailProvider = NotifierProvider.autoDispose
    .family<TableDetailController, TableDetailState, String>(
      TableDetailController.new,
      dependencies: [
        tablesControllerProvider,
        tablesRepositoryProvider,
        tableSharingChoicesProvider,
        sessionGenerationProvider,
        scopeStateProvider,
      ],
    );

class TableDetailController extends Notifier<TableDetailState>
    with _TableDetailLive {
  TableDetailController(this.id);
  @override
  final String id;
  @override
  Object _epoch = Object();
  @override
  TableLocation? _location;
  @override
  TableLocation get location => _location!;
  String _account = '';
  final _clock = StaleClock();
  int _load = 0;
  int _readLimit = 20;
  bool _prefetched = false;
  final _cursors = <String?>[null];
  final _offsets = <int>[0];
  int _pageIndex = 0;
  @override
  bool _visible = true;
  _TablePendingWrite? _pending;
  KeepAliveLink? _pendingHold;
  @override
  TablesRepository get repository => ref.read(tablesRepositoryProvider)!;

  @override
  TableDetailState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch = Object();
    _connection = Object();
    _location = null;
    _readLimit = 20;
    _prefetched = false;
    _cursors
      ..clear()
      ..add(null);
    _offsets
      ..clear()
      ..add(0);
    _pageIndex = 0;
    _pending = null;
    _pendingHold?.close();
    _pendingHold = null;
    _eventCursor = null;
    _stream?.cancel();
    _presence?.cancel();
    _presenceSelection?.cancel();
    _presenceAge.stop();
    _presenceAge.reset();
    _sendingPresence = false;
    _reconnect?.cancel();
    ref.onDispose(() {
      _stream?.cancel();
      _presence?.cancel();
      _presenceSelection?.cancel();
      _reconnect?.cancel();
    });
    Future.microtask(refresh);
    return const TableDetailState();
  }

  @override
  bool _current(Object epoch) => ref.mounted && identical(_epoch, epoch);
  void active(bool visible) {
    if (!ref.mounted || _visible == visible) return;
    _visible = visible;
    if (visible) {
      refreshIfStale();
      if (_stream == null) _connect();
    } else {
      _connection = Object();
      unawaited(_stream?.cancel());
      _stream = null;
      _presence?.cancel();
      _presenceSelection?.cancel();
      _reconnect?.cancel();
      if (_location != null) {
        unawaited(
          repository.presence(location, id, leave: true).catchError((
            Object e,
            StackTrace st,
          ) {
            toReportedApiError(e, st, source: ReportSource.provider);
          }),
        );
      }
    }
  }

  @override
  Future<void> refresh({bool more = false, bool previous = false}) async {
    if (!ref.mounted ||
        state.deleted ||
        (state.loading && state.data != null)) {
      return;
    }
    if (more && state.data?.cursor == null) return;
    if (previous && _pageIndex == 0) return;
    final epoch = _epoch;
    final load = ++_load;
    final destination = more
        ? _pageIndex + 1
        : previous
        ? _pageIndex - 1
        : _pageIndex;
    final cursor = more ? state.data!.cursor : _cursors[destination];
    final offset = more
        ? _offsets[_pageIndex] + state.data!.document.rows.length
        : _offsets[destination];
    state = state.copy(
      loading: true,
      prefetching: false,
      prefetchError: () => null,
    );
    try {
      if (_location == null) {
        var document = ref.read(tablesControllerProvider).document(id);
        if (document == null) {
          await ref.read(tablesControllerProvider.notifier).ready;
          if (!_current(epoch)) return;
          document = ref.read(tablesControllerProvider).document(id);
        }
        if (document == null) {
          await ref
              .read(tablesControllerProvider.notifier)
              .reloadServer(keepPrevious: true);
          if (!_current(epoch)) return;
          document = ref.read(tablesControllerProvider).document(id);
        }
        if (document == null) {
          throw ref.read(tablesControllerProvider).error ??
              ApiError('tables.not_found');
        }
        _location = TableLocation(document.programId, document.unit);
        final choices = await ref.read(tableSharingChoicesProvider.future);
        if (!_current(epoch)) return;
        _account = choices.accountId;
      }
      final query = state.query;
      final page = await repository.workspace(
        location,
        id,
        _account,
        query: TableReadQuery(
          filters: query.filters,
          sorts: query.sorts,
          cursor: cursor,
          limit: _readLimit,
        ),
      );
      if (!_current(epoch) || load != _load) return;
      if (more) {
        if (page.cursor == cursor) throw invalidResponseError();
        _cursors.removeRange(destination, _cursors.length);
        _offsets.removeRange(destination, _offsets.length);
        _cursors.add(cursor);
        _offsets.add(offset);
      }
      _pageIndex = destination;
      state = state.copy(
        data: page,
        loading: false,
        error: () => null,
        page: _pageIndex + 1,
        offset: offset,
      );
      _eventCursor ??= page.sequence;
      _clock.markFresh();
      if (_stream == null) _connect();
      if (!_prefetched &&
          _pageIndex == 0 &&
          cursor == null &&
          _readLimit == 20) {
        _prefetched = true;
        if (page.cursor != null) unawaited(loadRemaining());
      }
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (!_current(epoch) || load != _load) return;
      state = state.copy(loading: false);
      if (error.code == 'tables.limit_reached' && _readLimit > 1) {
        _readLimit = (_readLimit ~/ 2).clamp(1, 200);
        final q = state.query;
        state = state.copy(
          query: TableReadQuery(
            filters: q.filters,
            sorts: q.sorts,
            cursor: q.cursor,
            limit: _readLimit,
          ),
        );
        await refresh(more: more, previous: previous);
        return;
      }
      if (error.code == 'tables.cursor_stale' && cursor != null) {
        _cursors
          ..clear()
          ..add(null);
        _offsets
          ..clear()
          ..add(0);
        _pageIndex = 0;
        final q = state.query;
        state = state.copy(
          query: TableReadQuery(
            filters: q.filters,
            sorts: q.sorts,
            limit: _readLimit,
          ),
          page: 1,
          offset: 0,
        );
        await refresh();
        return;
      }
      if (error.code == 'tables.not_found' ||
          error.code == 'tables.forbidden') {
        state = TableDetailState(
          loading: false,
          error: error,
          pending: _pending != null,
          busy: state.busy,
        );
        _connection = Object();
        unawaited(_stream?.cancel());
        _stream = null;
        _presence?.cancel();
      } else {
        state = state.copy(error: () => error);
      }
    }
  }

  /// Show the small first response immediately, then replace it with one coherent
  /// larger snapshot. Never merge pages from different sequences or queries.
  Future<void> loadRemaining() async {
    if (!ref.mounted ||
        state.data?.cursor == null ||
        _pageIndex != 0 ||
        state.query.cursor != null ||
        _readLimit >= 100 ||
        state.loading ||
        state.busy ||
        state.pending ||
        state.prefetching ||
        state.deleted) {
      return;
    }
    final epoch = _epoch;
    final load = _load;
    final query = state.query;
    state = state.copy(prefetching: true, prefetchError: () => null);
    try {
      final page = await repository.workspace(
        location,
        id,
        _account,
        query: TableReadQuery(
          filters: query.filters,
          sorts: query.sorts,
          limit: 100,
        ),
      );
      if (!_current(epoch) ||
          load != _load ||
          state.busy ||
          state.pending ||
          state.deleted) {
        return;
      }
      _readLimit = 100;
      state = state.copy(
        data: page,
        prefetching: false,
        prefetchError: () => null,
      );
      _clock.markFresh();
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (!_current(epoch) || load != _load) return;
      if (error.code == 'tables.not_found' ||
          error.code == 'tables.forbidden' ||
          [401, 403, 404].contains(error.status)) {
        state = TableDetailState(
          loading: false,
          error: error,
          pending: _pending != null,
          busy: state.busy,
        );
        _connection = Object();
        unawaited(_stream?.cancel());
        _stream = null;
        _presence?.cancel();
      } else {
        // The first 20 rows remain usable when 100 rows exceed the response budget.
        state = state.copy(
          prefetchError: () =>
              error.code == 'tables.limit_reached' ? null : error,
        );
      }
    } finally {
      if (_current(epoch) && load == _load && state.prefetching) {
        state = state.copy(prefetching: false);
      }
    }
  }

  void refreshIfStale() {
    if (_clock.isStale() &&
        !state.loading &&
        !state.busy &&
        state.error == null) {
      unawaited(refresh());
    }
  }

  Future<void> query(TableReadQuery query) async {
    if (state.loading || state.busy) return;
    final old = state.query;
    final cursors = List<String?>.of(_cursors);
    final offsets = List<int>.of(_offsets);
    final page = _pageIndex;
    final limit = _readLimit;
    final epoch = _epoch;
    _cursors
      ..clear()
      ..add(query.cursor);
    _offsets
      ..clear()
      ..add(0);
    _pageIndex = 0;
    _readLimit = query.limit;
    state = state.copy(query: query, page: 1, offset: 0);
    await refresh();
    if (_current(epoch) && state.error != null && state.data != null) {
      _cursors
        ..clear()
        ..addAll(cursors);
      _offsets
        ..clear()
        ..addAll(offsets);
      _pageIndex = page;
      _readLimit = limit;
      state = state.copy(query: old, page: page + 1, offset: offsets[page]);
    }
  }

  // Yeni satır konumu, pinli TABLES-K19 / ADR-0037 sözleşmesinde sequence × 2^20.
  // Kimliğe göre tek satır okuması olmadığından doğrudan son eklenen satıra bu imleçle gidilir.
  Future<void> _newRowPage(TableOperationReceipt receipt) async {
    final q = state.query;
    if (_pageIndex == 0 &&
        q.cursor == null &&
        q.filters.isEmpty &&
        q.sorts.isEmpty &&
        state.data?.cursor == null) {
      await refresh();
      if (state.data?.document.rows.any((r) => r.id == receipt.id) == true) {
        return;
      }
    }
    await query(
      TableReadQuery(
        cursor: '${((receipt.rowSequence ?? receipt.sequence) << 20) - 1}',
        limit: _readLimit,
      ),
    );
  }

  /// Başarısız/belirsiz komut aynı nesne ve anahtarla yeniden gönderilir.
  /// Bir komut başarıyla sonuçlanmadan başka bir yazım başlatılmaz.
  Future<TableOperationReceipt?> send(TableEdit edit) async {
    if (state.busy || (_pending != null && !identical(_pending!.edit, edit))) {
      return null;
    }
    _pending ??= _TablePendingWrite(
      edit: edit,
      location: location,
      key: newRequestKey(),
    );
    _pendingHold ??= ref.keepAlive();
    return _sendPending();
  }

  Future<TableOperationReceipt?> perform(
    Future<TableOperationReceipt> Function(String) call, {
    bool focusRow = false,
    bool Function()? retainOnError,
  }) async {
    if (state.busy || _pending != null) return null;
    _pending = _TablePendingWrite(
      external: call,
      focusRow: focusRow,
      retainOnError: retainOnError,
      location: location,
      key: newRequestKey(),
    );
    _pendingHold ??= ref.keepAlive();
    return _sendPending();
  }

  Future<TableOperationReceipt?> _sendPending() async {
    if (_pending == null || state.busy) return null;
    final epoch = _epoch;
    final pending = _pending!;
    final edit = pending.edit;
    state = state.copy(busy: true, pending: true, error: () => null);
    try {
      final result = edit != null
          ? await repository.execute(pending.location, id, edit, pending.key)
          : await pending.external!(pending.key);
      if (!_current(epoch)) return null;
      _pending = null;
      _pendingHold?.close();
      _pendingHold = null;
      state = state.copy(
        busy: false,
        pending: false,
        undo: edit is WriteTableCells
            ? () => result.sequence
            : edit is UndoTableCells
            ? () => null
            : null,
      );
      ref.read(tablesControllerProvider.notifier).markServerChanged();
      if (edit is TransferTable && edit.action == TableTransferAction.move) {
        _connection = Object();
        _reconnect?.cancel();
        state = state.copy(participants: [], live: false);
        unawaited(_stream?.cancel());
        _stream = null;
        _presence?.cancel();
        _location = edit.target;
        _selectedRow = null;
        _selectedColumn = null;
        ref
            .read(tablesControllerProvider.notifier)
            .setArea(location.personal ? TableArea.personal : TableArea.coord);
        ref
            .read(tablesControllerProvider.notifier)
            .setUnit(location.personal ? null : location.departmentId);
      }
      if (edit is DeleteTable) {
        _connection = Object();
        _reconnect?.cancel();
        unawaited(_stream?.cancel());
        _stream = null;
        _presence?.cancel();
        state = const TableDetailState(loading: false, deleted: true);
      } else {
        if (edit is AddTableRow || pending.focusRow) {
          await _newRowPage(result);
        } else {
          await refresh();
        }
        unawaited(_sync());
      }
      return result;
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (_current(epoch)) {
        // Açık iş reddi tekrar beklemez; ağ/5xx'te aynı anahtar saklanır.
        final unknown =
            isOutcomeUnknown(error) || error.code == 'client.invalid_response';
        if (unknown) pending.uncertain = true;
        final denied =
            error.code == 'tables.not_found' ||
            error.code == 'tables.forbidden' ||
            [401, 403, 404].contains(error.status);
        if (!unknown &&
            !(pending.uncertain && denied) &&
            pending.retainOnError?.call() != true) {
          _pending = null;
          _pendingHold?.close();
          _pendingHold = null;
        }
        state = state.copy(
          busy: false,
          pending: _pending != null,
          error: () => error,
          undo:
              error.code == 'tables.undo_expired' ||
                  error.code == 'tables.undo_conflict'
              ? () => null
              : null,
        );
      }
      return null;
    }
  }

  void abandonPending() {
    if (state.busy) return;
    _pending = null;
    _pendingHold?.close();
    _pendingHold = null;
    state = state.copy(
      pending: false,
      error: state.data == null ? null : () => null,
    );
  }

  bool Function() captureGuard() {
    final epoch = _epoch;
    return () => _current(epoch);
  }

  Future<TableOperationReceipt?> retry() => _sendPending();
  Future<TableOperationReceipt?> share(
    Map<TablePersonId, TableAccess> people, {
    bool revoke = false,
  }) {
    final plan = List<MapEntry<TablePersonId, TableAccess>>.of(people.entries);
    final epoch = _epoch;
    final target = location;
    final repo = repository;
    final keys = [for (final _ in plan) newRequestKey()];
    return perform((_) async {
      TableOperationReceipt? result;
      for (var i = 0; i < plan.length; i++) {
        if (!_current(epoch)) throw ApiError('client.scope_changed');
        result = await repo.execute(
          target,
          id,
          GrantTableAccess(
            plan[i].key.value,
            revoke ? TableAccess.off : plan[i].value,
          ),
          keys[i],
        );
      }
      return result!;
    });
  }
}

class _TablePendingWrite {
  _TablePendingWrite({
    this.edit,
    this.external,
    this.focusRow = false,
    this.retainOnError,
    required this.location,
    required this.key,
  });
  final TableEdit? edit;
  final Future<TableOperationReceipt> Function(String)? external;
  final TableLocation location;
  final String key;
  final bool focusRow;
  final bool Function()? retainOnError;
  bool uncertain = false;
}
