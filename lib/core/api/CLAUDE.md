# CLAUDE.md — nizam.io--mobile/lib/core/api (harita)

Kural burada tekrar edilmez; sözleşmenin yetkili belgesi backend [`docs/api/README.md`](../../../../nizam.io--backend/docs/api/README.md), üretim tablosu `../../../README.md` "Üretim".

**`generated/`:** üretilmiş istemci — **elle düzenlenmez**. `models/` (freezed DTO + enum), `clients/` (retrofit istemcileri), `nizamio_api.dart`, `export.dart`, `operations.gen.dart` (operationId → kapsam sınıfı S0–S3, CSRF, kapsam başlıkları, kimlik; `apiVersion` sabiti), `error_catalog.gen.dart` (hata kataloğu). Features içinde yalnız `data/` ve `<f>_module.dart` içe aktarır (A1).

**`api_meta.dart`:** üretilmiş haritaların tipleri (`ScopeClass`, `ApiOperation`, `ErrorCatalogEntry`); elle yazılır, içerik üretilir. HTTP ara katmanı (`../http/interceptors.dart`) bu tiplerle kapsam/CSRF kararını verir.

**Pin:** [`../../../api-pin.json`](../../../api-pin.json) — `backendTag` (spec + hata kataloğu) ve `web.commit` (TR hata metinleri). Etiketsiz `main`'den üretim yoktur.

**Yeniden üretme:** depo kökünde `make gen` (`../../../tool/gen.dart`); kapı `make gen-check` (diff ve porcelain boş). Pin değişimi = yeni etiket/commit + `make gen` + PR.

**Sürüm/uyum kapısı:** `../server/server_binding.dart` — well-known ve `/v1/instance/profile` `api_version` değeri üretilmiş `apiVersion` ile eşleşmeli, `minimum_mobile_version` ≤ uygulama sürümü (`../config/generated/app_version.gen.dart`); değilse "güncelleme gerekli". Sürüm ilkesi backend `docs/api/README.md` §7–§8.

**Yetkili belge:** backend `docs/api/README.md`; depo kuralları `../../../CLAUDE.md`.
