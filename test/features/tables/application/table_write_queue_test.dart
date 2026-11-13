// Hücre yazım kuyruğu: aynı hücre birleşir (CAS tabanı korunur), ≤100'lük batch'ler ekleme
// sırasında, geri koyma daha yeni değeri korur, makbuz sonrası taban taşınır.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/application/table_write_queue.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';

TableCellWrite _w(String row, Object? value, int version) =>
    TableCellWrite(rowId: row, columnId: 'c1', value: value, version: version);

void main() {
  test('aynı hücre birleşir; okunan sürüm korunur', () {
    final q = TableWriteQueue()
      ..put(_w('r1', 'a', 3))
      ..put(_w('r1', 'ab', 9));
    expect(q.length, 1);
    expect(q[TableCellKey('r1', 'c1')]!.value, 'ab');
    expect(q[TableCellKey('r1', 'c1')]!.version, 3);
  });

  test('take en çok 100 öğe, ekleme sırasıyla', () {
    final q = TableWriteQueue();
    for (var i = 0; i < 130; i++) {
      q.put(_w('r$i', i, 0));
    }
    final first = q.take();
    expect(first, hasLength(100));
    expect(first.first.rowId, 'r0');
    expect(q.take().map((w) => w.rowId).first, 'r100');
    expect(q.isEmpty, isTrue);
  });

  test('restore: batch başa döner; arada gelen daha yeni değer kalır, taban batchinki', () {
    final q = TableWriteQueue()
      ..put(_w('r1', 'a', 1))
      ..put(_w('r2', 'b', 1));
    final batch = q.take();
    q
      ..put(_w('r1', 'yeni', 5))
      ..put(_w('r3', 'c', 0))
      ..restore(batch);
    expect(q.pending.map((w) => w.rowId), ['r1', 'r2', 'r3']);
    expect(q[TableCellKey('r1', 'c1')]!.value, 'yeni');
    expect(q[TableCellKey('r1', 'c1')]!.version, 1);
  });

  test('rebase bekleyen hücrenin tabanını taşır; removeWhere düşürür', () {
    final q = TableWriteQueue()
      ..put(_w('r1', 'a', -1))
      ..put(_w('r2', 'b', 0))
      ..rebase(TableCellKey('r1', 'c1'), 4)
      ..rebase(TableCellKey('r9', 'c1'), 7);
    expect(q[TableCellKey('r1', 'c1')]!.version, 4);
    q.removeWhere((w) => w.rowId == 'r2');
    expect(q.length, 1);
  });
}
