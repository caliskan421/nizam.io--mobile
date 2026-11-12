# ADR-0002 — Paket seti: tercihler, yazı tipi, boşluk standardı, yerel veri, Firebase, marka

- **Durum:** Kabul edildi (2026-10-09)
- **Karar dayanağı:** ürün sahibi talebi (F14 MOB-0 r3; "şimdiden eklensin")
- **İlgili:** platform.md §6 (yerel DB drift; Firebase SDK; çökme raporu), ADR-0001, sınır
  kuralları S1/S5/S6/U1

## Bağlam

MOB-0 ekransız altyapıdır. Ürün sahibi, ekran çalışmasında kesin kullanılacak paketlerin ve
standartların şimdiden yerleşmesini istedi. Bu ADR hangi paketin hangi kuralla girdiğini ve
önceki bir kararı değiştirdiği yeri kaydeder.

## Karar

| Paket | Kullanım ve kural |
|---|---|
| `shared_preferences` | Gizli OLMAYAN tercihler (tema modu ilk tercih). Yalnız `core/storage/shared_preference_store.dart` (kesin dosya, S5); ham depo yalnız `AppPreferences` ve `app/di`'den (S7), açık API'de taşınamaz (A4) ve bağdaştırıcılar tipi silinmiş değer veremez (A5); erişim tipli `AppPreferences` üzerinden, sabit anahtar kümesi. Belirteç/parola/sunucu bağı/kişisel veri burada tutulmaz (S1: `SecureStore`). Okuma hatası varsayılana düşer. |
| `google_fonts` (8.x) | Token yazı tipleri (2026-10-28'den beri Poppins 600, Inter 400/500/600, Geist Mono 400/500 — ADR-0003 karar 24) **uygulamayla gelir** (`assets/fonts/`, google_fonts adlandırması, OFL lisansları lisans sayfasında); `allowRuntimeFetching = false` — çalışma anında Google'a istek yok, çevrimdışı açılış. 9.x `material_ui` paketine geçtiği için (`flutter/material` ile tip uyumsuzluğu) 8.x pinli. |
| `gap` | **Boşluk standardı.** Çocuksuz `SizedBox(width/height)`, `SizedBox.square`, `SizedBox.fromSize` yasak (U1); `Gap` kullanılır. Çocuklu SizedBox ve `shrink/expand` serbest; `SizedBox.new`, yapıcı tear-off ve `typedef` takma adı da yasak. Kural sözdizimseldir (ad tabanlı): başka bir kütüphanenin aynı adlı sınıfı yanlış pozitif verebilir — projede yerel `SizedBox` tanımlanmaz. |
| `drift` + `drift_flutter` (+ `drift_dev`) | İnternetsiz gösterim için yerel veri (platform.md kararı; sqflite değil). Kurulum (instance) başına ayrı dosya; farklı kuruluma yeniden bağlanmada dosya silinir (doğrulanabilir temizlik). Şema ve önbellek politikası ekran çalışmasıyla gelir; MOB-0'da yalnız paket. |
| `path_provider` | drift dosyası ve indirme biletiyle dosya indirme için. |
| `file_picker` (^13.1.0; kilitte 13.1.0 ve federe alt paketler 2026-10-18 öncesi sürümler) | **2026-11-01 F57, koordinatör kararı — görev kanıt yükleme akışı için.** Yalnız `UploadPicker` portunun gerçekleştirmesinde: `features/tasks/data/file_upload_picker.dart` (kesin dosya, sınır kuralı F1; dışa verilemez). Tek dosya, iki kaynak (`UploadOrigin`; yükleme formunda "Fotoğraflar" / "Dosyalar" seçimi, 2026-11-09 ürün sahibi isteği): **Dosyalar** `FileType.custom` + izinli uzantılar (`uploadExtensions`; iOS Dosyalar, Android SAF); **Fotoğraflar** `FileType.image` — iOS'ta `PHPickerViewController` (süreç dışı seçici, kitaplık izni istemez → `NSPhotoLibraryUsageDescription` eklenmedi), `DarwinOptions(assetRepresentationMode: compatible)` ile HEIC → JPEG; Android'de sistem görsel seçicisi (`GET_CONTENT image/*`, Manifest'e izin eklenmedi, dönüşüm yok). Galeri adı `normalizeUploadName` ile izinli yazıma gelir (`jpeg`/`JPG` → `jpg`, `PNG` → `png`); küme dışı tür (HEIC/WEBP) yerel tür ön denetiminde açık hatayla (`records.content_rejected`) reddedilir. Paket ağa çıkmaz; seçilen dosyanın içeriği yalnız içerik özeti için akışla okunur (`crypto` satırı), adı/yolu günlüğe yazılmaz; tür/boyut yerel ön denetimden geçer, yükleme yalnız mevcut `TaskWriteRepository.attachFile` yolundan. iOS en az 14.0 ister (proje 16.0). |
| `pdfrx` (^2.12.0) | Arşiv PDF önizlemesi: doğrulanmış arşiv indirme akışından en çok 10 MB bellek içi veri; PDFium ile iOS/Android sayfa görüntüleme ve kaydırma. Harici bağlantı açma etkin değildir; yükleme veya çözümleme hatasında indirme kullanılabilir. |
| `crypto` (^3.0.7; kilitte 3.0.7, önceden dolaylı bağımlılıktı — sürüm değişmedi) | **2026-11-09, koordinatör kararı — yükleme niyeti içerik özeti (Codex tur 3 N5).** Yalnız `features/tasks/data/upload_digest.dart` (kesin dosya, sınır kuralı F2; dışa verilemez): seçilen dosyanın SHA-256 özeti akışla (`sha256.startChunkedConversion` + `File.openRead()`, belleğe toplanmaz) **yalnız görev ve arşiv yükleme gönderiminde, tür/boyut ön denetimi geçtikten sonra** hesaplanır (Codex tur 4 N7–N9: sınır dışı dosya okunmaz; seçici içerik okumaz; sohbet eki özet hesaplamaz). Port `UploadDigest` (`uploadDigesterProvider`, `tasks_module.dart`'ta bağlanır); denetleyici kapanınca okuma akışı iptal edilir ve sonuç yok sayılır; okunamayan dosya `client.file_unreadable` olarak kullanıcıya gösterilir. Özet niyetle birlikte saklanır: sonucu bilinmeyen yüklemenin "yeniden dene"si özeti yeniden hesaplamaz. Arşiv ve görev ayrıntısı yüklemesi bu özeti işlem anahtarı imzasına ad/boyutla birlikte koyar: sunucu yükleme tekrarını gövde okumadan metadata'dan tanıdığından (istemci akışları §8) aynı ad/boyutlu farklı içerik eski anahtarla gitse yüklenmeden başarı sayılırdı. Özet ağa gönderilmez, günlüğe yazılmaz. |
| `package_info_plus` (^10.2.2) | **2026-11-12 sürüm yönetimi:** yalnız `app/config/native_release.dart`; kurulu native paketin version/build/package kimliğini okur. Flutter `--build-name`/`--build-number` override'ları hem backend minimum kapısında hem Firebase güncelleme kararında aynı kaynak olur. Native okuma hatası üretilmiş sabite düşerek uyumluluk kapısını gevşetmez. |
| `url_launcher` (^6.3.3; önceden dolaylıydı) | **2026-11-12:** yalnız `app/config/native_update_store.dart`; build-time verilmiş ve allowlist ile doğrulanmış HTTPS mağaza hedefini dış uygulamada açar. Remote Config veya sunucu cevabı hedef belirlemez; mağaza kaydı yokken varsayımsal URL türetilmez. SDK tipi core/feature açık yüzüne taşınmaz. |
| `firebase_core`, `firebase_messaging`, `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` | **Önceki kararı değiştirir:** platform.md'deki "çökme raporu SaaS yok (ADR-0003)" ve "analytics kapalı" mobil için kaldırıldı (ürün sahibi). Kurallar: SDK yalnız `lib/app/**` ve `core/telemetry/telemetry.dart` (kesin dosya, S6; A4/A5); Firebase'e uygulama erişim/yenileme belirteci, parola, sunucu adresi, kişisel veri veya sunucu hata gövdesi gönderilmez (günlük redaksiyonu aynen). Başlangıçta proje/yapılandırma bekleniyordu. **2026-11-11 dev istisnası:** ürün sahibinin sağladığı doğrulanmış dosyalarla yalnız dev Android/iOS'ta Core başlatılır ve Remote Config okunur. Prod kapalı; FCM otomatik kayıt ve Analytics/Crashlytics toplama kapalı kalır. |
| `flutter_native_splash`, `flutter_launcher_icons` | Açılış ekranı ve simge. Simge (`assets/branding/icon*.png`) uygulama içi işaretle (`NzBrandMark`) aynıdır: üstten alta `primaryTop #D8F866 → primary #C8F53C` degrade, "N" Poppins SemiBold `#0B0B0B`, yazı/karo oranı 16/44 (Android uyarlanabilir simgede güvenli alana ölçekli; arka plan `icon_background.png`). Açılış görseli hâlâ **yer tutucu** (primary600 + "N"; KR-13 ile aynı ilke). Görseller değişince `make branding` çalıştırılır. |

## Sonuçlar

2026-11-11 ürün sahibi native push altyapısının hazırlanmasını istedi.
[İlk dilim ve etkinleştirme koşulları](../yurutme/native-push-altyapisi.md): platform
portu, kapalı varsayılan, açık izin akışı ve Firebase Messaging adaptörü hazırlanır;
Native push teslimi backend native sözleşmesi ve sağlayıcı ayarları gelene kadar kapalıdır.
Native push etkinleştirildiğinde FCM cihaz kayıt tokenı yalnız FCM ve doğrulanmış
sunucunun native kayıt mekanizmasında kullanılır; uygulama erişim/yenileme belirteçleri
Firebase'e gönderilmez. Analytics ve diğer Firebase hizmetleri ayrıca açılmaz.

Ürün sahibinin aynı günkü ek isteğiyle Remote Config sürüm/build tabanlı zorunlu ve
isteğe bağlı güncelleme politikası ile push/Crashlytics/Analytics anahtarlarının
[kapalı temeli](../yurutme/firebase-kurulum-ve-kontroller.md) hazırlanır. Backend
asgari sürüm ve API uyum kapısı korunur; uzaktan ayarlar bu kapıyı gevşetemez.
Politika anahtarları SDK toplamayı veya izinleri kendiliğinden açmaz. Doğrulanmış
Firebase yapılandırması gelmeyen ortamlarda başlatmama kararı geçerlidir.

Ürün sahibi daha sonra aynı gün dev JSON/plist dosyalarını sağladı. Proje
`nizamio-mobile`, uygulama kimliği iki platformda `io.nizamio.mobile.dev` olarak
doğrulandı. Yalnız bu flavor'da iki saniye sınırlı Core başlatması yapılır; başarılıysa
ilk kareden sonra Remote Config okunur. Hata/süre aşımı giriş akışını engellemez.
Bu istisna prod'u, push izin/token kaydını veya telemetry toplamayı açmaz. Native
SDK'lar mevcut FlutterFire/SPM bağımlılıklarından gelir; SwiftUI configure veya ikinci
bir native SDK kurulumu yapılmaz.

- Tema modu (sistem/açık/koyu) kalıcıdır: `ThemeModeController` (get_it) +
  `themeModeProvider` (Riverpod); `runApp`'ten önce yüklenir. Güvenlik açılış sırası
  (`startup`) tercihlere bağlı değildir.
- Dev Core/Remote Config bağlantısı `lib/app/config/` üzerinden kuruldu. Prod dosyaları,
  Crashlytics hata kancası, Analytics olay şeması ve kullanıcı tercihleri ayrı işlerdir;
  native push için backend sözleşmesi ve APNs/FCM teslim kanıtı gereklidir.
- Yükseltme notu: `flutter_launcher_icons` iOS projesinde
  `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` değerini bozar; `make branding`
  bunu geri alır.

2026-11-12 sürüm yönetimi dilimi: native sürüm/build okuması, son geçerli politikanın
`AppPreferences` üzerinden kalıcılığı, navigator dışı zorunlu güncelleme kapısı,
ertelebilir öneri ve ön plana dönüşte kontrollü yenileme bağlandı. Minimum çevrimdışı
süreyle gevşemez; kayıt yok ile bozuk/okunamayan kayıt ayrılır. Prod Firebase ve
mağaza kayıtları henüz yoktur. Ayrıntılar ve dış adımlar mevcut
[kurulum ve kontroller](../yurutme/firebase-kurulum-ve-kontroller.md) belgesindedir.
