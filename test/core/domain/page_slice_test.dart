import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';

void main() {
  test('varsayılanlar: son sayfa, kesilmemiş', () {
    final s = PageSlice<int>(items: [1, 2]);
    expect(s.nextCursor, isNull);
    expect(s.truncated, isFalse);
    expect(s.hasMore, isFalse);
  });

  test('items değişmez ve girdi listesinden bağımsız', () {
    final src = [1];
    final s = PageSlice<int>(items: src);
    src.add(2);
    expect(s.items, [1]);
    expect(() => s.items.add(3), throwsUnsupportedError);
  });

  test('empty', () {
    final s = PageSlice<int>.empty();
    expect(s.items, isEmpty);
    expect(s.hasMore, isFalse);
  });

  test('map imleç ve kesilmeyi korur', () {
    final s = PageSlice<int>(items: [1, 2], nextCursor: 'c', truncated: true);
    final m = s.map((i) => 'x$i');
    expect(m.items, ['x1', 'x2']);
    expect(m.nextCursor, 'c');
    expect(m.truncated, isTrue);
    expect(m.hasMore, isTrue);
  });

  test('append satırları birleştirir, imleç sonrakinden gelir', () {
    final a = PageSlice<int>(items: [1], nextCursor: 'a');
    final b = PageSlice<int>(items: [2, 3]);
    final r = a.append(b);
    expect(r.items, [1, 2, 3]);
    expect(r.nextCursor, isNull);
    expect(r.hasMore, isFalse);
  });

  test('PageRequest alanları ve limit alt sınırı', () {
    const r = PageRequest(limit: 1, cursor: 'c');
    expect(r.limit, 1);
    expect(r.cursor, 'c');
    expect(const PageRequest().limit, isNull);
    expect(() => PageRequest(limit: 0), throwsA(isA<AssertionError>()));
  });
}
