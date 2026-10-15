// Gizli değer taşıyan üretilmiş DTO'ların `toString()` çıktısını kapatır (CX-W51-4).
//
// Kural (açık): bir modelin fabrika parametrelerinden `String`/`String?` tipli olan ve adı
// `password`, `token` ya da `secret` içeren (büyük/küçük harf duyarsız) HERHANGİ biri varsa model
// hassastır. `bool` bayraklar (`forcePasswordChange`, `resetPassword`) gizli değer taşımaz.
// Hassas modelde `@Freezed()` → `@Freezed(toStringOverride: false)`: freezed `toString`
// üretmez, çıktı yalnız tür adıdır (alan değeri yok). Giriş/yenileme/parola DTO'ları log'a,
// hata metnine ya da `print`e düşse bile parola/belirteç yazılmaz.
final _secretField = RegExp(
  r'\bString\??\s+(\w*(?:password|token|secret)\w*)\s*[,)}]',
  caseSensitive: false,
);

const _plain = '@Freezed()';
const _masked = '@Freezed(toStringOverride: false)';

/// Model kaynağı hassas alan içeriyor mu?
bool hasSensitiveFields(String source) => _secretField.hasMatch(source);

/// Hassas modellerde `toString` üretimini kapatır; diğerlerini aynen döner. Hassas model
/// beklenen `@Freezed()` biçimini taşımıyorsa düşer (üretici biçimi değişti: fail-closed).
String maskSensitiveModels(String source) {
  if (!hasSensitiveFields(source)) return source;
  if (source.contains(_masked)) return source;
  if (!source.contains(_plain)) {
    throw StateError(
      'hassas model beklenen `@Freezed()` açıklamasını taşımıyor; '
      'tool/gen/sensitive.dart güncellenmeli',
    );
  }
  return source.replaceFirst(_plain, _masked);
}
