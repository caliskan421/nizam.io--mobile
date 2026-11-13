import '../domain/table_models.dart';

/// Gönderilmeyi bekleyen hücre yazımları (`set_cells` birleştirme). Yazma kovası hesap
/// başına 60/dk'dır ve presence/akış açılışı/yorum ile paylaşılır: her tuş vuruşu ayrı istek
/// olmaz; aynı hücrenin ardışık düzenlemeleri tek öğede birleşir ve sıra ≤100 hücrelik
/// batch'lerle gönderilir (K-05). Saf Dart, ekransız.
///
/// Sürüm kuralı: öğe hücrenin OKUNAN sürümünü taşır (CAS tabanı). Aynı hücre yeniden
/// düzenlenirse taban korunur, yalnız değer değişir. Uçuştaki batch başarıyla dönünce
/// bekleyen aynı hücrenin tabanı makbuzdaki yeni sürüme taşınır ([rebase]).
class TableWriteQueue {
  /// Tek `set_cells` gövdesinin üst sınırı.
  static const maxBatch = 100;

  final _pending = <TableCellKey, TableCellWrite>{};

  bool get isEmpty => _pending.isEmpty;
  bool get isNotEmpty => _pending.isNotEmpty;
  int get length => _pending.length;

  /// Bekleyen değer (gösterim için); yoksa null.
  TableCellWrite? operator [](TableCellKey key) => _pending[key];

  Iterable<TableCellWrite> get pending => _pending.values;

  /// Düzenlemeyi ekler; hücre zaten bekliyorsa tabanı koruyup değeri değiştirir.
  void put(TableCellWrite write) {
    final existing = _pending[write.key];
    _pending[write.key] = existing == null
        ? write
        : TableCellWrite(
            rowId: write.rowId,
            columnId: write.columnId,
            value: write.value,
            version: existing.version,
          );
  }

  /// Sıranın başından en çok [maxBatch] öğeyi çıkarır (ekleme sırası korunur).
  List<TableCellWrite> take() {
    final batch = _pending.values.take(maxBatch).toList();
    for (final w in batch) {
      _pending.remove(w.key);
    }
    return batch;
  }

  /// Gönderilemeyen batch'i geri koyar. Bu arada aynı hücreye yeni düzenleme geldiyse yeni
  /// değer kalır, taban batch'inkidir (sunucuda hiçbir şey yazılmadı).
  void restore(List<TableCellWrite> batch) {
    final newer = Map.of(_pending);
    _pending
      ..clear()
      ..addEntries([
        for (final w in batch)
          MapEntry(
            w.key,
            newer.containsKey(w.key)
                ? TableCellWrite(
                    rowId: w.rowId,
                    columnId: w.columnId,
                    value: newer[w.key]!.value,
                    version: w.version,
                  )
                : w,
          ),
      ])
      ..addEntries(newer.entries.where((e) => !_pending.containsKey(e.key)));
  }

  /// Uçuştaki batch yazıldı: bekleyen aynı hücrenin CAS tabanı yeni sürüm olur.
  void rebase(TableCellKey key, int version) {
    final w = _pending[key];
    if (w == null) return;
    _pending[key] = TableCellWrite(
      rowId: w.rowId,
      columnId: w.columnId,
      value: w.value,
      version: version,
    );
  }

  /// Satırı/sütunu silinen hücreler düşer.
  void removeWhere(bool Function(TableCellWrite w) test) =>
      _pending.removeWhere((_, w) => test(w));

  void clear() => _pending.clear();
}
