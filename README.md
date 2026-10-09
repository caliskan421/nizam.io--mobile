# NIZAM.IO — Mobil istemci

NIZAM.IO'nun iOS/Android istemcisi. Durum: **MOB-0 altyapı iskeleti** (program F14,
`../program/fazlar/F14-mob-1-kimlik-kabuk-can.md`). Ekran yoktur: ekran tasarımı ve UI
geliştirmesi program sonrası ayrı çalışmadadır (D-0174).

## Yığın

Flutter **3.47.2** stable (Dart 3.13.2; pin `pubspec.yaml` `environment.flutter`, CI aynı
alanı okur) · Riverpod 3 (kod üretimli) · go_router · dio · freezed + json_serializable
(OpenAPI'den üretim) · flutter_secure_storage · intl/ARB. Asgari platform: iOS 16+,
Android 8.0 (API 26)+.

## Komutlar

| Komut | Ne yapar |
|---|---|
| `make deps` | `flutter pub get --enforce-lockfile` |
| `make gen` | bütün üretilmiş kodu pinli kaynaklardan yeniden üretir (aşağıda "Üretim") |
| `make gen-check` | `make gen` + `git diff --exit-code` + porcelain boş (CI kapısı) |
| `make lint` | `dart format` denetimi + `flutter analyze --fatal-infos` + sınır kuralı |
| `make test` | birim testleri (`test/`) |
| `make build-dev-apk` | `flutter build apk --debug --flavor dev -t lib/main_dev.dart` |
| `make build-prod-apk` | `flutter build apk --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols` |

Geliştirme: `flutter run --flavor dev -t lib/main_dev.dart`.

## Flavor'lar

| Flavor | Giriş noktası | Android kimliği | Ağ |
|---|---|---|---|
| `dev` | `lib/main_dev.dart` | `…nizamio.dev` | yalnız `localhost`, `127.0.0.1`, `10.0.2.2` için düz http; diğer her yer https |
| `prod` | `lib/main_prod.dart` | `…nizamio` | yalnız https; sistem CA'ları (pinning v1 dışı) |

Flavor derleme anında giriş noktasıyla seçilir; çalışma anında değişmez. Düz http yasağının
asıl kapısı Dart katmanıdır (`lib/core/server/`); Android ağ güvenlik yapılandırması
(`android/app/src/<flavor>/res/xml/network_security_config.xml`) ikinci savunmadır.
iOS'ta ayrı Xcode şeması yoktur (iOS derlemesi bu fazın CI'ında değildir); flavor yine
giriş noktasıyla seçilir.

## Uygulama kimliği ve imzalama

`io.nizamio.placeholder.nizamio` (Android `applicationId`, iOS bundle id) **yer tutucudur**.
KR-13 varsayılanı "emülatör, imzasız": gerçek kimlik, imzalama ve mağaza yayını program
dışıdır (D-0174). `make build-prod-apk` yalnız `--obfuscate` derlemesini sınamak içindir ve
Flutter şablonunun debug anahtarıyla imzalanır; dağıtılmaz.

## Dizin düzeni ve sınır kuralı

```text
lib/main_dev.dart, main_prod.dart   giriş noktaları
lib/app/                            composition root (bağımlılıkların somut bağı)
lib/core/                           http, güvenli depo, sunucu bağı, oturum, kapsam, hata, i18n, tema
lib/features/<modul>/               presentation, application, domain, data + <modul>.dart açık yüzü
tool/                               üretim ve denetim betikleri
```

`tool/check_boundaries.dart` (AST tabanlı; `make boundaries`, CI) şu kuralları zorlar —
ayrıntı ve kural kimlikleri `tool/boundaries.dart` başlığında, negatif matris
`test/tool/boundaries_test.dart`'ta:

- `core` → `features`/`app` yasak; `features` → `app` yasak.
- Bir feature başka feature'ın iç katmanını import etmez (yalnız `features/<g>/<g>.dart`).
- Feature içi yön: presentation → application, domain · application → domain, data ·
  data → domain · domain → (yok; saf Dart).
- Elle DTO yok: JSON (de)serileştirme yalnız üretilmiş API kodunda; features içinde
  `dart:convert` ve `Map<String, …>` yasak.
- `flutter_secure_storage` yalnız `lib/core/storage/`; `badCertificateCallback` /
  `HttpOverrides` hiçbir yerde; `debugPrint`/`dart:developer` yalnız `lib/core/logging/`.

## Üretim (`make gen`, `tool/gen.dart`)

Kaynaklar yalnız `api-pin.json` pinlerinden okunur; çalışma ağacı okunmaz:

| Kaynak | Pin | Çıktı (commit'lenir) |
|---|---|---|
| backend `docs/api/openapi.yaml` | `backendTag` (`git show refs/tags/<tag>:…`) | `lib/core/api/generated/` — swagger_parser ile freezed modeller + retrofit istemciler; `operations.gen.dart` (operationId → kapsam sınıfı S0–S3, CSRF, kapsam başlıkları, kimlik) |
| backend `docs/api/error-codes.json` | `backendTag` | `lib/core/api/generated/error_catalog.gen.dart`; ARB anahtar kümesi |
| web `src/shared/i18n/tr/errors.ts` | `web.commit` | sunucu hata kodlarının TR metinleri → `lib/core/i18n/arb/app_tr.arb` → gen-l10n (`lib/core/i18n/generated/`) |
| `i18n/client_errors.tr.json` | bu depo | mobilin kendi `client.*` kodları ve metinleri → aynı ARB + `ClientErrorCode` |
| web `tokens/tokens.json` | `web.commit` | `lib/core/theme/generated/tokens.gen.dart` (`NizamioColors` ThemeExtension açık/koyu, palet, boşluk, yarıçap, tipografi — değerler yer tutucu) |
| `pubspec.yaml` `version` | bu depo | `lib/core/config/generated/app_version.gen.dart` |

Sonra `build_runner` (freezed, json_serializable, retrofit, riverpod_generator) ve `dart format`.
Backend/web dizinleri `NIZAMIO_BACKEND_DIR` / `NIZAMIO_FRONTEND_DIR` (varsayılan kardeş
dizinler; CI'da `.backend/` etiket checkout'u ve `.frontend/` commit checkout'u).

Katılık: katalogdaki her zarf ve alan kodunun web'de TR metni yoksa, web dosyasının biçimi
değişmişse (tanınmayan satır), metinde ICU özel karakteri varsa, ARB anahtarı çakışırsa veya
spec'te kapsam sınıfı ↔ kapsam başlığı / yazma ↔ CSRF tutarsızsa üretim düşer
(`test/tool/gen_test.dart`). Metin tamlığı `test/core/generated/generated_test.dart`'ta sınanır.

Üretici seçimi: `swagger_parser` (saf Dart; Java/Docker gerektirmez). Her istekte
`@Extras` ile `operationId` taşınır; ara katman kapsam sınıfını bu kimlikle bulur, haritada
olmayan istek gönderilmez. `X-Requested-With`, `X-Nizamio-Program`, `X-Nizamio-Department`,
`X-Nizamio-Client` parametreleri üretilen imzalardan çıkarılır (ara katman koyar).
OpenAPI 3.0.3 `nullable` alanları freezed'de `?` olur; `include_if_null: false` (build.yaml)
verilmeyen alanı gövdeye yazmaz.

## Backend ile ilişki

- Sözleşme: backend `docs/api/openapi.yaml` + `error-codes.json`, **etiketten**
  (`v0.1.0-api`). Etiketsiz `main`'den üretim yoktur.
- Bağlanma durum makinesi: bağ yok → sunucu doğrulandı → oturum → kapsam.
- Yenileme belirteci ömrü sunucu yapılandırmasındadır
  (`NIZAMIO_SESSION_MOBILE_REFRESH_TTL`, varsayılan 24 saat — KR-03).

## Süreç

Faz sırası ve durum: `../program/DURUM.md`. Her değişiklik PR + CI; faz sonunda
Codex tek koşum. Bu depoda `project-control` kaydı tutulmaz.
