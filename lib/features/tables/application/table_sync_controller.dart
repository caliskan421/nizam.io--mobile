import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/stream_reconnect.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_models.dart';
import '../domain/tables_repository.dart';
import 'table_controller.dart';
import 'table_view.dart';
import 'tables_providers.dart';

part 'table_sync_controller.g.dart';

/// Canlı bağlantının durumu (ekrandaki gösterge).
enum TableLiveStatus {
  /// Akış kapalı (arka plan, tablo yüklenmedi, dinleyen ekran yok).
  idle,
  connecting,
  live,

  /// Bağlantı düştü; geri çekilmeyle yeniden bağlanılacak.
  retrying,

  /// Durdu (yetki/kapsam hatası ya da ardışık başarısızlık sınırı); ekran yeniden açılınca
  /// ya da uygulama ön plana dönünce yeniden denenir.
  offline,
}

@immutable
final class TableLiveState {
  TableLiveState({
    this.status = TableLiveStatus.idle,
    List<TableParticipant> participants = const [],
  }) : participants = List.unmodifiable(participants);

  final TableLiveStatus status;

  /// Tabloda bulunan diğer oturumlar (sunucunun tam listesi; kendi oturumumuz yoktur).
  final List<TableParticipant> participants;

  TableLiveState copyWith({
    TableLiveStatus? status,
    List<TableParticipant>? participants,
  }) => TableLiveState(
    status: status ?? this.status,
    participants: participants ?? this.participants,
  );
}

/// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
/// görünürken ve uygulama ön plandayken açıktır.
///
/// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
/// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
/// - Presence: bağlıyken 10 sn'de bir ve seçim değişince; hepsi tek kapıdan (tek uçuş,
///   en az 1 sn aralık, 429 `Retry-After`) `POST …/presence`; kapanışta `DELETE`.
@riverpod
class TableSyncController extends _$TableSyncController {
  TableLiveTiming get _timing => ref.read(tableLiveTimingProvider);

  late String _id;
  var _gen = 0;
  var _failures = 0;
  StreamSubscription<TableStreamEvent>? _sub;
  Timer? _sleepTimer;
  Completer<void>? _wake;
  DateTime? _holdUntil;

  Timer? _coalesceTimer;

  /// Uçuştaki yakalamanın nesli; bekleyen yakalama talebinin nesli. İkisi de nesle bağlıdır:
  /// eski neslin uçuşu yeni neslin (`ready`) talebini tüketmez.
  int? _syncingGen;
  int? _againGen;

  Timer? _presenceTimer;
  Timer? _presenceLater;
  DateTime? _presenceSent;
  bool _presenceOn = false;
  bool _presenceInFlight = false;
  bool _presenceDirty = false;
  DateTime? _presenceBlockedUntil;
  ({String rowId, String columnId})? _selection;

  // Kapanışta (onDispose) ref okunamaz: presence silme bunlarla yapılır.
  TablesRepository? _repo;
  TableScope? _scope;

  @override
  TableLiveState build(String id) {
    _id = id;
    // Oturum/kapsam değişince tablo da yeniden kurulur; akış eski kapsamla sürmez.
    ref
      ..watch(sessionGenerationProvider)
      ..watch(scopeStateProvider)
      ..onDispose(() => _stop(leave: true))
      ..listen(tablesForegroundProvider, (_, foreground) {
        if (foreground) {
          _start();
        } else {
          _stop(leave: true);
          _setStatus(TableLiveStatus.idle);
        }
      })
      ..listen<AsyncValue<TableView>>(tableControllerProvider(id), (
        prev,
        next,
      ) {
        // Tablo ilk kez yüklendi: akış açılır.
        if (!(prev?.hasValue ?? false) && next.hasValue) _start();
      });
    _failures = 0;
    final loaded = ref.read(tableControllerProvider(id)).hasValue;
    if (!loaded || !ref.read(tablesForegroundProvider)) return TableLiveState();
    unawaited(_run(++_gen));
    return TableLiveState(status: TableLiveStatus.connecting);
  }

  TableController get _table => ref.read(tableControllerProvider(_id).notifier);
  DateTime _now() => ref.read(tablesClockProvider)();

  void _setStatus(TableLiveStatus s, [int? gen]) {
    if (!ref.mounted || (gen != null && gen != _gen)) return;
    if (state.status != s) state = state.copyWith(status: s);
  }

  void _start() {
    _stop(leave: false);
    _failures = 0;
    if (!ref.read(tablesForegroundProvider) ||
        !ref.read(tableControllerProvider(_id)).hasValue) {
      return;
    }
    _setStatus(TableLiveStatus.connecting);
    unawaited(_run(++_gen));
  }

  void _stop({required bool leave}) {
    _gen++;
    unawaited(_sub?.cancel());
    _sub = null;
    _sleepTimer?.cancel();
    _sleepTimer = null;
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
    _wake = null;
    _coalesceTimer?.cancel();
    _coalesceTimer = null;
    _presenceOff(leave: leave);
  }

  Future<void> _run(int gen) async {
    while (gen == _gen && ref.mounted) {
      final hold = _holdUntil;
      if (hold != null && hold.isAfter(_now())) {
        _setStatus(TableLiveStatus.retrying, gen);
        await _sleep(hold.difference(_now()));
        continue;
      }
      DateTime? openedAt;
      Object? error;
      final done = _wake = Completer<void>();
      final repo = ref.read(tablesRepositoryProvider);
      final scope = _table.scope;
      _repo = repo;
      _scope = scope;
      _sub = repo
          .stream(scope, _id)
          .listen(
            (e) {
              if (gen != _gen) return;
              switch (e) {
                case TableStreamReady(:final sequence):
                  openedAt = _now();
                  _setStatus(TableLiveStatus.live, gen);
                  _presenceOnStart();
                  _hint(sequence, force: true);
                case TableStreamChanged(:final sequence):
                  _hint(sequence);
                case TablePresenceUpdate(:final participants):
                  if (ref.mounted) {
                    state = state.copyWith(participants: participants);
                  }
              }
            },
            onError: (Object e, StackTrace st) {
              reportUnexpected(
                e,
                st,
                source: ReportSource.tables,
                operation: ReportOperation.tableStream,
              );
              error = e;
              if (!done.isCompleted) done.complete();
            },
            onDone: () {
              if (!done.isCompleted) done.complete();
            },
            cancelOnError: true,
          );
      await done.future;
      if (gen != _gen || !ref.mounted) return;
      _sub = null;
      _presenceOff(leave: false);
      if (ref.mounted) state = state.copyWith(participants: const []);
      final opened = openedAt;
      if (error case final e?) {
        final api = e is ApiError ? e : ApiError(ClientErrorCode.networkError);
        if (streamErrorAction(status: api.status, code: api.code) ==
            StreamErrorAction.stop) {
          return _setStatus(TableLiveStatus.offline, gen);
        }
        if (api.retryAfter case final wait?) _holdUntil = _now().add(wait);
      }
      _failures = nextFailures(
        _failures,
        lived: opened == null ? null : _now().difference(opened),
      );
      if (_failures > StreamReconnect.maxFailures) {
        return _setStatus(TableLiveStatus.offline, gen);
      }
      _setStatus(TableLiveStatus.retrying, gen);
      await _sleep(ref.read(tableReconnectDelayProvider)(_failures));
    }
  }

  Future<void> _sleep(Duration d) {
    final wake = _wake = Completer<void>();
    _sleepTimer = Timer(d, () {
      if (!wake.isCompleted) wake.complete();
    });
    return wake.future;
  }

  // ---------------------------------------------------------------- yakalama

  /// Sıra ipucu. Tüketilmiş imleçten büyük değilse (çift/eski ipucu) bir şey yapmaz;
  /// `ready` her zaman yakalar (kopukken kaçan olay olabilir). Uçuşta yakalama varsa tek
  /// bekleyen işaretlenir.
  void _hint(int sequence, {bool force = false}) {
    if (!force && sequence <= _table.cursor) return;
    final gen = _gen;
    if (_syncingGen == gen) {
      _againGen = gen;
      return;
    }
    _coalesceTimer ??= Timer(_timing.coalesce, () {
      _coalesceTimer = null;
      if (gen == _gen) unawaited(_sync(gen));
    });
  }

  /// Nesil başına tek uçuşlu yakalama. Bu arada akış durdurulduysa (nesil değişti) bekleyen
  /// yakalama kurulmaz; yeni neslin talebi kendi yakalamasını kurar.
  Future<void> _sync(int gen) async {
    if (!ref.mounted) return;
    _syncingGen = gen;
    try {
      await _table.catchUp();
    } on Object catch (e, st) {
      // Yakalama düştü (ağ vb.): imleç ilerlemedi; sonraki ipucu ya da yeniden bağlanma
      // aynı olayları yeniden işler.
      reportUnexpected(e, st, source: ReportSource.tables);
    } finally {
      if (_syncingGen == gen) _syncingGen = null;
    }
    if (_againGen == gen && gen == _gen && ref.mounted) {
      _againGen = null;
      _hint(0, force: true);
    }
  }

  // ---------------------------------------------------------------- presence

  /// Kullanıcının seçili hücresi (null → tabloda bulunuyor, seçim yok).
  void select(String? rowId, String? columnId) {
    final next = rowId == null || columnId == null
        ? null
        : (rowId: rowId, columnId: columnId);
    if (next == _selection) return;
    _selection = next;
    _requestPresence();
  }

  void _presenceOnStart() {
    if (_presenceOn) return;
    _presenceOn = true;
    _requestPresence();
    _presenceTimer = Timer.periodic(
      _timing.presenceInterval,
      (_) => _requestPresence(),
    );
  }

  void _presenceOff({required bool leave}) {
    _presenceTimer?.cancel();
    _presenceTimer = null;
    _presenceLater?.cancel();
    _presenceLater = null;
    _presenceDirty = false;
    final wasOn = _presenceOn && _presenceSent != null;
    _presenceOn = false;
    if (leave && wasOn) unawaited(_leavePresence());
  }

  /// Bütün presence gönderimlerinin (açılış, periyodik, seçim) TEK kapısı: aynı anda tek
  /// istek; son gönderimden en az `presenceMinGap`; 429 `Retry-After` süresince gönderim yok.
  /// Erken istek en erken ana ertelenir ve o andaki seçimi taşır.
  void _requestPresence() {
    if (!_presenceOn || !ref.mounted) return;
    if (_presenceInFlight) {
      _presenceDirty = true;
      return;
    }
    if (_presenceLater != null) return;
    final now = _now();
    final last = _presenceSent;
    var at = last == null ? now : last.add(_timing.presenceMinGap);
    final blocked = _presenceBlockedUntil;
    if (blocked != null && blocked.isAfter(at)) at = blocked;
    if (at.isAfter(now)) {
      _presenceLater = Timer(at.difference(now), () {
        _presenceLater = null;
        _requestPresence();
      });
      return;
    }
    unawaited(_sendPresence());
  }

  Future<void> _sendPresence() async {
    final repo = _repo;
    final scope = _scope;
    if (repo == null || scope == null) return;
    _presenceInFlight = true;
    _presenceSent = _now();
    final sel = _selection;
    try {
      await repo.setPresence(
        scope,
        _id,
        rowId: sel?.rowId,
        columnId: sel?.columnId,
      );
    } on Object catch (e, st) {
      // Presence yakınsama kaynağı değildir: hata raporlanır; 429 sonraki gönderimi bekletir.
      reportUnexpected(e, st, source: ReportSource.tables);
      if (e is ApiError && e.retryAfter != null) {
        _presenceBlockedUntil = _now().add(e.retryAfter!);
      }
    } finally {
      _presenceInFlight = false;
    }
    if (_presenceDirty) {
      _presenceDirty = false;
      _requestPresence();
    }
  }

  Future<void> _leavePresence() async {
    final repo = _repo;
    final scope = _scope;
    if (repo == null || scope == null) return;
    try {
      await repo.leavePresence(scope, _id);
    } on Object catch (e, st) {
      // Kayıt 30 sn TTL ile kendiliğinden düşer.
      reportUnexpected(e, st, source: ReportSource.tables);
    }
  }
}
