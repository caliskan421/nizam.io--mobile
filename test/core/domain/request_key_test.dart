// İşlem anahtarı (ADR-0027): 128 bit base64url (22 karakter, sunucu sınırı 22–200); aynı eylem +
// aynı gövde → aynı anahtar (sonucu bilinmeyen isteğin tekrarı), gövde değişince yeni anahtar,
// temizlenince yeni eylem yeni anahtar.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/request_key.dart';

void main() {
  test('anahtar 22 karakter base64url, dolgusuz; her çağrıda farklı', () {
    final keys = {for (var i = 0; i < 200; i++) newRequestKey()};
    expect(keys, hasLength(200));
    for (final k in keys) {
      expect(k, matches(RegExp(r'^[A-Za-z0-9_-]{22}$')));
    }
  });

  test('aynı eylem + aynı gövde → aynı anahtar; gövde değişince yeni', () {
    var ledger = const RequestKeys();
    final (l1, k1) = ledger.keyFor('note', 'Merhaba');
    ledger = l1;
    final (l2, k2) = ledger.keyFor('note', 'Merhaba');
    expect(k2, k1, reason: 'tekrar aynı anahtarla');
    expect(identical(l2, ledger), isTrue);
    final (l3, k3) = ledger.keyFor('note', 'Merhaba!');
    expect(k3, isNot(k1), reason: 'yeni gövde = yeni eylem');
    expect(l3.pending('note'), k3);
    // Eylemler birbirinden bağımsızdır.
    final (l4, k4) = l3.keyFor('subtask', 'Merhaba!');
    expect(k4, isNot(k3));
    expect(l4.pending('note'), k3);
  });

  test('temizlenen eylem sonraki gönderimde yeni anahtar alır', () {
    final (l1, k1) = const RequestKeys().keyFor('create', 'g');
    final cleared = l1.clear('create');
    expect(cleared.pending('create'), isNull);
    final (_, k2) = cleared.keyFor('create', 'g');
    expect(k2, isNot(k1));
    expect(identical(cleared.clear('yok'), cleared), isTrue);
  });
}
