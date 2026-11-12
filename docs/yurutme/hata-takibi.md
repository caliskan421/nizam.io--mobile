# Hata takibi (Crashlytics) — uygulama ve kabul

Durum (2026-11-12): Sonnet uyguladı; Codex ve üç paralel alt ajan denetledi, bulunan açıklar
düzeltildi. Son bağımsız koşumda **331 test** geçti; 129 el yazımı Dart dosyasının analizinde
hata/uyarı yok (bir biçem bilgisi var). 1508 dosyada hata yolu kapısı temiz; 238 yolun sahibi
[`hata-takibi-kapsam.md`](hata-takibi-kapsam.md) içinde dosya/işlev düzeyinde kayıtlıdır.

Gerçek iOS SDK ile nonfatal/native çökme, dört süreçte yerel kayıt/silme ve Firebase konsolu
doğrulandı: **0.2.0 (2), iOS 27.2.0, iOS Simulator (iPhone)**. Konsolda temizlenmiş Türkçe
mesaj, `<local>` yığını ve çözümlenmiş uygulama Swift çerçeveleri görüldü. Son derleme/üretim
kanıtı ve kapsam dışı mevcut borçlar [Codex inceleme kaydındadır](../reviews/firebase-hata-takibi-codex.md).
Yayın/CI kabulü verilmedi. Prod Firebase kapalı, Analytics kapalıdır; yeni paket/kilit değişikliği yok.

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
- **Rıza sahipliği:** `ErrorReportingController` istek nesli, ortak bağ
  (`ErrorReportingBinding`) ve dispose durumunu denetler. Çağrı anında bayat olan denetleyici
  yeni tercih/SDK işi başlatmaz. Geçerli sahibin kabul edilmiş geri alma isteği ise hemen ortak
  kalıcı kuyruğa girer; sonraki replacement/dispose bu isteği iptal etmez. SDK ve UI işleri
  güncel sahiplik kontrollerinde kalır.
- **İşlem bağlamı:** `ReportContext.run(op, …)` (Zone; eşzamanlı işlemler karışmaz). Native tarafa
  uygulama özel anahtar/kullanıcı kimliği EKLEMEZ (süreç geneli oldukları için işlemleri karıştırırdı);
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
  FlutterFire iOS SDK ayrıca kendi `flutter_error_exception` anahtarına aynı temizlenmiş
  etiket/mesajı yazar; konsolda bu tek SDK anahtarı doğrulandı. Uygulama ayrıca custom key yazmaz.
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
kimlikler, kullanıcı içeriği, dosya adı/yolu, ham `reason`/`information` veya uygulama kullanıcı kimliği.
SDK'nın otomatik `flutter_error_exception` alanı da yalnız temizlenmiş etiket/mesaj taşır.
Genel `Log` çıkışı Crashlytics'e bağlı değildir.

## Onay (kullanıcı tercihi)

- `AppPreferences.errorReportingKey`: yalnız `'true'` onaydır; yok/bozuk/okunamaz = kapalı. Remote
  Config `crash_reporting_enabled` izin yerine geçmez ve okunmaz.
- Gönderim (`sendUnsentReports`) yalnız tercih okunduktan SONRA ve istek hâlâ geçerliyse yapılır;
  okuma sürerken geri alma gelirse gönderilmez.
- Açma: önce `deleteUnsentReports` isteği süresi içinde başarıyla kabul edilmelidir.
  Native köprü tamamlanması fiziksel disk silmesinin atomik garantisi değildir; nominal silme
  davranışı ayrı yeni süreçte `check_empty=false` ile sınandı. Açılıştaki silme hata/zaman aşımı verdiyse "açıkça yeniden deneme"
  yalnız kullanıcı açma eylemiyle olur; yine belirsizse tercih YAZILMAZ, kapı AÇILMAZ ve kullanıcıya
  bildirilir (aksi halde sonraki açılış onaydan önceki raporu gönderirdi). Sonra tercih yazılır
  (yazılamazsa açılmaz; kapalı yazılmaya çalışılır) → Dart kapısı açılır. Yazma gecikmeli bitip arada
  geri alınırsa eski istek kapıyı açamaz (nesil sayacı); kapı geri almada eşzamanlı kapanır.
- Kapıyı yalnız geçerli bağ ([`ErrorReportingBinding`]) değiştirir: yerine başka bileşim
  bağlandıysa eski denetleyicinin geç `load`/`set` sonuçları yeni kapıyı açıp kapatamaz.
- Onay yazı şeridi (depo bazında, `AppPreferences`): onay VERME yazısı sıra işi içinde, fiziksel
  yazıdan önce ve sonra tipli `ErrorReportingGrantValidity.isCurrent` üzerinden sahiplik/nesli sorar;
  yazıdan sonra bayatsa `false`/silme geri
  alması AYNI sıra işinde yapılır, şerit ondan önce serbest kalmaz — yeni sahibin okuması bayat
  `true`'yu görmez. Geri alma `false` ve silme ikisi de düşerse şerit KİLİTLENİR: okuma kapalı,
  gönderim 0; açık başarılı `false`/silme ya da geçerli yeni onay yazısı kilidi kaldırır. Çağıranın
  500 ms beklemesi yalnız gecikme sınırıdır; gerçek yazı hatası (500 ms sonra bile) şerit kolunda
  özgün hata ve yığınla bir kez raporlanır. **Dürüst sınırlar:** başlamış fiziksel yazı iptal
  edilemez ve platform ack'i beklenir; kilit yalnız bu süreçte geçerlidir (süreç ölürse kayıtta bayat
  `true` kalabilir); geçerlik sorusu ile denetleyicinin devamı arasındaki mikro görev aralığında
  sahip değişirse yalnız bayat-sonrası dar geri alma yolu çalışır.
- Geri alma: kapı ve ortak şerit hemen kapanır; çağrı anında tek atomik `false` → gerekirse
  `remove` işi kalıcı kuyruğa eklenir. SDK kuyruğu, replacement veya dispose bunu atlatamaz;
  daha sonra kabul edilen yeni grant arkasına sıralanır. İki kalıcı işlem de olmazsa
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

## Fiziksel cihaz / release provası (henüz koşulmadı)

1. Dev release derlemesini gerçek cihaza kur: `flutter run --release --flavor dev -t lib/main_dev.dart`.
2. Profil → "Hata raporlarını gönder" aç. **Nonfatal:** geçersiz yanıt veren sahte sunucuyla bir
   `apiCall` hatası üret; uygulamayı kapatıp yeniden aç → rapor `kind=invalid_response op=…` olarak
   konsolda (gecikme beklenir).
3. **Native crash:** yalnız izole test cihazında test-only probe kullan; ürün koduna test düğmesi
   ekleme. Yeniden açılışta onaylı gönderim ve konsol sonucunu ayrı doğrula.
4. **Metadata:** raporun cihaz modeli/OS/uygulama sürümü/build alanlarını cihaz ayarlarıyla ve
   `--build-name/--build-number` ile karşılaştır; uygulama kullanıcı kimliği eklememeli,
   `flutter_error_exception` yalnız temizlenmiş yükü taşımalı.
5. **Geri alma / onaysız:** anahtarı kapat, hata ve çökme üret, yeniden aç → rapor GELMEMELİ. Anahtar
   kapalıyken çökme üret, sonra aç → o çökme gönderilmemeli (açılışta silinir).

## Yapılmayanlar / açık riskler

| Konu | Durum |
|---|---|
| Üretim | Son kaynaklardan `make gen` çalıştırıldı; elle üretilmiş çıktı yok. Temiz ağaçta `make gen-check` sonucu inceleme kaydındadır. |
| iOS SDK / konsol | İzole simülatörde native ve nonfatal işlendi; sürüm/build, OS, cihaz, güvenli mesaj/anahtar/yığın doğrulandı. Fiziksel Android/iOS release provası yapılmadı. |
| Android / iOS debug derlemeleri | Android dev ve Firebase yapılandırması bulunmayan prod APK; iOS dev simülatör: geçti. Release/arşiv/simge yükleme doğrulaması değildir. |
| Genel depo kapıları | Tam verify/CI kabulü verilmedi. Dört boyut borcu başlangıçla birebir aynı; değişen 129 el yazımı Dart dosyasında yeni tavan ihlali yok. API sızıntısı kontrolü geçti; mevcut 16 UI/D2 sınır borcu ayrı. |
| Yazılamayan geri alma | Oturumda kapalı; sonraki açılışta eski `true` okunabilir — kullanıcıya bildirilir |
| Kalıcı SDK `true` bayrağı olan cihaz (eski/harici) | Üretim geçişi koşulu: bulunmadığı doğrulanmalı (yukarıda); kabul edilmiş sınır DEĞİL |
| Profil kartı widget testi | Yazılmadı; tercih mantığı denetleyici testlerinde, kart yalnız sunum |
| Kanal testi kapsamı | Gerçek `firebase_core`/`firebase_crashlytics` Dart kodu + sahte pigeon kanalı; native SDK'nın kendisi değil. Yük (etiket + SABİT mesaj) `crashlytics_channel_test`te tam dizgi olarak doğrulanır |
| Gerçek native SDK duman testi | Açık `NIZAM_NATIVE_CRASH_SMOKE=true` ile geçti: gerçek `await recordError`, `automatic=false`, PackageInfo. Tek başına disk/teslim kanıtı sayılmadı. |
| Native yerel kanıt dizisi | Probe ile dört ayrı süreçte `record` → `check_pending=true` → `delete` → `check_empty=false` geçti. `--no-uninstall` zorunlu; Flutter test varsayılanı uygulama verisini kaldırır. `record` ayrıca `NIZAM_NATIVE_PROBE_RECORD_DISCARD=true` ister ve eski sentetik raporları silerek SDK başlangıç kararını verir. Yalnız izole veride kullanılır. |
| Native bulut kanıtı | `record_crash` aynı ikinci opt-in ile güvenli nonfatal + native çökme üretir. Derleme değişmeden UUID/dSYM snapshot'ı alınır; yerel kullanıcı önekleri anonimleştirilip UUID/DWARF doğrulanır, semboller yüklenir. Yeni süreçte `send`; 60sn yaşam süresi payı teslim garantisi değildir. Konsolda iki işlenmiş olay ayrıca görüldü. |
| Önceki eksik sembol | Konsolda `C1659B9A-09CB-3AA4-AF88-7B2B80BF9ED9` için 1 işlenmemiş olay kaldı. Özgün ikili/dSYM mevcut derlemelerde ve indekste bulunamadı; uyarı gizlenmedi. Yeni doğrulanan olayların uygulama çerçeveleri çözümlendi; bazı simülatör sistem/Flutter çerçeveleri sembolsüzdür. |
| Native çökme bağlamı | Verilmez (yukarıda gerekçe); çökme raporu yalnız SDK alanlarını taşır |
| Kapsam kapısı sınırı | Ad/sözdizimi düzeyinde; tip çözümlemesi ve genel akış çözümlemesi yok. Cephe adını yerel/parametre olarak yeniden bildirmek (gölgeleme) E6 ihlalidir; yardımcı yalnız hatayı kendi parametresinden `catch` girişinde koşulsuz cepheye aktarıyorsa sayılır. Karmaşık bilinçli yollar (seçici `rethrow`, çok dallı akış) kapsamda DEĞİL: gerekçeli dar istisna ister |
| Provider adı | Sağlayıcı hataları `src=provider` ile gelir; hangi sağlayıcı olduğu bilinçli olarak yoktur (dinamik ad/family sızıntısı riski) |
