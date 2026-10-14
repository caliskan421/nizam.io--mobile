# UI metin kaynağı

Kullanıcıya görünen arayüz metinleri **yalnız** burada yazılır (ADR-0003 karar 15).

- Grup başına bir dosya: `i18n/ui/<grup>.tr.json` (grup = küçük harf/rakam/`_`).
- Biçim: `{ "texts": { "ui.<grup>.<ad>": "Metin" } }`. Anahtar öneki dosya adıyla aynı olmalıdır.
- `make gen` hepsini `lib/core/i18n/arb/app_tr.arb`'ye birleştirir; ARB elle düzenlenmez.
  Dart anahtarı camelCase'e dönüşür: `ui.common.retry` → `l.uiCommonRetry`.
- `make gen` şu durumlarda hata verir: dosya adı ile önek uyuşmazlığı, yinelenen anahtar,
  boş metin, `{` `}` karakteri, sunucu/istemci hata kodlarıyla (ya da ARB anahtarlarıyla) çakışma.
- Hata metni buraya yazılmaz: hata kodları `errorText` yoluyla gelir (`client.*` için
  `i18n/client_errors.tr.json`).
