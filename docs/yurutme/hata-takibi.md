# Hata takibi (Crashlytics) — uygulama ve kabul

Güncelleme (2026-11-12, "uygulama genelinde tamamlama"): hata yolu envanteri, `ReportSource`,
doğrulanmış API işlem kimliği, sabit mesaj, Riverpod gözlemcisi ve kapsam kapısı eklendi (bkz.
"Kapsam" ve `hata-takibi-kapsam.md`). Aşağıdaki durum satırı ÖNCEKİ aşamanın kabulüdür.

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
| `ReportSource` | `core/telemetry/report_source.dart` | hatanın YAKALANDIĞI alan (kapalı küme: `tasks`, `archive`, `preferences`, `provider`, `framework`, `uncaught` …) |
| `ApiCallScope` | `core/telemetry/api_call_scope.dart` | `apiCall` süresince giden isteğin DOĞRULANMIŞ `operationId`'si (Zone değeri) |
| `reportMessage` | `core/telemetry/report_message.dart` | sabit Türkçe teknik açıklama (kapalı kümelerden + yerel hata kataloğu metninden) |
| `toReportedApiError` | `core/telemetry/unexpected_error.dart` | `catch` içinde TEK çeviri yolu: önce `reportUnexpected`, sonra `toApiError` |
| `ErrorReportingProviderObserver` | `lib/app/telemetry/provider_error_observer.dart` | Riverpod `providerDidFail`: build/future/stream/`AsyncError` hataları; `ProviderContainer(observers:)` ile bileşimde bağlı |
| Kapsam kapısı | `tool/error_paths.dart`, `tool/error_path_exceptions.dart` | `make boundaries`; envanter `hata-takibi-kapsam.md` (kaynaktan üretilir) |

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
- **Tek rapor (OLAY bazlı):** tekrar önleme nesne ömrüne değil olaya bağlıdır. Bir hata (nesne,
  yığın) çifti olay olarak işaretlenir; aynı olayın katmanları (`apiCall` → controller → gözlemci →
  küresel kanca) tekrar raporlamaz. Eşleşme: aynı `StackTrace` nesnesi, ya da 30 sn pencerede aynı
  yığın metni, ya da bu olay için YENİ kurulan/dönüştürülen `ApiError` (`invalidResponseError`,
  `toReportedApiError`; katmanlar `throw e` ile yığını yenileyebilir). Yeniden kullanılan nesne
  (`const FormatException`) başka fırlatma noktasından ya da pencere dışında yeniden fırlatılırsa
  YENİ olaydır; hız sınırına takılan ilk olay nesneyi sonsuza bastırmaz. Genel hız sınırı (aynı
  etiket+ilk üç kare 5 dk'da bir) ve oturum tavanı (25, fatal hariç) olaydan bağımsız uygulanır.
- **Beklenen alan sonuçları:** çekirdekteki `ExpectedFailure` işareti (`implements`) taşıyan istisnalar
  (`ActivityUnavailable`, `ArchiveImageTooLarge`, `AssistantDisabled`, `_SaveCancelled`) hiçbir
  katmanda (catch sınırı, sağlayıcı gözlemcisi, küresel kanca) raporlanmaz. Tür adı ya da `_` öneki
  kanıt değildir; kapı yalnız aynı dosyadaki `implements ExpectedFailure` sınıfını denetim akışı sayar.
- **Riverpod sarmalayıcısı:** `ProviderException` (bağımlılık sağlayıcısının hatası) `reportUnexpected`,
  `toApiError`, küresel kanca ve `ErrorReporting.report` girişinde asıl istisna ve ÖZGÜN yığına
  indirilir (iç içe sarmalar sonuna kadar); sağlayıcı adı/meta/durum okunmaz. Beklenen kök 0,
  beklenmeyen kök tek rapor; sarmalayıcı hiçbir zaman ayrı hata olarak gitmez.
- **HTTP 200 akış hata olayı (SSE `hata`):** katalogda 5xx olan teknik kod
  (`platform.internal`, `assistant.provider_unavailable`) `ReportKind.streamServerError` ile raporlanır;
  gerçek HTTP durumu 200 olduğundan durum sınıfı (`status=`) YOKTUR ve ileti "5xx" demez. İş sınırı
  kodları (`assistant.refused`, `limit_exceeded`, `capacity_full`, kota/yoğunluk) beklenen: 0 rapor.
  Olay iletisi (`mesaj`) rapora girmez.
- **Rıza sahipliği:** `ErrorReportingController` her `await`tan sonra ve her SDK/tercih yan
  etkisinden önce istek neslini, ortak bağ (`ErrorReportingBinding`) sahipliğini ve dispose'u
  denetler; yerine başka bileşim bağlanmış/atılmış denetleyicinin geç `load`/`set`/`discard`
  sonucu yeni tekil SDK'yı ya da tercihleri etkilemez (gerçek yan etki sayıları testte).
- **İşlem bağlamı:** `ReportContext.run(op, …)` (Zone; eşzamanlı işlemler karışmaz). Native tarafa
  özel anahtar/kullanıcı kimliği GÖNDERİLMEZ (süreç geneli oldukları için işlemleri karıştırırdı);
  işlem sabiti `exception` etiketindedir (`kind=… op=… src=… api=… type=…`). Kapalı küme: `login,
  session_refresh, task_write, file_upload, file_download, chat_send, chat_stream, assistant_chat,
  local_storage, startup, none`. İç içe bağlamda dıştaki korunur (`runIfNone`; yükleme görev
  yazmasının içinde `file_upload` kalır).
- **API işlem kimliği (`api=`):** her `apiCall` kendi `ApiCallScope`'unu açar; `ApiGuardInterceptor`
  isteği çözüp `operationId`'yi kapsama yazar (yalnız üretilmiş `apiOperations`'ta varsa). Bütün
  `apiCall` çağrı yolları bu mekanizmadan kimlik alır; çağrı yerlerinde elle kimlik yazılmaz (kayma
  olmaz; kapı `apiCall`ın takma adla geçirilmesini yasaklar). Hata
  `DioException` ise isteğin kendi metaverisinden (`openapi.operationId`) alınır. Aynı `apiCall`
  içinde İKİ FARKLI işlem görülürse (paralel istekler) kimlik **boş** kalır — sahte kesinlik yok.
  Elle kurulan yollar (SSE: `assistantChat`, `streamChatEvents`; PDF: `reportWorkloadPdf`; sunucu
  bağı: `instanceProfile`) kimliği `invalidResponseError(apiOperationId: …)` ile açıkça verir ve
  `ErrorReport.create` onu yine `apiOperations`'a karşı doğrular. İstek adresi/parametresi/gövdesi
  hiçbir yerde yoktur.
- **Kaynak (`src=`):** `catch` sınırında `ReportSource.<alan>`; küresel kancalar `framework` /
  `uncaught` ve işlem **`none`** (kancalar kök bölgede çalışır, kullanıcı işlemi bilinemez).
  Riverpod gözlemcisi `provider` (hangi sağlayıcı olduğu BİLİNMEZ ve uydurulmaz; ad, `family`
  argümanı, `toString`, durum anlık görüntüsü okunmaz).
- **Mesaj:** `ErrorReport.message` serbest metin değildir; `reportMessage(kind, errorType, apiCode)`
  sabit Türkçe cümleleri birleştirir ve (kod beyaz listedeyse) kullanıcıya gösterilen genel hata
  iletisinin kaynağı olan yerel katalog metnini (`localizedErrorText`) ekler. Crashlytics
  `exception` alanı `"<etiket> | <mesaj>"`dır. Ham `toString`/`message`, sunucu iletisi, alan adı yok.
- **Yerel (native) çökme bağlamı:** BİLİNÇLİ OLARAK verilmez. Tek bir global özel anahtar eşzamanlı
  işlemlerden yalnız birini yanlış atfederdi; native çökmede "aktif işlem" kesin bilinemez. Gerekirse
  ileride yalnız sabit "aktif işlem sayısı/kümesi" özeti ve eşzamanlılık uyarısıyla düşünülür; şimdilik
  çökme raporu yalnız SDK'nın kendi alanlarını taşır.

## Kapsam (hata yolu envanteri)

`lib/` içindeki her `catch`, `onError`, `catchError`, `handleError`, `AsyncValue.guard`, `AsyncError`
kurma, ham Dio isteği ve `apiCall` takma adı tek kapıdan geçer (`make boundaries` →
`tool/check_error_paths.dart`): hata `catch` GİRİŞİNDE koşulsuz olarak yakalanan değişkenle, cephenin
HATA konumunda rapor cephesine verilir (ya da girişte koşulsuz yeniden fırlatılır; ya aynı dosyada
`implements ExpectedFailure` taşıyan bir sınıftır; ya `tool/error_path_exceptions.dart`'ta
**gerekçeli ve sayısı sınırlı** istisnadır). `on ApiError` tür adıyla muaf DEĞİLDİR: ApiError de
politika yardımcısından geçer (beklenen kod 0, tekrar tek rapor). Rapor `if`/`?:`/`&&`/`??`/kapanış/
döngü içinde ya da önceki bir `return`/`throw`/koşullu çıkıştan SONRA ise sayılmaz (özellikle
`if (!mounted) return;` sonrası rapor yasaktır: bayat durum beklenmeyen hatayı gizlemesin).
Kapıya güvenilen rapor cephesi: bildirimsiz çıplak ad, `import … as p` güvenilir ön eki ya da
dosya düzeyi `final takma = cephe;`; cephe adlarını yerel/parametre olarak yeniden bildirmek (gölgeleme)
E6'dır; başka nesnenin aynı adlı yöntemi cephe değildir. Yardımcı, hatayı kendi parametresinden
girişte koşulsuz cepheye aktarıyorsa sayılır. Envanter (dosya + işlev + tür + sahip, satır numarasız)
`docs/yurutme/hata-takibi-kapsam.md`'dedir ve kaynaktan **üretilir**
(`dart run tool/error_path_inventory.dart`; güncel olduğu `test/tool/error_paths_test.dart`te sınanır).
Kapı yalnız ad/sözdizimi düzeyinde çalışır (tip çözümlemesi yok; genel akış çözümlemesi/lint çatısı
değildir); atlatma biçimleri (gölgeleme, sahte cephe, yanlış hata, koşullu/erişilemez/tembel rapor,
koşullu `rethrow`, özel hata, `AsyncError`, tear-off `onError`, yorum/dize içinde ad) negatif
fixture'larla kanıtlıdır.

Bağımsız async: `unawaited(...)` ve `onError`'suz `.listen(...)` yolları hatayı YUTMAZ; yakalanmamış
hata `PlatformDispatcher.onError`'a (`src=uncaught`, `op=none`) düşer. Yutan her `then(onError:)`,
`catchError` ve `handleError` kapıda yukarıdaki kurala tabidir.

Karar tablosu: beklenen sınıflar (doğrulama, yanlış parola, 401/403/409, iptal, zaman aşımı, ağ/IO
kopması, TLS) `reportUnexpected` içinde süzülür; yerel depo/ayrıştırma bozulması **tipli** raporlanır
(`storage`, `serialization`); kasıtlı "varsayılana dön" yolları (tercih okunamadı, kapsam kaydı bozuk)
davranışı değiştirmeden sebebi rapor eder. Provider hatalarında önce `catch` sınırı (özgün yığın,
işlem bağlamı) raporlar; gözlemci yalnız kaçanları yakalar ve aynı hata nesnesini tekrar raporlamaz.

## Yük sınırı (gönderilen alanlar)

`ErrorReport.create` tek kurma yoludur: `kind/op/src/type` (kapalı enum), `api` (yalnız üretilmiş
`apiOperations`'ta varsa), `code` yalnız sunucu hata kataloğu veya istemci kodu listesinde varsa,
`status` yalnız `2xx…5xx` sınıfı, `fatal`, ve `SanitizedStackTrace`; sabit `message` bunlardan türer. Yığın beyaz listeyle yeniden kurulur: tanınan `#N sembol (package:|dart:…:satır:sütun)`,
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
- Onay yazı şeridi (depo bazında, `AppPreferences`): onay VERME yazısı sıra işi içinde, fiziksel
  yazıdan önce ve sonra sahiplik/nesli (`isCurrent`) sorar; yazıdan sonra bayatsa `false`/silme geri
  alması AYNI sıra işinde yapılır, şerit ondan önce serbest kalmaz — yeni sahibin okuması bayat
  `true`'yu görmez. Geri alma `false` ve silme ikisi de düşerse şerit KİLİTLENİR: okuma kapalı,
  gönderim 0; açık başarılı `false`/silme ya da geçerli yeni onay yazısı kilidi kaldırır. Çağıranın
  500 ms beklemesi yalnız gecikme sınırıdır; gerçek yazı hatası (500 ms sonra bile) şerit kolunda
  özgün hata ve yığınla bir kez raporlanır. **Dürüst sınırlar:** başlamış fiziksel yazı iptal
  edilemez ve platform ack'i beklenir; kilit yalnız bu süreçte geçerlidir (süreç ölürse kayıtta bayat
  `true` kalabilir); geçerlik sorusu ile denetleyicinin devamı arasındaki mikro görev aralığında
  sahip değişirse yalnız bayat-sonrası dar geri alma yolu çalışır.
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
| Kanal testi kapsamı | Gerçek `firebase_core`/`firebase_crashlytics` Dart kodu + sahte pigeon kanalı; native SDK'nın kendisi değil. Yük (etiket + SABİT mesaj) `crashlytics_channel_test`te tam dizgi olarak doğrulanır |
| Gerçek native SDK duman testi | `integration_test/crash_reporting_native_test.dart`: test-only AÇIK opt-in (`--dart-define=NIZAM_NATIVE_CRASH_SMOKE=true`; yoksa atlanır). Yalnız `await sdk.recordError(güvenli yük)` Future'ının tamamlandığını (= native köprü çağrıyı KABUL etti), toplamanın kapalı kaldığını (`automatic=false`) ve PackageInfo metadata'sını doğrular. "Yerelde yazıldı/silindi" İDDİA ETMEZ (resmî SDK raporları önceki oturumda/açılışta paketler; `checkForUnsentReports` süreçte bir kez true, ikinci false silme kanıtı değildir); `deleteUnsentReports`/`sendUnsentReports` çağırmaz. Bu oturumda **koşulmadı** |
| Native yerel kanıt dizisi (manuel) | `integration_test/crash_reporting_native_probe.dart` (`_test` soneki yok: otomatik keşfe girmez; mod yoksa hiçbir şey yapmaz). `--dart-define=NIZAM_NATIVE_PROBE_MODE=` `record` → (yeniden açılan taze süreç) `check_pending` (true) → `delete` → (yeni taze süreç) `check_empty` (false). `send` (dev gönderim) ve `crash` (yalnız açık modda native test çökmesi; sabit güvenli günlük "armed") bulut kanıtıdır ve Firebase konsol oturumu gerektirir — **bulut erişimi henüz yok, doğrulanmadı**. Her mod tek taze süreçtir; `ErrorReportingController` kullanılmaz (önbellek kanıtını silmesin). `deleteUnsentReports` ACK'i fiziksel disk silme garantisi değildir; kanıt `check_empty`dir. Koordinatör yalnız İZOLE simülatör verisinde dener |
| Native çökme bağlamı | Verilmez (yukarıda gerekçe); çökme raporu yalnız SDK alanlarını taşır |
| Kapsam kapısı sınırı | Ad/sözdizimi düzeyinde; tip çözümlemesi ve genel akış çözümlemesi yok. Cephe adını yerel/parametre olarak yeniden bildirmek (gölgeleme) E6 ihlalidir; yardımcı yalnız hatayı kendi parametresinden `catch` girişinde koşulsuz cepheye aktarıyorsa sayılır. Karmaşık bilinçli yollar (seçici `rethrow`, çok dallı akış) kapsamda DEĞİL: gerekçeli dar istisna ister |
| Provider adı | Sağlayıcı hataları `src=provider` ile gelir; hangi sağlayıcı olduğu bilinçli olarak yoktur (dinamik ad/family sızıntısı riski) |
