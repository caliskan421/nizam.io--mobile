# Veri kalıbı — repository → domain eşlemesi (uygulayıcı rehberi)

Kaynak: [yol haritası §4](yol-haritasi-ui-temeli.md). Emsal: `lib/features/identity/data/identity_repository.dart`.
Yeni feature `<f>` için adımlar:

1. **DTO'yu elle yazma.** Backend etiketi pinliyse `make gen` DTO ve `retrofit` istemcisini üretir
   (`lib/core/api/generated/**`, elle düzenlenmez). İstek gövdesi her zaman üretilmiş request DTO'dur (D2).
2. **Domain varlığı:** `lib/features/<f>/domain/<ad>.dart`. Saf Dart (S4: Flutter/dio/DTO import yok),
   değişmez (`final` alanlar, `const` yapıcı; çok alanlıysa `freezed`, json yok). Alanlar UI'ın ihtiyacı kadardır;
   DTO'nun kopyası olmak zorunda değil.
3. **Enum:** domain enum'u + `unknown` üyesi. Çevirme `core/domain/enum_parse.dart` içindeki
   `enumFromWire(Role.values, dto.role, Role.unknown)` ile yapılır (null ve bilinmeyen değer `unknown`).
   Sunucu adı Dart üye adından farklıysa önce çağıran eşler. `unknown`'ı UI'da güvenli varsayılana bağla; asla `throw` etme.
4. **Repository:** `lib/features/<f>/data/<f>_repository.dart`. Yapıcı yalnız `Dio` alır, üretilmiş istemciyi içeride kurar (A2);
   her çağrı `apiCall(...)` ile sarılır (hata -> `ApiError`). DTO yalnız bu katmanda kalır (A1).
5. **Eşleyici:** özel statik `_toX(Dto) -> DomainX` (emsal: `_grant`, `_account`). Kamu API'si yalnız domain tipi döner.
6. **Test:** `test/features/<f>/data/<f>_repository_test.dart` (Q2 zorunlu) — başarılı eşleme, `null`/bilinmeyen değer, hata -> `ApiError`.

## Sayfalama (`core/domain/page_slice.dart`)

Backend biçimi **yalnız imleçtir**: offset yok, **`total` yok** (sözleşmede toplam sayı alanı hiçbir yerde yoktur;
yol haritası §4'teki `total` sözleşmeye göre düşürüldü, ADR'siz sapma değil: sözleşme geçerlidir).

| Sözleşme | `PageSlice` / `PageRequest` |
|---|---|
| Sorgu `limit` (>= 1, isteğe bağlı), `cursor` (opak, isteğe bağlı) | `PageRequest(limit:, cursor:)` |
| Yanıt liste alanı (uca özgü ad, ör. `UserList.users`; `null` olabilir) | `items` — **repository `null`'ı `[]`'e eşler** |
| Yanıt `next_cursor` (yoksa son sayfa) | `nextCursor` (`null` = son sayfa; ayrıştırma, olduğu gibi geri gönder) |
| Başlık `X-Result-Truncated: 'true'` (imleçsiz listeler, en çok 200 satır) | `truncated` (varsayılan `false`) |

Kural: repository DTO satırlarını eşleyip `PageSlice<Domain>` döner; DTO sızmaz. Örnek:

```dart
Future<PageSlice<User>> users(PageRequest page) async {
  final r = await apiCall(() => _client.listUsers(limit: page.limit, cursor: page.cursor));
  return PageSlice(
    items: (r.users ?? const []).map(_user).toList(),
    nextCursor: r.nextCursor,
  );
}
```

Başlıklı (imleçsiz) uçlarda `truncated` değeri yanıt başlığından okunur (`HttpResponse` üzerinden);
başlık yoksa `false`. Sonraki sayfa: `slice.append(await users(PageRequest(cursor: slice.nextCursor)))`;
`hasMore` false olunca dur. Geçersiz imleç sunucuda 422 `identity.invalid_cursor` döner (`ApiError` olarak gelir);
imleci saklayıp eskitme, hata alınca listeyi baştan yükle.
