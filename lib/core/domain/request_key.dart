import 'dart:convert';
import 'dart:math';

import 'package:meta/meta.dart';

/// Yeni işlem anahtarı (`Idempotency-Key`, ADR-0027): `Random.secure` ile 128 bit, base64url
/// dolgusuz (22 karakter). Yeni bağımlılık yoktur.
String newRequestKey([Random? random]) {
  final r = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

/// Bekleyen işlemlerin anahtar defteri (bellek içi; form ömrü). Anahtar kullanıcı eylemi başına
/// bir kez üretilir: aynı eylem ve aynı gövdeyle yeniden gönderimde ([keyFor]) AYNI anahtar
/// döner (sonucu bilinmeyen isteğin tekrarı); gövde değişirse yeni eylem sayılır, yeni anahtar
/// üretilir. Başarıda ya da "anahtar başka istekle kullanılmış" yanıtında [clear] ile düşer.
@immutable
final class RequestKeys {
  const RequestKeys([this._pending = const {}]);

  final Map<String, ({String body, String key})> _pending;

  /// [action] eyleminin [body] gövdesi için anahtar ve güncel defter.
  (RequestKeys, String) keyFor(String action, String body, [Random? random]) {
    final p = _pending[action];
    if (p != null && p.body == body) return (this, p.key);
    final key = newRequestKey(random);
    return (RequestKeys({..._pending, action: (body: body, key: key)}), key);
  }

  /// [action] için bekleyen anahtar (yoksa null).
  String? pending(String action) => _pending[action]?.key;

  /// [action] için bekleyen gövde imzası (yoksa null).
  String? pendingBody(String action) => _pending[action]?.body;

  RequestKeys clear(String action) => _pending.containsKey(action)
      ? RequestKeys({..._pending}..remove(action))
      : this;
}
