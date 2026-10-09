# NIZAM.IO — Mobil istemci

NIZAM.IO'nun iOS/Android istemcisi. Durum: **MOB-0 altyapı iskeleti** (program F14,
`../program/fazlar/F14-mob-1-kimlik-kabuk-can.md`). Ekran yoktur: ekran tasarımı ve UI
geliştirmesi program sonrası ayrı çalışmadadır (D-0174).

## Yığın

Flutter **3.47.2** stable (Dart 3.13.2; pin `pubspec.yaml` `environment.flutter`, CI aynı
alanı okur) · get_it 9 (bileşim kökü) · Riverpod 3 (kod üretimli; reaktif durum) · go_router · dio · freezed + json_serializable
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
| `make integration` | gerçek backend entegrasyonu (aşağıda); yerelde YALNIZ `../program/araclar/verify-sirasi.sh "$PWD" integration` ile |
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
lib/app/                            bootstrap, router, kabuk
lib/app/di/                         bileşim kökü: get_it nesne grafiği + Riverpod portlarının bağlanması
lib/core/                           http, güvenli depo, sunucu bağı, oturum, kapsam, hata, i18n, tema
lib/features/<modul>/               presentation, application, domain, data + <modul>.dart açık yüzü
tool/                               üretim ve denetim betikleri
test/                               birim testleri (sahte bağdaştırıcı, bellek deposu)
test_integration/                   gerçek backend entegrasyonu + backend/ (up.sh, down.sh, …)
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
- `get_it` yalnız `lib/app/**` ve `features/<f>/<f>_module.dart` (G1); modül dosyası yalnız
  `lib/app/di/**` tarafından import edilir (G2).
- Üretilmiş API kodu (`lib/core/api/generated/**`: DTO, enum, istemci) features içinde yalnız
  `data` katmanında ve `<f>_module.dart`'ta import edilir (A1). `data` DTO'yu `domain`
  varlığına eşler; presentation/application/domain ve açık yüz sözleşme tiplerini görmez.
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

## Core katmanı (ekransız)

**Bağımlılıklar (ADR-0001, `docs/architecture/adr-0001-di-get-it.md`; D-0182):** altyapı
tekilleri (güvenli depo, belirteç deposu, kapsam, sunucu bağı, oturum denetleyicisi, HTTP
bağdaştırıcısı, flavor) ve kabloları (yeniden bağlanma → oturum/kapsam temizliği, oturum →
kapsam temizliği, kuruluma bağlı yenileme çağrısı) yalnız `lib/app/di/dependencies.dart`'ta
get_it'e kaydedilir; `Composition.create()` kendi `GetIt.asNewInstance()` örneğini kurar
(global örnek yok). Riverpod reaktif yüzdür: `bindingState`, `sessionState`, `scopeState`,
`appPhase`, `apiDio` türetilir; altyapı sağlayıcıları core'da **port**tur
(`UnimplementedError`) ve bileşim kökünde get_it örnekleriyle geçersiz kılınır. Feature
modülü `features/<f>/<f>_module.dart` yalnız `lib/app/di/`'den çağrılır; katmanlar get_it'i
görmez (sınır kuralı G1/G2).

| Parça | Dosya | Davranış |
|---|---|---|
| Sunucu adresi | `lib/core/server/server_address.dart` | prod: yalnız https (localhost dahil http reddi); dev: http yalnız `localhost`/`127.0.0.1`/`10.0.2.2`/`::1`; kullanıcı bilgisi/sorgu/yol reddi. Reddedilen adrese **hiç istek gitmez**. |
| Sunucu bağı | `lib/core/server/server_binding.dart` | bağ yok → doğrulanıyor → doğrulandı / güncelleme gerekli / başarısız. Sıra: adres → `/.well-known/nizamio-instance` (`product_id == nizamio`, `api_version`) → `/v1/instance/profile` (`api_version`, `minimum_mobile_version` ≤ uygulama → değilse `BindingUpdateRequired`). TLS hatası `client.tls_error` olarak ayrı görünür. Bağ (adres + instance_id) güvenli depoda; farklı kuruluma yeniden bağlanma oturumu temizler. Her açılışta yeniden doğrulanır. |
| HTTP | `lib/core/http/` | dio; yönlendirme izlenmez; zincir: **kapı** (işlem gerçek yöntem + yolun spec yol şablonlarıyla eşleşmesinden bulunur ve taşınan operationId birebir aynı olmalı — başka işlemin `extras`'ı ile kapsam sınıfı düşürülemez; bağ dışı adres / eksik S2–S3 kapsamı → istek gönderilmez; `X-Nizamio-Client: mobile`, yazmalarda `X-Requested-With`, kapsam başlıkları) → **kimlik** (Bearer; 401 → tek uçuş yenileme → bir kez tekrar; giriş/yenileme/çıkış 401'i yenileme tetiklemez) → **hata/günlük** (her hata `ApiError`). |
| Hata | `lib/core/errors/` | `ApiError{code, messageKey, requestId, fields[], status, retryAfter}`; 2xx gövdesi DTO'ya ayrıştırılamazsa `client.invalid_response` (ham ayrıştırma hatası sızmaz); sunucu `message` gösterilmez; metin `errorText()` ile ARB'den; 429 `Retry-After` okunur, otomatik tekrar yok. |
| Oturum | `lib/core/session/` | belirteçler yalnız `SecureStore`'da (`TokenStore`, tek anahtar, üzerine yazma — yeni kaydedilmeden eski silinmez); kayıt kuruluma (`instance_id`) bağlıdır: açılışta doğrulanan bağın kurulumu farklıysa geri yüklenmez, silinir. Yenileme sonuç tablosu `session_controller.dart` başlığında; **K-05:** zaman aşımı/ağ/TLS/5xx/409/geçersiz ya da ayrıştırılamayan yanıt = belirsiz → belirteçler silinir, `SessionReauthRequired(refreshAmbiguous)`, aynı belirteçle tekrar yok. `force_password_change` durumda taşınır. |
| Kapsam | `lib/core/scope/` | örtük varsayılan yok; S2 program, S3 + departman. |
| Log | `lib/core/logging/log.dart` | tek yol; Bearer, JSON/anahtar=değer gizlileri, JWT ve o anki belirteçler (birebir) maskelenir; yayında çıkış yok. |
| Arka plan maskesi | `lib/core/security/privacy_mask.dart` | `AppLifecycleListener`: ön plan dışında opak katman (altyapı; ekran yok). |
| Durum makinesi | `lib/core/app_phase.dart`, `lib/app/router.dart` | bağ → oturum → kapsam fazı; go_router yönlendirmesi fazdan türetilir (rotalar boş yer tutucu). |
| Kimlik servisi | `lib/features/identity/` (`domain`, `data`, `application`) | giriş yalnız `BindingVerified`'da (aksi hâlde istek/parola gitmez); çıkış sunucu hatasında da yereli temizler; `me` 403 zorunlu parola → bayrak. DTO'lar `data`'da `CurrentAccount`/`LoginGrant` domain varlıklarına eşlenir (A1). |

**Yazma-öncesi işaret (yenileme ile depo hatası/çökme):** yenileme isteği ağa çıkmadan önce
depoya `nizamio.session.refresh_inflight` işareti yazılır (yazılamazsa istek gönderilmez);
yeni çift kalıcılaşınca silinir. Yeni çift ağ tekrarı olmadan sınırlı sayıda (3) yazılamazsa
oturum etkin SAYILMAZ (`secureStorageFailure`, `client.secure_storage_error`): eski kayıt
silinir; silme de başarısızsa işaret diskte kalır ve açılışta kayıtlı çiftin geri yüklenmesini
engeller (sunucuda tüketilmiş belirteç bir daha gönderilmez). Süreç içinde gönderilmiş her
yenileme belirteci ayrıca bellekte "yanmış" işaretlenir. Aynı işaret, yanıt beklenirken
çöken sürecin açılışında da çifti düşürür (K-05'in yeniden başlatma hâli).

**Geciken yanıtlar (nesil):** oturumun bir nesli vardır; giriş, çıkış, yeniden bağlanma ve
"yeniden giriş gerekli" geçişleri onu artırır. Bekleyen giriş/yenileme/`me` yanıtı ancak
başladığı nesil (yenilemede aynı kaynak çift; girişte aynı origin + `instance_id` ile hâlâ
doğrulanmış bağ) geçerliyse uygulanır; değilse getirdiği çift depoya yazılmaz, kullanılmaz,
yalnız atılır — sunucudaki o oturum kendi ömrüyle ölür. Bearer yalnız dio'nun bağlı olduğu
kuruluma ait çiftten alınır; çıkış kapsamı da temizler. Eşzamanlı bağ doğrulamalarında yalnız
en son başlatılanın sonucu uygulanır. 401 sonrası tekrar edilen istek DAİMA başladığı oturum neslinde ve başladığı
kapsamla gider; nesil değiştiyse (çıkış, başka hesapla giriş) yenileme ve tekrar yapılmaz
(`client.session_ended`).

Güvenli depo: `FlutterSecureStore` (iOS Keychain `first_unlock_this_device`; Android Keystore,
`allowBackup=false`). Testlerde ve cihazsız entegrasyonda `MemorySecureStore`.

## Gerçek backend entegrasyonu (`make integration`)

`test_integration/backend/` F06 web `e2e/backend` deseninin mobil uyarlamasıdır:

1. `up.sh`: `api-pin.json` etiketinden `git archive` → geçici kopyada `FROM` satırları digest'li →
   `nizamio-f14/backend:<etiket>` imajı → `migrations/roles.sql` → `migrate up` → ilk yönetici
   (`nizamio-f14/bootstrap`, geçici araç; backend çalışma imajına girmez — `check-isolation.sh image`,
   APK'lara girmez — `check-isolation.sh apk`; kapının körleşmediği `check-isolation-selftest.sh`
   ile CI'da sınanır) → iki server: `127.0.0.1:18140` ve asgari mobil
   sürümü `99.0.0` olan `127.0.0.1:18141`. Yerel Postgres: Compose projesi `nizamio_f14_mobile`,
   DB `nizamio_f14_test`, `127.0.0.1:15440`.
2. `flutter test test_integration/ --concurrency=1`: fixture yalnız API ile (yönetici girişi, web girişi).
3. `down.sh`: yalnız adıyla (`nizamio-f14-server`, `nizamio-f14-server-minver`, Compose projesi).
   İmajlar önbellek için kalır; silmek gerekirse yalnız `nizamio-f14/*` adıyla.

Yerel inşacı: buildx varsa BuildKit (CI ile aynı, günlükte pinli FROM denetimi); yoksa klasik
inşacı (Dockerfile'lar BuildKit'e özgü özellik kullanmaz; FROM digest'li ve çalışma imajı katman
denetimi yine koşar).

**Neden cihazsız, host VM'de (`flutter test test_integration/`)?** `integration_test/` dizini
`flutter test`'te cihaz ister (Ubuntu CI'da emülatör hem yavaş hem kırılgan). Bu fazın sınadığı
şey UI değil core katmanıdır: sunucu bağı, dio zinciri, oturum/K-05, kimlik servisi. Bunlar host
Dart VM'de gerçek `dart:io` HTTP/TLS ile birebir koşar; platform kanalı isteyen tek parça olan
güvenli depo `MemorySecureStore` ile değiştirilir (aynı `SecureStore` arayüzü; `FlutterSecureStore`
yalnız flutter_secure_storage'ı sarar). Cihaz üstü (platform kanalı, Keychain/Keystore) doğrulama
ekran çalışmasıyla gelir.

Senaryolar (`test_integration/backend_test.dart`):

| Test | Kanıtladığı |
|---|---|
| sunucu doğrulama | well-known + profile + sürüm uyumu → `BindingVerified` |
| prod flavor: http adres | gerçek backend önündeki sayan vekile **hiç istek yok**; giriş başlamaz |
| NIZAM.IO olmayan sunucu | yalnız keşif isteği; giriş isteği oluşmaz |
| güvenilmeyen sertifikalı https | `client.tls_error`; istek ulaşmaz |
| sürüm uyumsuzluğu (99.0.0) | `BindingUpdateRequired`; yalnız keşif + profil, parola gövdede yok |
| giriş → me → yenileme → me → çıkış | rotasyon, çıkıştan sonra eski erişim belirteci 401, log'da belirteç yok |
| K-05 | vekil yenileme yanıtını kaybeder (backend döndürür): yeniden giriş gerekli, ikinci yenileme isteği yok, **aynı hesabın web oturumu `/v1/me` 200** |
| kontrol | kaybolan belirteci tekrar kullanmak (istemcinin YAPMADIĞI şey) hesabın bütün oturumlarını düşürür — kuralın gerekçesi |

## Backend ile ilişki

- Sözleşme: backend `docs/api/openapi.yaml` + `error-codes.json`, **etiketten**
  (`v0.1.0-api`). Etiketsiz `main`'den üretim yoktur.
- Bağlanma durum makinesi: bağ yok → sunucu doğrulandı → oturum → kapsam.
- Yenileme belirteci ömrü sunucu yapılandırmasındadır
  (`NIZAMIO_SESSION_MOBILE_REFRESH_TTL`, varsayılan 24 saat — KR-03).

## Süreç

Faz sırası ve durum: `../program/DURUM.md`. Her değişiklik PR + CI; faz sonunda
Codex tek koşum. Bu depoda `project-control` kaydı tutulmaz.
