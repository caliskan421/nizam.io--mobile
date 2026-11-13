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

part 'table_controller.g.dart';

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
///
/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
/// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
/// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
/// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
/// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
/// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
///
/// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).
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

  /// Kendi makbuzlarımızın sıraları (yankı ayrımı; canlı senkron kullanır).
  final ownSequences = <int>{};

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

  /// Tabloyu yeniden okur (en az [minRows] satıra kadar sayfa yürür); bekleyen yerel
  /// düzenlemeler sonucun üstüne yeniden uygulanır.
  Future<void> _reload({int? minRows}) async {
    final generation = _generation;
    final want = minRows ?? _view?.rows.length ?? 0;
    var page = await _repo.snapshot(
      _scope,
      _id,
      page: const PageRequest(limit: pageSize),
    );
    final base = _view;
    var next = TableView.fromPage(page, _accountId);
    while (next.rows.length < want && page.nextCursor != null) {
      page = await _repo.snapshot(
        _scope,
        _id,
        page: PageRequest(limit: pageSize, cursor: page.nextCursor),
      );
      next = next.appendPage(page);
    }
    if (generation != _generation || !ref.mounted) return;
    _set(
      _overlay(
        next.copyWith(
          readOnly: base?.readOnly,
          conflicts: base?.conflicts,
          writeError: () => base?.writeError,
          undoSequence: () => base?.undoSequence,
        ),
      ),
    );
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

  // ---------------------------------------------------------------- hücre yazımı

  /// Hücre düzenlemesi. Salt okunur tabloda, düzenlenemeyen tipte ya da gizlenmiş
  /// (redakte) hücrede bir şey yapmaz (redakte değer körlemesine geri yazılamaz, K-14).
  void editCell(String rowId, String columnId, Object? value) {
    final v = _view;
    if (v == null || v.readOnly) return;
    final column = v.column(columnId);
    if (column == null || !editableColumnKinds.contains(column.kind)) return;
    final current = v.cell(rowId, columnId);
    if (current.redacted) return;
    final key = TableCellKey(rowId, columnId);
    final inflight = _inflight?.any((w) => w.key == key) ?? false;
    _queue.put(
      TableCellWrite(
        rowId: rowId,
        columnId: columnId,
        value: value,
        // Uçuştaki aynı hücrenin tabanı makbuzla taşınır (rebase).
        version: inflight ? -1 : current.version,
      ),
    );
    _set(_overlay(v.copyWith(conflicts: {...v.conflicts}..remove(key))));
    _alive ??= ref.keepAlive();
    if (_queue.length >= TableWriteQueue.maxBatch) {
      unawaited(flush());
    } else {
      _debounce?.cancel();
      _debounce = Timer(writeDebounce, () => unawaited(flush()));
    }
  }

  /// Bekleyen hücreleri hemen gönderir (ekrandan çıkarken, komuttan önce). Gönderim
  /// sürüyorsa onun bitişini bekler (komut uçuştaki hücre yazımını geçmez). Hata
  /// fırlatmaz; sonuç [TableView.writeError] ve [TableView.conflicts]'tedir.
  Future<void> flush() {
    _debounce?.cancel();
    return _flushing ??= _drain().whenComplete(() => _flushing = null);
  }

  Future<void>? _flushing;

  Future<void> _drain() async {
    if (_hold != null) return;
    while (_queue.isNotEmpty && ref.mounted && _hold == null) {
      final batch = _queue.take();
      if (batch.any((w) => w.version < 0)) {
        // Tabanı uçuştaki yanıtı bekleyen öğe kalmışsa (olmamalı) güncel sürümle gider.
        final v = _view!;
        for (var i = 0; i < batch.length; i++) {
          final w = batch[i];
          if (w.version >= 0) continue;
          batch[i] = TableCellWrite(
            rowId: w.rowId,
            columnId: w.columnId,
            value: w.value,
            version: v.cells[w.key]?.version ?? 0,
          );
        }
      }
      _inflight = batch;
      final ok = await _send(batch);
      _inflight = null;
      if (!ok) break;
    }
    if (ref.mounted && _view != null) _set(_overlay(_view!));
    if (_queue.isEmpty && _inflight == null) {
      _alive?.close();
      _alive = null;
    }
  }

  /// Sonucu bilinmeyen gönderimi kullanıcı isteğiyle yineler (AYNI işlem anahtarı).
  Future<void> retryWrites() async {
    final v = _view;
    if (v != null) _set(v.copyWith(writeError: () => null));
    await flush();
  }

  static const _setCellsAction = 'set_cells';

  Future<bool> _send(List<TableCellWrite> batch) async {
    final op = SetCells(batch);
    final (keys, key) = _keys.keyFor(_setCellsAction, op.signature);
    _keys = keys;
    final generation = _generation;
    try {
      final r = await _repo.apply(_scope, _id, op, requestKey: key);
      _keys = _keys.clear(_setCellsAction);
      if (generation != _generation || !ref.mounted) return false;
      _applyReceipt(batch, r);
      return true;
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation != _generation || !ref.mounted) return false;
      return _sendFailed(batch, e);
    }
  }

  void _applyReceipt(List<TableCellWrite> batch, TableReceipt r) {
    ownSequences.add(r.sequence);
    final v = _view!;
    final cells = Map.of(v.cells);
    for (final w in batch) {
      final version = r.cellVersions[w.key] ?? w.version + 1;
      cells[w.key] = TableCellData(value: w.value, version: version);
      _queue.rebase(w.key, version);
    }
    _set(
      _overlay(
        v.copyWith(
          cells: cells,
          meta: v.meta.copyWith(
            sequence: r.sequence > v.meta.sequence ? r.sequence : null,
          ),
          writeError: () => null,
          undoSequence: () => r.sequence,
        ),
      ),
    );
  }

  Future<bool> _sendFailed(List<TableCellWrite> batch, ApiError e) async {
    // Batch ya kuyruğa döner ya da düşer; artık uçuşta değildir (görünüm üstüne binmez).
    _inflight = null;
    if (e.code == 'tables.cell_conflict') {
      _keys = _keys.clear(_setCellsAction);
      await _resolveConflict(batch);
      return true;
    }
    if (e.code == 'platform.rate_limited' || e.status == 429) {
      // Sunucu işlemedi: aynı gövde Retry-After sonra kendiliğinden gider.
      _queue.restore(batch);
      _hold = Timer(e.retryAfter ?? const Duration(seconds: 2), () {
        _hold = null;
        unawaited(flush());
      });
      return false;
    }
    if (isOutcomeUnknown(e)) {
      _queue.restore(batch);
      _set(_overlay(_view!.copyWith(writeError: () => e)));
      return false;
    }
    _keys = _keys.clear(_setCellsAction);
    // Kalıcı ret (422/403/404/409 diğer): batch düşer, sunucu değeri geri gelir.
    final forbidden = e.code == 'tables.forbidden';
    if (forbidden) _queue.clear();
    _set(
      _view!.copyWith(readOnly: forbidden ? true : null, writeError: () => e),
    );
    try {
      await _reload();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      // Yeniden okuma da düştüyse görünüm eski kalır; ilk hata zaten gösteriliyor.
    }
    return !forbidden;
  }

  /// Bayat sürüm: tablo yeniden okunur; tabanı değişmeyen hücreler yeniden kuyruğa,
  /// başkasının değiştirdiği hücreler çakışma olarak bildirilir (sunucu değeri kalır).
  Future<void> _resolveConflict(List<TableCellWrite> batch) async {
    await _reload();
    final v = _view;
    if (v == null) return;
    final conflicts = {...v.conflicts};
    final again = <TableCellWrite>[];
    for (final w in batch) {
      if (_queue[w.key] != null) continue; // daha yeni düzenleme zaten bekliyor
      final server = v.cells[w.key] ?? TableCellData.empty;
      if (server.version == w.version) {
        again.add(w);
      } else if (!_sameValue(server.value, w.value)) {
        conflicts.add(w.key);
      }
    }
    _queue.restore(again);
    _set(_overlay(v.copyWith(conflicts: conflicts)));
  }

  static bool _sameValue(Object? a, Object? b) {
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }
      return true;
    }
    if (a is num && b is num) return a == b;
    return a == b;
  }

  /// Çakışma bildirimini kapatır.
  void dismissConflicts() {
    final v = _view;
    if (v != null && v.conflicts.isNotEmpty) _set(v.copyWith(conflicts: {}));
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
