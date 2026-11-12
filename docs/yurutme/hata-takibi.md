# Hata takibi (Crashlytics) — uygulama ve kabul

Durum (2026-11-12): Sonnet uygulaması Codex denetiminden geçti; bağımsız hedefli koşumda
532 test ve değişen 48 Dart dosyasının analizi yeşil. Android dev/prod debug APK ve iOS dev
simülatör debug derlemeleri geçti. **Gerçek crash, konsol/metadata ve dağıtım sembol yükleme
provası yapılmadı** (en sonda "Yapılmayanlar"). Prod Firebase kapalıdır; bu iş yalnız dev Firebase'e bağlıdır. Analytics
açılmadı. Yeni paket/kilit değişikliği yok (`firebase_crashlytics` zaten bağımlılıktı).

## SDK anlamı ve tasarım kararı (resmî belge: "Enable opt-in reporting")

- `setCrashlyticsCollectionEnabled(...)` çağrısı **çalışmalar arasında kalıcıdır** ve manifest/plist
  değerini ezer; `false` yazmak bir SONRAKİ başlatmada etkindir. Bu yüzden `true` YAZMAK, kullanıcı
  sonra geri alsa ya da tercih kaydı bozulsa bile, sonraki süreçte yerel çökmenin onaysız
  gönderilmesine yol açabilir (Dart henüz başlamadan, `Firebase.initializeApp` öncesinde).
- **Karar:** otomatik toplama KALICI olarak kapalıdır (manifest `false`, Info.plist `false`, ve her
  başlatmada `setCrashlyticsCollectionEnabled(false)`). Kod tabanında `...Enabled(true)` çağrısı YOKTUR
  (`crashlytics_channel_test` bunu yük düzeyinde doğrular). Raporlar cihazda saklanır; gönderim yalnız
  açık çağrıyla olur:
  - kayıtlı onay VARSA açılışta `sendUnsentReports()` (ÖNCEKİ oturumların raporları);
  - onay YOKSA açılışta `deleteUnsentReports()` (onaysız oturumun yerel çökmesi, sonradan onay
    verilse bile gönderilmez);
  - geri alınınca `deleteUnsentReports()`.
- **Gönderim gecikmesi:** nonfatal ve yerel çökme raporları, raporun oluştuğu oturumdan SONRAKİ açılışta
  (Firebase başlatıldıktan sonra, onay okunup `sendUnsentReports` çağrıldığında) gider; aynı oturumda
  anında gönderim GARANTİ DEĞİLDİR. Bu, tasarım gereği ödünleşimdir.
- **Mevcut kod `true` yazmaz.** Ancak bu kodun dışında, daha eski bir derlemenin ya da harici bir
  aracın bıraktığı kalıcı `true` bayrağı olan bir cihazda, o bayrak temizlenene kadar (her başlatma
  `false` yazar; etkisi sonraki başlatmada başlar) ilk başlatmada native SDK yerel çökmeyi Dart
  kodundan bağımsız olarak onaysız gönderebilir. Bu kabul EDİLMİŞ bir sınır değildir: **üretim
  geçişinin koşulu**, bu tür eski/harici override'ın bulunmadığının (temiz kurulum ya da en az bir
  başlatma + `false` yazımı sonrası kontrol) doğrulanmasıdır.

## Mimari

| Parça | Yer | Görev |
|---|---|---|
| `ErrorReporter` portu, `NoopErrorReporter` | `lib/core/telemetry/error_reporting.dart` | Firebase'siz port: `record`, `sendPending`, `discardPending` |
| `ErrorReporting` cephesi | aynı dosya | onay kapısı, çift rapor engeli, hız sınırı, "raporlayıcı hatası taşmaz"; `attach` ayırıcı döner (bileşim ömrü) |
| `ErrorReport` (`create` tek yol), enum'lar, `ReportContext` | `error_report.dart` | izinli alanların TAMAMI; işlem bağlamı Zone değeri |
| `sanitizeStack` → `SanitizedStackTrace` | `stack_sanitizer.dart` | yalnız TANINAN çerçeve/başlık satırları yeniden kurulur (beyaz liste) |
| `reportUnexpected`, `reportApiFailure`, `invalidResponseError` | `unexpected_error.dart`, `api_error.dart` | işlem sınırı sınıflandırması; aynı kök hata tek rapor |
| `ErrorReportingController` | `error_reporting_controller.dart` | tercih + kapı + bekleyen rapor yaşam döngüsü; get_it'te, Riverpod portu `errorReportingControllerProvider` |
| `CrashlyticsErrorReporter` | `lib/app/telemetry/` | Crashlytics adaptörü (firebase_* yalnız `app/**`, S6) |
| `installErrorHooks` | `lib/app/telemetry/error_hooks.dart` | `FlutterError.onError`, `PlatformDispatcher.onError`; yığılmaz, ayırıcı döner |
| `CrashReportsCard` | `features/identity/presentation/` | Profil sekmesinde tercih anahtarı + sonuç bildirimi (ayrı ayarlar ekranı yok) |

Küresel `ErrorReporting` yalnız `apiCall` gibi serbest işlevlerin erişebilmesi içindir; raporlayıcı
bağı bileşimin (`ErrorReportingController.load/dispose`) ömrüne bağlıdır ve başka bileşimin bağını
ezmez/sökmez. Ayrı isolate/`compute` kullanılmıyor. `runZonedGuarded` yok; `runApp` aynı bölgede,
kancalar `bootstrap` başında kurulur ve önceki kancaları çağırır.

## Politika

- **Fatal/nonfatal:** çerçeve hatası ve yakalanmamış eşzamansız hata nonfatal; tek fatal kategori:
  açılış başarısızlığı. Yerel (native) çökme SDK'nın kendi fatal raporudur.
- **Raporlanır:** geçersiz başarılı yanıt/ayrıştırma hatası (elle kurulanlar dahil:
  `decodeJsonObject`, tokensız giriş yanıtı, boş gövde, SSE yükü), 5xx (zarfsız 502 HTML dahil),
  yerel depolama/dosya sistemi, işlem sınırında beklenmeyen istisna (giriş, görev yazma/hızlı
  form, yükleme/indirme, sohbet gönderimi, sohbet akışı).
- **Raporlanmaz:** doğrulama (422), yanlış parola, 401/403, 409, iptal, zaman aşımı, ağ/IO kopması,
  TLS.
- **Tek rapor:** kök hata nesnesi `Expando` ile işaretlenir; `apiCall` dönüştürdüğü `ApiError`'u da
  işaretler; küresel kancalar ve `reportUnexpected` aynı kökü tekrarlamaz. Hız sınırı: aynı
  etiket+ilk üç kare 5 dk'da bir; oturumda en çok 25 (fatal hariç).
- **İşlem bağlamı:** `ReportContext.run(op, …)` (Zone; eşzamanlı işlemler karışmaz). Native tarafa
  özel anahtar/kullanıcı kimliği GÖNDERİLMEZ (süreç geneli oldukları için işlemleri karıştırırdı);
  işlem sabiti `exception` etiketindedir (`kind=… op=… type=…`). Kapalı küme: `login, session_refresh,
  task_write, file_upload, file_download, chat_send, chat_stream, local_storage, startup, none`. İç içe
  bağlamda dıştaki korunur (`runIfNone`; yükleme görev yazmasının içinde `file_upload` kalır).

## Yük sınırı (gönderilen alanlar)

`ErrorReport.create` tek kurma yoludur: `kind/op/type` (kapalı enum), `code` yalnız sunucu hata
kataloğu veya istemci kodu listesinde varsa, `status` yalnız `2xx…5xx` sınıfı, `fatal`, ve
`SanitizedStackTrace`. Yığın beyaz listeyle yeniden kurulur: tanınan `#N sembol (package:|dart:…:satır:sütun)`,
AOT `#NN abs … [virt …] sembol+0x…` (Android `virt` var, iOS yok; SDK test örnekleriyle sınanır), `build_id`, `isolate_*_base/instructions`, `os:` ve `loading_unit`
başlıkları, `<asynchronous suspension>`. `file:`/mutlak yol/Windows yolu çerçeveleri yalnız sembolle
kalır, konum `<local>`'dir (dosya adı dahil EDİLMEZ). Tanınmayan her satır (URL, sorgu, yüzde-kodlu
yol, serbest metin, pid/thread adı, sürüm satırı) atılır. Gönderilmez: ham hata iletisi,
`FlutterErrorDetails` ayrıntısı, sunucu gövdesi/başlığı/adresi, belirteç/parola/FCM belirteci,
kimlikler, kullanıcı içeriği, dosya adı/yolu, `reason`/`information`/özel anahtar/kullanıcı kimliği.
Genel `Log` çıkışı Crashlytics'e bağlı değildir.

## Onay (kullanıcı tercihi)

- `AppPreferences.errorReportingKey`: yalnız `'true'` onaydır; yok/bozuk/okunamaz = kapalı. Remote
  Config `crash_reporting_enabled` izin yerine geçmez ve okunmaz.
- Gönderim (`sendUnsentReports`) yalnız tercih okunduktan SONRA ve istek hâlâ geçerliyse yapılır;
  okuma sürerken geri alma gelirse gönderilmez.
- Açma: önce onaydan ÖNCEKİ cihaz raporlarının silindiği ONAYLANIR (`deleteUnsentReports` süresi içinde
  başarıyla bitmiş olmalı). Açılıştaki silme hata/zaman aşımı verdiyse "açıkça yeniden deneme"
  yalnız kullanıcı açma eylemiyle olur; yine belirsizse tercih YAZILMAZ, kapı AÇILMAZ ve kullanıcıya
  bildirilir (aksi halde sonraki açılış onaydan önceki raporu gönderirdi). Sonra tercih yazılır
  (yazılamazsa açılmaz; kapalı yazılmaya çalışılır) → Dart kapısı açılır. Yazma gecikmeli bitip arada
  geri alınırsa eski istek kapıyı açamaz (nesil sayacı); kapı geri almada eşzamanlı kapanır.
- Kapıyı yalnız geçerli bağ ([`ErrorReportingBinding`]) değiştirir: yerine başka bileşim
  bağlandıysa eski denetleyicinin geç `load`/`set` sonuçları yeni kapıyı açıp kapatamaz.
- Geri alma: kapı hemen kapanır → `false` yazılır → olmazsa kayıt SİLİNİR → ikisi de olmazsa
  `revokeNotPersisted`: oturumda kapalı, ama **kalıcılık sağlanamadı** ve sonraki açılışta eski `true`
  geri gelebilir; arayüz bunu açıkça yazar ("başarıyla kapatıldı" denmez). Sonsuz yeniden deneme yok.
  Bekleyen raporlar silinir.
- Firebase zamanında açılamadıysa (2 sn sınırı, prod, web/masaüstü) raporlayıcı yoktur: denetim
  görünmez, hiçbir şey gönderilmez; geç biten başlatmanın sonucu atılır.
- Onay okunmadan önceki açılış hataları raporlanmaz (kapı kapalı).

## Yerel (native) çökme verisi

Native otomatik çökme verisi **Dart redaksiyonundan geçmez**; SDK kendisi toplar ve yukarıdaki
`sendUnsentReports` yoluyla (onay varken) gider. Beklenen alanlar: çökme izi/semboller, cihaz modeli,
OS sürümü, uygulama sürümü/build, bellek/disk durumu, Firebase kurulum kimliği. "Sıfır kişisel veri"
iddiası kurulmaz. Ek kimlik üretilmez, `setUserIdentifier` çağrılmaz.

## Native yapı ve sembol yükleme

- **Android:** `com.google.firebase.crashlytics` Gradle eklentisi (`settings.gradle.kts` **3.0.8**; Google Maven
  `firebase-crashlytics-gradle` `maven-metadata.xml`inde latest/release, 2026-11-12; uygulama
  modülünde uygulanır). Prod flavor'da mapping/yerel sembol yükleme KAPALI (prod `google-services.json`
  yok; yükleme görevleri `google_app_id` bulamayıp derlemeyi bozmasın). Prod etkinleşince o blok kalkar.
  Codex doğrulaması: Gradle 9.3.1 / AGP 9.1.0 ile `./gradlew help --no-daemon --console=plain`,
  `flutter build apk --debug --flavor dev -t lib/main_dev.dart --no-pub` ve
  `flutter build apk --debug --flavor prod -t lib/main_prod.dart --no-pub` geçti.
- **iOS:** `Upload Crashlytics Symbols` build phase'i (`ios/scripts/upload_crashlytics_symbols.sh`):
  yalnız gerçek cihaz (simülatör AÇIKÇA atlanır) + Release/Profile + kopyalanmış
  `GoogleService-Info.plist` + dSYM varken Crashlytics `run` betiğini (SPM `SourcePackages` ya da
  Pods) çağırır; aksi halde sessizce atlar, başarısızlıkta derlemeyi durdurmaz. Betik, sahte ortamla
  `test/tool/crashlytics_symbols_script_test.dart`te sınanır. Codex doğrulaması: `sh -n`,
  `plutil -lint` ve `flutter build ios --simulator --debug --flavor dev -t lib/main_dev.dart --no-pub`
  geçti. Gerçek cihaz arşivi ve dSYM yüklemesi ayrıca doğrulanmalıdır.
- **Dart sembolleri / obfuscation:** dağıtım derlemesi `--obfuscate --split-debug-info=build/symbols`;
  her derlemeden sonra `firebase crashlytics:symbols:upload --app=<APP_ID> build/symbols`. Doğrulama:
  konsolda yığın sembolleşmiş görünmeli; `--split-debug-info` dizini sürüm başına saklanmalı.
- Doğrulama kontrol listesi (gerçek dağıtım derlemesi): Android `uploadCrashlyticsMappingFile*`
  görevi çalıştı mı; iOS Archive çıktısında `Upload Crashlytics Symbols` günlüğü; konsolda "missing
  dSYM" uyarısı yok.

## Gerçek cihaz provası (henüz koşulmadı)

1. Dev release derlemesini gerçek cihaza kur: `flutter run --release --flavor dev -t lib/main_dev.dart`.
2. Profil → "Hata raporlarını gönder" aç. **Nonfatal:** geçersiz yanıt veren sahte sunucuyla bir
   `apiCall` hatası üret; uygulamayı kapatıp yeniden aç → rapor `kind=invalid_response op=…` olarak
   konsolda (gecikme beklenir).
3. **Native crash:** geçici (commit edilmeyen) bir düğmeyle `FirebaseCrashlytics.instance.crash()`;
   yeniden aç → rapor gelir.
4. **Metadata:** raporun cihaz modeli/OS/uygulama sürümü/build alanlarını cihaz ayarlarıyla ve
   `--build-name/--build-number` ile karşılaştır; Kullanıcı kimliği ve Özel anahtarlar boş olmalı.
5. **Geri alma / onaysız:** anahtarı kapat, hata ve çökme üret, yeniden aç → rapor GELMEMELİ. Anahtar
   kapalıyken çökme üret, sonra aç → o çökme gönderilmemeli (açılışta silinir).

## Yapılmayanlar / açık riskler

| Konu | Durum |
|---|---|
| Üretim | Son kaynaklardan `make gen` çalıştırıldı; elle üretilmiş çıktı yok. Temiz ağaçta `make gen-check` sonucu inceleme kaydındadır. |
| Gerçek cihaz/simülatör crash+nonfatal provası, konsol ve metadata doğrulaması | Yapılmadı (cihazlar ve simülatörler ortamda var; prova henüz koşulmadı) |
| Android / iOS debug derlemeleri | Android dev ve Firebase yapılandırması bulunmayan prod APK; iOS dev simülatör: geçti. Release/arşiv/simge yükleme doğrulaması değildir. |
| Genel depo kapıları | Tam verify/CI kabulü verilmedi. Genel boyut testindeki dört sorun başlangıç HEAD'iyle aynı dosyalarda; bu işte değişen 37 el yazımı Dart dosyası kendi tavanlarını geçmiyor. Ayrıntı: `docs/reviews/firebase-hata-takibi-codex.md`. |
| Yazılamayan geri alma | Oturumda kapalı; sonraki açılışta eski `true` okunabilir — kullanıcıya bildirilir |
| Kalıcı SDK `true` bayrağı olan cihaz (eski/harici) | Üretim geçişi koşulu: bulunmadığı doğrulanmalı (yukarıda); kabul edilmiş sınır DEĞİL |
| Profil kartı widget testi | Yazılmadı; tercih mantığı denetleyici testlerinde, kart yalnız sunum |
| Kanal testi kapsamı | Gerçek `firebase_core`/`firebase_crashlytics` Dart kodu + sahte pigeon kanalı; native SDK'nın kendisi değil |
