import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/turkish_collation.dart';

void main() {
  test('Türkçe alfabe sırası; büyük/küçük duyarsız; boşluk önce', () {
    final words = [
      'Ulaşım',
      'İdari',
      'ışık',
      'Çevre',
      'cam',
      'Öykü',
      'ozan',
      'Ada X',
      'Adam',
      'Şube',
      'su',
      'ğ',
      'g',
    ]..sort(compareTurkish);
    expect(words, [
      'Ada X',
      'Adam',
      'cam',
      'Çevre',
      'g',
      'ğ',
      'ışık',
      'İdari',
      'ozan',
      'Öykü',
      'su',
      'Şube',
      'Ulaşım',
    ]);
  });

  test('alfabe dışı karakter harflerden sonra; eşitlikte özgün dize; önek kısa önce', () {
    expect(compareTurkish('a1', 'az'), greaterThan(0));
    expect(compareTurkish('Ab', 'ab'), lessThan(0));
    expect(compareTurkish('ab', 'abc'), lessThan(0));
    expect(compareTurkish('x', 'x'), 0);
  });
}
