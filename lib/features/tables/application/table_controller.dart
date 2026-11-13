import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/session/session_state.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_models.dart';
import '../domain/table_operation.dart';
import '../domain/table_reference_sources.dart';
import '../domain/tables_repository.dart';
import 'table_view.dart';
import 'table_write_queue.dart';
import 'tables_list_controller.dart';
import 'tables_providers.dart';

part 'table_cell_writes.dart';
part 'table_commands.dart';
part 'table_controller.g.dart';

/// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
/// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
///
/// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
/// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
/// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
/// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
///
/// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
/// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
/// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
/// sonraki yakalama tabloyu yeniden okur.
@riverpod
class TableController extends _$TableController {
  static const pageSize = 200;
  static const writeDebounce = Duration(seconds: 1);

  late TableScope _scope;
  late String _id;
  int _generation = 0;
  TableView? _base;
  int _viewSequence = 0;
  Future<void> _reloadTail = Future.value();
  bool _needsReload = false;

  /// Kendi komut makbuzlarıyla doğrulanmış en yüksek sıra: daha eski snapshot tabanı
  /// (metadata: ad, sütunlar, satırlar) geri alamaz; atılır ve taze okuma gereksinimi kalır.
  int _confirmedSequence = 0;

  /// Alan başına makbuzla uygulanmış en yüksek sıra (snapshot sırası yapay ilerletilmez).
  final _fieldSequence = <_MetaField, int>{};

  /// Sonucu bilinmeyen komutlar: işlem nesnesi + anahtarı ([retryCommands] aynısını yollar).
  final _uncertain = <_PendingCommand>[];

  final _queue = TableWriteQueue();
  _Batch? _batch;
  bool _batchHeld = false;
  Timer? _debounce;
  Timer? _hold;
  KeepAliveLink? _alive;
  Future<void>? _flushing;

  /// Kendi makbuzlarımızın sıraları (yankı ayrımı, [catchUp]).
  final ownSequences = <int>{};

  int _cursor = 0;

  /// Tüketilmiş olay imleci (monoton).
  int get cursor => _cursor;

  /// İsteklerin kapsamı (akış ve presence aynı kapsamla açılır).
  TableScope get scope => _scope;

  @override
  Future<TableView> build(String id) async {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    ref.onDispose(() {
      _debounce?.cancel();
      _hold?.cancel();
    });
    _id = id;
    ++_generation;
    _uncertain.clear();
    _confirmedSequence = 0;
    _fieldSequence.clear();
    _queue.clear();
    _batch = null;
    _batchHeld = false;
    _needsReload = false;
    _reloadTail = Future.value();
    ownSequences.clear();
    _scope = await _resolveScope(id);
    final page = await _repo.snapshot(
      _scope,
      id,
      page: const PageRequest(limit: pageSize),
    );
    _cursor = page.meta.sequence;
    _viewSequence = page.meta.sequence;
    final base = _base = TableView.fromPage(page, _accountId);
    return base;
  }

  TablesRepository get _repo => ref.read(tablesRepositoryProvider);

  String? get _accountId => switch (ref.read(sessionStateProvider)) {
    SessionActive(:final accountId) => accountId,
    _ => null,
  };

  /// Kapsam: listede görülen tablonun kendi alanı; yoksa (derin bağlantı) seçili
  /// koordinatörlük, 404'te kişisel alan denenir (alanlar arası kimlik 404'tür, K-11).
  Future<TableScope> _resolveScope(String id) async {
    if (ref.exists(tablesListControllerProvider)) {
      final known = ref.read(tablesListControllerProvider).value?.find(id);
      if (known != null) return known.scope;
    }
    final s = ref.read(scopeStateProvider);
    final (coord, personal) = TablesListController.scopesOf(
      s.programId,
      s.departmentId,
    );
    if (coord != null) {
      try {
        await _repo.snapshot(coord, id, page: const PageRequest(limit: 1));
        return coord;
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.tables);
        if (e.code != 'tables.not_found' || personal == null) rethrow;
      }
    }
    if (personal == null) throw ApiError(ClientErrorCode.scopeMissing);
    return personal;
  }

  // `ref` korumalıdır; parça dosyalardaki uzantılar bu kapılardan erişir.
  bool get _mounted => ref.mounted;
  KeepAliveLink _keepAlive() => ref.keepAlive();
  TablesListController? get _listOrNull =>
      ref.exists(tablesListControllerProvider)
      ? ref.read(tablesListControllerProvider.notifier)
      : null;

  /// Tabanı değiştirip görünümü (taban + bekleyen düzenlemeler) yayımlar.
  void _update(TableView Function(TableView base) change) {
    final b = _base;
    if (b == null || !ref.mounted) return;
    _base = change(b);
    _publish();
  }

  void _publish() {
    final b = _base;
    if (b != null && ref.mounted) state = AsyncData(_overlay(b));
  }

  /// Bekleyen ve uçuştaki düzenlemeleri tabanın üstüne uygular.
  TableView _overlay(TableView v) {
    final cells = Map.of(v.cells);
    for (final w in [...?_batch?.cells, ..._queue.pending]) {
      final server = cells[w.key] ?? TableCellData.empty;
      cells[w.key] = TableCellData(value: w.value, version: server.version);
    }
    return v.copyWith(
      cells: cells,
      pendingWrites: _queue.length + (_batch?.cells.length ?? 0),
      writesHeld: _batch != null && _batchHeld,
    );
  }

  // ---------------------------------------------------------------- okuma

  /// Sonraki satır sayfası. Tablo bu arada değiştiyse (sayfanın sırası uygulanmış
  /// snapshot'tan büyük) tutarlılık için baştan okunur.
  Future<void> loadMore() async {
    final v = _base;
    if (v == null || !v.hasMore || v.loadingMore) return;
    final generation = _generation;
    _update((b) => b.copyWith(loadingMore: true));
    try {
      final page = await _repo.snapshot(
        _scope,
        _id,
        page: PageRequest(limit: pageSize, cursor: v.nextCursor),
      );
      if (generation != _generation || !ref.mounted) return;
      if (page.meta.sequence != _viewSequence) {
        _update((b) => b.copyWith(loadingMore: false));
        await _reload(minRows: v.rows.length + page.rows.length);
        return;
      }
      _update((b) => b.appendPage(page).copyWith(loadingMore: false));
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation == _generation && ref.mounted) {
        _update((b) => b.copyWith(loadingMore: false));
      }
      rethrow;
    }
  }

  /// Snapshot okumalarını sıraya dizer (eski okuma yeni okumadan sonra bitemez).
  Future<void> _reload({int? minRows}) {
    final run = _reloadTail.then((_) => _readSnapshot(minRows: minRows));
    _reloadTail = run.then<void>((_) {}, onError: (Object _) {});
    return run;
  }

  /// Tabloyu yeniden okur (en az [minRows] satıra kadar). Sayfalar boyunca `table.sequence`
  /// değişirse yürüyüş baştan alınır (en çok 3 kez). Uygulanmış snapshot'tan eski sonuç
  /// atılır; hücre sürümü geri gitmez (sonradan gelmiş kendi makbuzumuz korunur). İmleç
  /// snapshot sırasına ilerler; atlanan aralıkta yorum olayı olabileceği için yorum sayacı
  /// artar. Tabanı sunucuda değişmiş bekleyen düzenleme çakışma olarak işaretlenir.
  Future<void> _readSnapshot({int? minRows}) async {
    final generation = _generation;
    // Ref yalnız başta okunur: arka planda süren okuma sağlayıcı bırakıldıktan sonra ref'e
    // dokunmaz.
    final account = _accountId;
    final repo = _repo;
    final want = minRows ?? _base?.rows.length ?? 0;
    TableView? next;
    var sequence = 0;
    for (var attempt = 0; attempt < 3 && next == null; attempt++) {
      var page = await repo.snapshot(
        _scope,
        _id,
        page: const PageRequest(limit: pageSize),
      );
      sequence = page.meta.sequence;
      var walk = TableView.fromPage(page, account);
      var stable = true;
      while (walk.rows.length < want && page.nextCursor != null) {
        page = await repo.snapshot(
          _scope,
          _id,
          page: PageRequest(limit: pageSize, cursor: page.nextCursor),
        );
        if (page.meta.sequence != sequence) {
          stable = false;
          break;
        }
        walk = walk.appendPage(page);
      }
      if (stable || attempt == 2) next = walk;
    }
    if (generation != _generation || !ref.mounted) return;
    final base = _base;
    if (base == null || sequence < _viewSequence) return;
    if (sequence < _confirmedSequence) {
      // Kendi doğrulanmış komutumuzdan eski: tabanı geri almaz, taze okuma gerekir.
      _needsReload = true;
      return;
    }
    _needsReload = false;
    _viewSequence = sequence;
    // Snapshot bu sıraya kadar her alanı içerir: altında kalan alan kayıtları gereksiz.
    _fieldSequence.removeWhere((_, s) => s <= sequence);
    final skipped = sequence > _cursor;
    if (skipped) _cursor = sequence;
    final rows = {for (final r in next!.rows) r.id};
    final cols = {for (final c in next.columns) c.id};
    final cells = Map.of(next.cells);
    for (final e in base.cells.entries) {
      final fresh = cells[e.key];
      final keep =
          e.value.version > (fresh?.version ?? 0) &&
          base.rows.any(
            (r) => rows.contains(r.id) && _isRowOf(e.key, r.id, cols),
          );
      if (keep) cells[e.key] = e.value;
    }
    final conflicts = {...base.conflicts};
    for (final w in _queue.pending) {
      // Uçuştaki batch'teki hücre: karar makbuzla verilir (kendi yazımımız olabilir).
      if (_batch?.has(w.key) ?? false) continue;
      final server = cells[w.key] ?? TableCellData.empty;
      if (server.version != w.version) conflicts.add(w.key);
    }
    _base = next.copyWith(
      cells: cells,
      readOnly: base.readOnly,
      conflicts: conflicts,
      writeError: () => base.writeError,
      undoSequence: () => base.undoSequence,
      commentsRevision: base.commentsRevision + (skipped ? 1 : 0),
      accessLost: base.accessLost,
      uncertainCommands: base.uncertainCommands,
      deleted: base.deleted,
    );
    _publish();
  }

  static bool _isRowOf(TableCellKey key, String row, Set<String> cols) =>
      cols.any((c) => key == TableCellKey(row, c));

  /// Olay günlüğünden yakalama (`GET …/changes?after=cursor`). Yeni olayların hepsi kendi
  /// makbuzlarımızsa snapshot okunmaz (yankı); yabancı yapı/hücre olayı varsa (ya da önceki
  /// yan okuma düşmüşse) tablo yeniden okunur; yorum olayları yorum sayacını artırır. İmleç
  /// yalnız bu güncellemeler başarıyla bitince ilerler: okuma düşerse hata fırlar, imleç yerinde
  /// kalır, sonraki yakalama aynı olayları yeniden işler. 409 `tables.replay_expired` → tam
  /// yeniden yükleme; 403/404 → erişim kaybı. Döner: yeniden okuma yapıldı mı.
  Future<bool> catchUp() async {
    final generation = _generation;
    var target = _cursor;
    var reload = _needsReload;
    var comments = false;
    try {
      while (true) {
        final page = await _repo.changes(
          _scope,
          _id,
          after: target,
          limit: pageSize,
        );
        if (generation != _generation || !ref.mounted) return false;
        for (final e in page.changes) {
          if (e.seq <= target) continue;
          switch (e.kind) {
            case TableChangeKind.addComment ||
                TableChangeKind.editComment ||
                TableChangeKind.deleteComment:
              comments = true;
            default:
              if (!ownSequences.contains(e.seq)) reload = true;
          }
        }
        if (page.cursor > target) target = page.cursor;
        if (!page.more || page.changes.isEmpty) break;
      }
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation != _generation || !ref.mounted) return false;
      if (e.code == 'tables.replay_expired') {
        await _reload();
        _bumpComments();
        return true;
      }
      if (e.code == 'tables.not_found' || e.code == 'tables.forbidden') {
        _update((b) => b.copyWith(accessLost: true));
        return false;
      }
      rethrow;
    }
    if (reload) await _reload();
    if (_needsReload) {
      // Okuma eski bir snapshot döndü (doğrulanmış komutun gerisinde): imleç ilerlemez.
      return false;
    }
    if (generation != _generation || !ref.mounted) return false;
    if (comments) _bumpComments();
    _cursor = math.max(_cursor, target);
    return reload;
  }

  void _bumpComments() =>
      _update((b) => b.copyWith(commentsRevision: b.commentsRevision + 1));

  /// Ekranın tazelemesi (yenileme hareketi): bekleyen yazımlar önce gönderilir.
  Future<void> refresh() async {
    await flush();
    await _reload();
  }
}
