import 'dart:async';

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
import '../domain/tables_repository.dart';
import 'table_view.dart';
import 'table_write_queue.dart';
import 'tables_list_controller.dart';
import 'tables_providers.dart';

part 'table_cell_writes.dart';
part 'table_controller.g.dart';

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
/// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
///
/// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
/// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
/// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.
@riverpod
class TableController extends _$TableController {
  static const pageSize = 200;
  static const writeDebounce = Duration(seconds: 1);

  late TableScope _scope;
  late String _id;
  int _generation = 0;
  RequestKeys _keys = const RequestKeys();
  final _queue = TableWriteQueue();
  List<TableCellWrite>? _inflight;
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
    _keys = const RequestKeys();
    _queue.clear();
    _inflight = null;
    ownSequences.clear();
    _scope = await _resolveScope(id);
    final page = await _repo.snapshot(
      _scope,
      id,
      page: const PageRequest(limit: pageSize),
    );
    _cursor = page.meta.sequence;
    return TableView.fromPage(page, _accountId);
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

  TableView? get _view => state.value;

  // `ref` korumalıdır; parça dosyadaki uzantı bu iki kapıdan erişir.
  bool get _mounted => ref.mounted;
  KeepAliveLink _keepAlive() => ref.keepAlive();

  void _set(TableView v) {
    if (ref.mounted) state = AsyncData(v);
  }

  // ---------------------------------------------------------------- okuma

  /// Sonraki satır sayfası. Tablo bu arada başkası tarafından değiştiyse (sayfanın sırası
  /// bildiğimizden büyük) tutarlılık için baştan okunur.
  Future<void> loadMore() async {
    final v = _view;
    if (v == null || !v.hasMore || v.loadingMore) return;
    final generation = _generation;
    _set(v.copyWith(loadingMore: true));
    try {
      final page = await _repo.snapshot(
        _scope,
        _id,
        page: PageRequest(limit: pageSize, cursor: v.nextCursor),
      );
      if (generation != _generation || !ref.mounted) return;
      final now = _view!;
      if (page.meta.sequence > now.meta.sequence) {
        await _reload(minRows: now.rows.length + page.rows.length);
        return;
      }
      _set(_overlay(now.appendPage(page)));
    } on ApiError {
      if (generation == _generation && ref.mounted) {
        _set(_view!.copyWith(loadingMore: false));
      }
      rethrow;
    }
  }

  /// Tabloyu yeniden okur (en az [minRows] satıra kadar sayfa yürür). Sayfalar boyunca
  /// `table.sequence` değişirse (arada commit) yürüyüş baştan alınır (en çok 3 kez); imleç
  /// tutarlı snapshot'ın sırasına ilerler. Bekleyen yerel düzenlemeler sonucun üstüne
  /// yeniden uygulanır; tabanı sunucuda değişmiş bekleyen hücre çakışma olarak işaretlenir.
  Future<void> _reload({int? minRows}) async {
    final generation = _generation;
    final want = minRows ?? _view?.rows.length ?? 0;
    TableView? next;
    var sequence = 0;
    for (var attempt = 0; attempt < 3 && next == null; attempt++) {
      var page = await _repo.snapshot(
        _scope,
        _id,
        page: const PageRequest(limit: pageSize),
      );
      sequence = page.meta.sequence;
      var walk = TableView.fromPage(page, _accountId);
      var stable = true;
      while (walk.rows.length < want && page.nextCursor != null) {
        page = await _repo.snapshot(
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
    if (sequence > _cursor) _cursor = sequence;
    final base = _view;
    final conflicts = {...?base?.conflicts};
    for (final w in _queue.pending) {
      final server = next!.cells[w.key] ?? TableCellData.empty;
      if (w.version >= 0 && server.version != w.version) conflicts.add(w.key);
    }
    _set(
      _overlay(
        next!.copyWith(
          readOnly: base?.readOnly,
          conflicts: conflicts,
          writeError: () => base?.writeError,
          undoSequence: () => base?.undoSequence,
          commentsRevision: base?.commentsRevision,
          accessLost: base?.accessLost,
        ),
      ),
    );
  }

  /// Olay günlüğünden yakalama (`GET …/changes?after=cursor`). Yeni olayların hepsi kendi
  /// makbuzlarımızsa snapshot okunmaz (yankı); yabancı yapı/hücre olayı varsa tablo yeniden
  /// okunur; yorum olayları yalnız [TableView.commentsRevision]'ı artırır. Uçuşta hücre
  /// yazımı varken makbuzu gelmemiş kendi olayımız yabancı sayılır (güvenli taraf: yeniden
  /// okuma bekleyen düzenlemeleri ezmez). 409 `tables.replay_expired` → tam yeniden yükleme;
  /// 403/404 → erişim kaybı. Döner: yeniden okuma yapıldı mı.
  Future<bool> catchUp() async {
    final generation = _generation;
    var reload = false;
    var comments = false;
    try {
      while (true) {
        final page = await _repo.changes(
          _scope,
          _id,
          after: _cursor,
          limit: pageSize,
        );
        if (generation != _generation || !ref.mounted) return false;
        for (final e in page.changes) {
          if (e.seq <= _cursor) continue;
          switch (e.kind) {
            case TableChangeKind.addComment ||
                TableChangeKind.editComment ||
                TableChangeKind.deleteComment:
              comments = true;
            default:
              if (!ownSequences.contains(e.seq)) reload = true;
          }
        }
        if (page.cursor > _cursor) _cursor = page.cursor;
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
        final v = _view;
        if (v != null) _set(v.copyWith(accessLost: true));
        return false;
      }
      rethrow;
    }
    if (reload) await _reload();
    if (comments) _bumpComments();
    return reload;
  }

  void _bumpComments() {
    final v = _view;
    if (v != null) _set(v.copyWith(commentsRevision: v.commentsRevision + 1));
  }

  /// Bekleyen ve uçuştaki düzenlemeleri görünümün üstüne uygular.
  TableView _overlay(TableView v) {
    final cells = Map.of(v.cells);
    for (final w in [...?_inflight, ..._queue.pending]) {
      final server = cells[w.key] ?? TableCellData.empty;
      cells[w.key] = TableCellData(value: w.value, version: server.version);
    }
    return v.copyWith(
      cells: cells,
      pendingWrites: _queue.length + (_inflight?.length ?? 0),
    );
  }

  /// Ekranın tazelemesi (yenileme hareketi): bekleyen yazımlar önce gönderilir.
  Future<void> refresh() async {
    await flush();
    await _reload();
  }

  // ---------------------------------------------------------------- komutlar

  /// Komutu gönderir (önce bekleyen hücreler). Hata fırlar; sonucu bilinmeyen hatada aynı
  /// komutun yeniden denenmesi aynı anahtarı kullanır. 403 tabloyu salt okunur yapar,
  /// 409 `tables.schema_conflict` sütunları yeniden okutur.
  Future<TableReceipt> _command(TableOperation op, {bool reload = true}) async {
    await flush();
    const action = 'op';
    final (keys, key) = _keys.keyFor(action, op.signature);
    _keys = keys;
    final generation = _generation;
    try {
      final r = await _repo.apply(_scope, _id, op, requestKey: key);
      _keys = _keys.clear(action);
      ownSequences.add(r.sequence);
      if (generation == _generation && ref.mounted) {
        final v = _view!;
        _set(
          v.copyWith(
            meta: v.meta.copyWith(
              sequence: r.sequence > v.meta.sequence ? r.sequence : null,
              schemaVersion: r.schemaVersion,
            ),
          ),
        );
        if (reload) await _reload();
      }
      return r;
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (!isOutcomeUnknown(e)) _keys = _keys.clear(action);
      if (generation == _generation && ref.mounted) {
        if (e.code == 'tables.forbidden') {
          _set(_view!.copyWith(readOnly: true));
        } else if (e.code == 'tables.schema_conflict') {
          await _reload();
        }
      }
      rethrow;
    }
  }

  int get _schema => _view!.meta.schemaVersion;

  Future<void> rename(String name) async {
    final trimmed = name.trim();
    await _command(RenameTable(trimmed), reload: false);
    final v = _view;
    if (v != null) _set(v.copyWith(meta: v.meta.copyWith(name: trimmed)));
    if (ref.exists(tablesListControllerProvider)) {
      ref.read(tablesListControllerProvider.notifier).renamed(_id, trimmed);
    }
  }

  /// Yalnız sahip; başarıda listeden düşer.
  Future<void> deleteTable() async {
    _queue.clear();
    await _command(const DeleteTable(), reload: false);
    if (ref.exists(tablesListControllerProvider)) {
      ref.read(tablesListControllerProvider.notifier).removed(_id);
    }
  }

  /// Yeni satır (kimliği sunucu üretir) ve kimliği.
  Future<String?> addRow() async => (await _command(const AddRow())).id;

  Future<void> deleteRow(String rowId) async {
    _queue.removeWhere((w) => w.rowId == rowId);
    await _command(DeleteRow(rowId));
  }

  Future<void> moveRow(String rowId, {String? afterId}) =>
      _command(MoveRow(id: rowId, afterId: afterId));

  /// Varsayılan genişlik 200 px (40–1200).
  Future<String?> addColumn(
    String name,
    TableColumnKind kind, {
    int width = 200,
  }) async => (await _command(
    AddColumn(
      name: name.trim(),
      kind: kind,
      width: width,
      expectedSchema: _schema,
    ),
  )).id;

  Future<void> renameColumn(String columnId, String name) async {
    final trimmed = name.trim();
    await _command(
      RenameColumn(id: columnId, name: trimmed, expectedSchema: _schema),
      reload: false,
    );
    final v = _view;
    if (v == null) return;
    _set(
      v.copyWith(
        columns: [
          for (final c in v.columns)
            c.id == columnId ? c.copyWith(name: trimmed) : c,
        ],
      ),
    );
  }

  Future<void> resizeColumn(String columnId, int width) async {
    await _command(
      ResizeColumn(id: columnId, width: width, expectedSchema: _schema),
      reload: false,
    );
    final v = _view;
    if (v == null) return;
    _set(
      v.copyWith(
        columns: [
          for (final c in v.columns)
            c.id == columnId ? c.copyWith(width: width) : c,
        ],
      ),
    );
  }

  Future<void> deleteColumn(String columnId) async {
    _queue.removeWhere((w) => w.columnId == columnId);
    await _command(DeleteColumn(id: columnId, expectedSchema: _schema));
  }

  /// [afterId] null → ilk sıraya.
  Future<void> moveColumn(String columnId, {String? afterId}) => _command(
    MoveColumn(id: columnId, afterId: afterId, expectedSchema: _schema),
  );

  /// Satıra (ya da hücreye) yorum ekler; açık yorum listeleri yenilenir.
  Future<void> addComment(String rowId, String body, {String? columnId}) async {
    await _command(
      AddComment(rowId: rowId, body: body.trim(), columnId: columnId),
      reload: false,
    );
    _bumpComments();
  }

  Future<void> editComment(String commentId, String body) async {
    await _command(
      EditComment(id: commentId, body: body.trim()),
      reload: false,
    );
    _bumpComments();
  }

  Future<void> deleteComment(String commentId) async {
    await _command(DeleteComment(commentId), reload: false);
    _bumpComments();
  }

  /// Son kendi hücre yazımını koşullu geri alır; geri alınamayan hücre sayısını döner.
  Future<int> undoLast() async {
    final seq = _view?.undoSequence;
    if (seq == null) return 0;
    final r = await _command(UndoCells(seq));
    final v = _view;
    if (v != null) _set(v.copyWith(undoSequence: () => null));
    return r.skipped.length;
  }
}
