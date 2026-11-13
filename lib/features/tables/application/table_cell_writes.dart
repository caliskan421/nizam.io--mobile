part of 'table_controller.dart';

/// Gönderilen (uçuştaki ya da bekletilen) `set_cells` batch'i: gövdesi ve işlem anahtarı
/// DEĞİŞMEZ. Sonucu bilinmeyen gönderim aynı gövde+anahtarla yinelenir (sunucu yazdıysa
/// `replayed` makbuz döner); yeni düzenlemeler kuyrukta bunun arkasında bekler.
final class _Batch {
  _Batch(List<TableCellWrite> cells, this.key)
    : cells = List.unmodifiable(cells);
  final List<TableCellWrite> cells;
  final String key;
  bool has(TableCellKey k) => cells.any((w) => w.key == k);
  TableCellWrite? of(TableCellKey k) =>
      cells.where((w) => w.key == k).firstOrNull;
}

/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [TableController.writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek
/// `set_cells` ile gider. Aynı anda tek batch vardır ([_Batch]).
///
/// CAS tabanı: kuyruğa giren düzenleme hücrenin OKUNAN sürümünü taşır; hücre batch'teyse
/// batch öğesinin tabanını. Taban yalnız KENDİ başarılı makbuzumuzla taşınır; çakışma
/// sonrası yabancı sürüme asla taşınmaz (başkasının değeri sessizce ezilmez).
///
/// 409 `tables.cell_conflict` → tablo yeniden okunur; sunucu sürümü tabanla aynı kalan
/// hücreler yeni anahtarla yeniden gider, başkasının değiştirdiği hücreler (batch'teki ve
/// kuyruktaki) [TableView.conflicts]'e girer, sunucu değeri görünür. Çözümleme okuması düşerse
/// batch korunur ve [retryWrites] beklenir. Sonucu bilinmeyen hata ve 429 batch'i aynı
/// gövde+anahtarla tutar. Gönderim hiçbir zaman fırlatmaz; sonuç görünümdedir.
extension TableCellWrites on TableController {
  /// Hücre düzenlemesi. Salt okunur tabloda, düzenlenemeyen tipte ya da gizlenmiş
  /// (redakte) hücrede bir şey yapmaz (redakte değer körlemesine geri yazılamaz, K-14).
  void editCell(String rowId, String columnId, Object? value) {
    final v = _base;
    if (v == null || !v.editable) return;
    final column = v.column(columnId);
    if (column == null || !editableColumnKinds.contains(column.kind)) return;
    final current = v.cell(rowId, columnId);
    if (current.redacted) return;
    final key = TableCellKey(rowId, columnId);
    _queue.put(
      TableCellWrite(
        rowId: rowId,
        columnId: columnId,
        value: value,
        version: _batch?.of(key)?.version ?? current.version,
      ),
    );
    _update((b) => b.copyWith(conflicts: {...b.conflicts}..remove(key)));
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

  /// Bekleyen hücreleri gönderir. Gönderim sürüyorsa onun bitişini bekler (komut uçuştaki
  /// hücre yazımını geçmez). Hiç fırlatmaz.
  Future<void> flush() {
    _debounce?.cancel();
    return _flushing ??= _drain().whenComplete(() => _flushing = null);
  }

  Future<void> _drain() async {
    try {
      while (_mounted) {
        if (_batch == null) {
          if (_queue.isEmpty) break;
          _batch = _Batch(_queue.take(), newRequestKey());
        } else if (_batchHeld) {
          break;
        }
        if (!await _send(_batch!)) break;
      }
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      _update((b) => b.copyWith(writeError: () => toApiError(e)));
    }
    _publish();
    if (_queue.isEmpty && _batch == null) {
      _alive?.close();
      _alive = null;
    }
  }

  /// Bekletilen (sonucu bilinmeyen ya da çözümü yarım kalan) gönderimi kullanıcı isteğiyle
  /// yineler.
  Future<void> retryWrites() async {
    _batchHeld = false;
    _update((b) => b.copyWith(writeError: () => null));
    await flush();
  }

  Future<bool> _send(_Batch batch) async {
    final generation = _generation;
    try {
      final r = await _repo.apply(
        _scope,
        _id,
        SetCells(batch.cells),
        requestKey: batch.key,
      );
      if (generation != _generation || !_mounted) return false;
      _batch = null;
      _applyReceipt(batch, r);
      return true;
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation != _generation || !_mounted) return false;
      return _sendFailed(batch, e);
    }
  }

  /// Makbuz: yazılan hücrelerin YENİ sürümü. Görünümdeki sürüm zaten daha büyükse (araya
  /// yabancı değişikliği taşıyan snapshot girdi) eski makbuz uygulanmaz.
  void _applyReceipt(_Batch batch, TableReceipt r) {
    ownSequences.add(r.sequence);
    _update((b) {
      final cells = Map.of(b.cells);
      for (final w in batch.cells) {
        final version = r.cellVersions[w.key] ?? w.version + 1;
        final current = cells[w.key]?.version ?? 0;
        if (version > current) {
          cells[w.key] = TableCellData(value: w.value, version: version);
          _queue.rebase(w.key, version);
        }
      }
      return b.copyWith(
        cells: cells,
        meta: b.meta.copyWith(
          sequence: r.sequence > b.meta.sequence ? r.sequence : null,
        ),
        writeError: () => null,
        undoSequence: () => r.sequence,
      );
    });
  }

  Future<bool> _sendFailed(_Batch batch, ApiError e) async {
    if (e.code == 'tables.cell_conflict') return _resolveConflict(batch);
    if (e.code == 'platform.rate_limited' || e.status == 429) {
      // Sunucu işlemedi: aynı gövde+anahtar Retry-After sonra kendiliğinden gider.
      _batchHeld = true;
      _hold?.cancel();
      _hold = Timer(e.retryAfter ?? const Duration(seconds: 2), () {
        _hold = null;
        _batchHeld = false;
        unawaited(flush());
      });
      return false;
    }
    if (isOutcomeUnknown(e)) {
      _batchHeld = true;
      _update((b) => b.copyWith(writeError: () => e));
      return false;
    }
    // Kalıcı ret (422/403/404/409 diğer): batch düşer, sunucu değeri geri gelir.
    _batch = null;
    final forbidden = e.code == 'tables.forbidden';
    if (forbidden) _queue.clear();
    _update(
      (b) => b.copyWith(readOnly: forbidden ? true : null, writeError: () => e),
    );
    try {
      await _reload();
    } on ApiError catch (re, st) {
      reportUnexpected(re, st, source: ReportSource.tables);
      _needsReload = true;
    }
    return !forbidden;
  }

  /// Bayat sürüm: tablo yeniden okunur; tabanı değişmeyen hücreler yeniden gönderilir (yeni
  /// anahtar: önceki istek reddedildi), başkasının değiştirdiği hücreler — kuyruktaki daha
  /// yeni düzenlemeler dahil — çakışma olarak bildirilir. Okuma düşerse batch yeni anahtarla
  /// bekletilir, kuyruk dokunulmaz, hata görünür.
  Future<bool> _resolveConflict(_Batch batch) async {
    try {
      await _reload();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      _batch = _Batch(batch.cells, newRequestKey());
      _batchHeld = true;
      _update((b) => b.copyWith(writeError: () => e));
      return false;
    }
    final v = _base!;
    final conflicts = {...v.conflicts};
    final again = <TableCellWrite>[];
    for (final w in batch.cells) {
      final server = v.cells[w.key] ?? TableCellData.empty;
      final newer = _queue[w.key];
      if (server.version == w.version) {
        if (newer == null) again.add(w);
      } else {
        if (newer != null) _queue.removeWhere((q) => q.key == w.key);
        if (!_sameValue(server.value, newer?.value ?? w.value)) {
          conflicts.add(w.key);
        }
      }
    }
    _batch = null;
    _queue.restore(again);
    _update((b) => b.copyWith(conflicts: conflicts));
    return true;
  }

  bool _sameValue(Object? a, Object? b) {
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }
      return true;
    }
    return a == b;
  }

  /// Çakışma bildirimini kapatır.
  void dismissConflicts() => _update((b) => b.copyWith(conflicts: {}));
}
