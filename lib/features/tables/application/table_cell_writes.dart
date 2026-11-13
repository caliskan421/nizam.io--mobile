part of 'table_controller.dart';

const _setCellsAction = 'set_cells';

/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [TableController.writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek
/// `set_cells` ile gider. Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün
/// batch'i geri aldırır: tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan
/// hücreler (çakışmayı başka hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının
/// değiştirdiği hücreler [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu
/// bilinmeyen hata (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir
/// ([retryWrites]).
extension TableCellWrites on TableController {
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
    _alive ??= _keepAlive();
    if (_queue.length >= TableWriteQueue.maxBatch) {
      unawaited(flush());
    } else {
      _debounce?.cancel();
      _debounce = Timer(
        TableController.writeDebounce,
        () => unawaited(flush()),
      );
    }
  }

  /// Bekleyen hücreleri hemen gönderir (ekrandan çıkarken, komuttan önce). Gönderim
  /// sürüyorsa onun bitişini bekler (komut uçuştaki hücre yazımını geçmez). Hata
  /// fırlatmaz; sonuç [TableView.writeError] ve [TableView.conflicts]'tedir.
  Future<void> flush() {
    _debounce?.cancel();
    return _flushing ??= _drain().whenComplete(() => _flushing = null);
  }

  Future<void> _drain() async {
    if (_hold != null) return;
    while (_queue.isNotEmpty && _mounted && _hold == null) {
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
    if (_mounted && _view != null) _set(_overlay(_view!));
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

  Future<bool> _send(List<TableCellWrite> batch) async {
    final op = SetCells(batch);
    final (keys, key) = _keys.keyFor(_setCellsAction, op.signature);
    _keys = keys;
    final generation = _generation;
    try {
      final r = await _repo.apply(_scope, _id, op, requestKey: key);
      _keys = _keys.clear(_setCellsAction);
      if (generation != _generation || !_mounted) return false;
      _applyReceipt(batch, r);
      return true;
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation != _generation || !_mounted) return false;
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

  bool _sameValue(Object? a, Object? b) {
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
}
