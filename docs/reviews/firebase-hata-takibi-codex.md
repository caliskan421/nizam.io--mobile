# Firebase hata takibi — Codex son denetimi

2026-11-12 · Dal: `ozellik/firebase-hata-takibi-ve-surum-yonetimi`.
Uygulayıcı: Sonnet 5.5; koordinatör ve bağımsız doğrulama: Codex.
İlk çalışma `773e456`, uygulama geneli kapsam başlangıcı `44269dd`;
son üretim kodu `6c1db95` (önceki kapsam commit'leri `897d441`, `0f97790`).

**Hüküm: yerel uygulama ve hedefli kabul kontrolleri uygun; yayın/CI kabulü verilmedi.**
Üç bağımsız alt ajan kapsam, gizlilik ve doğrulamayı paralel inceledi. Bulgular Sonnet'e
uygulatıldı; son turda açık somut bulgu kalmadı. Genel proje kapılarının eski borçları
ve aşağıdaki native/yayın sınırları ayrıca geçerlidir.

## Tamamlanan kapsam

- Merkezi API sınırı, yerel dönüşümler, controller/sunum catch'leri, Riverpod
  gözlemcisi ve global kancalar ortak sınıflandırıcıya bağlıdır. Ekran kapansa da
  hata raporlanır; yalnız durum yazısı güncel sahipliğe bağlıdır.
- Rapor kaynağı, doğrulanmış API operationId ve sabit Türkçe teknik açıklama taşır.
  Ham istisna/sunucu mesajı, içerik, belirteç, gövde, URL ve dinamik işlem adı taşınmaz.
  Beklenen domain sonuçları elenir; provider sarmalayıcılarında kök hata/yığın korunur.
- SSE HTTP200 teknik hata olayları ayrı türdür; 503 uydurulmaz. JSON, binary/PDF,
  bağlantı ve batch yolları incelendi. Depolamanın 500ms timeout sonrasında gelen
  gerçek yazma hataları da özgün yığınla raporlanır.
- Tekrar önleme yayılım/olay penceresine bağlıdır; aynı hata ve yığın nesnesinin
  sonraki olayı sonsuza bastırılmaz. Oturum ve hız sınırları korunur.
- Onay fiziksel yazıları ortak platform depo kuyruğunda sıralanır. Bayat grant'in
  rollback'i aynı bariyerdedir. Geçerli sahibin kabul ettiği revoke hemen kalıcı
  false→gerekirse silme işlemine girer; replacement/dispose bu niyeti kaybettirmez.
  Zaten bayat sahip yeni iş başlatamaz; sonraki geçerli grant sırayla uygulanır.
  Canlı geçerlilik, A5'e uygun tipli `ErrorReportingGrantValidity` portuyla taşınır.
- AST kapsam kapısı gerçek catch hatasını ve erişilebilir raporlama yolunu arar;
  gölgeleme, ilgisiz hata, koşullu/lazy/erişilemez çağrı ve finally kaçışları sınanır.
  Gerekçeli istisnalar [üretilmiş envanterde](../yurutme/hata-takibi-kapsam.md) kayıtlıdır.
  Bu kapı genel bir kontrol akışı çözücüsü değildir; karmaşık yolda sade raporlama
  girişi veya dar, denetlenmiş istisna gerekir.

## Son bağımsız yerel doğrulama

| Kontrol | Gerçek sonuç |
|---|---|
| Telemetri, preferences, network, HTTP, app telemetry, AST, chat sync, assistant, notifications ve meeting-room regresyonları | **331 test geçti**, çıkış 0; `--concurrency=2 --reporter expanded` |
| Gerçek lib ağacında public API/A5 sızıntısı | Ayrı `api_surface_test` hedefi geçti, çıkış 0 |
| Değişen el yazımı Dart analizi | **129 dosya**, hata/uyarı yok; `api_operation_context_test.dart:33` için bir biçem bilgisi |
| Hata yolu kapısı | **1508 dosya**, ihlal yok |
| Envanter güncelliği | **238 yol: 164 rapor, 15 iletim, 1 beklenen denetim akışı, 58 gerekçeli istisna** |
| Bağımsız adversarial AST harness | **24 geçersiz örnek reddedildi, 5 geçerli örnek geçti** |
| Dosya boyutu | Değişen 129 el yazımı Dart dosyasında yeni tavan ihlali yok; tavan yükseltilmedi |
| Android dev Debug APK | `flutter build apk --debug --flavor dev -t lib/main_dev.dart --no-pub` geçti |
| Android prod Debug APK | `flutter build apk --debug --flavor prod -t lib/main_prod.dart --no-pub` geçti |
| iOS dev simülatör uygulaması | `flutter build ios --simulator --debug --flavor dev -t lib/main_dev.dart --no-pub` geçti |
| Son temiz ağaçta kod üretimi | Son kaynak/probe kaydı sonrasında `make gen-check` sonucu aşağıya eklenecek |
| Fark temizliği | `git diff --check` geçti |

Önceki ilk aşamada 532 test ve native yapılandırma kontrolleri de geçmişti; bu sayı
son kapsam koşumunun test sayısı değildir. Eski sağlayıcı hash farkları gerçek
üreticiyle düzeltildi (`0f97790`); üretilmiş kaynaklar elle düzenlenmedi.

## Gerçek SDK ve Firebase konsolu kanıtı

Yalnız bu iş için oluşturulan ayrı iOS simülatöründe gerçek SDK kullanıldı.
Opt-in smoke testinde automatic=false, await edilen güvenli recordError kabulü ve
native PackageInfo doğrulandı. Ayrı dört süreçte kayıt → pending=true → silme →
yeni süreçte pending=false doğrulandı. SDK köprü ACK'i tek başına diske kalıcı
yazma/silme kanıtı sayılmadı.

Test probe'u yalnız açık modla çalışır; record/record_crash ayrıca
`NIZAM_NATIVE_PROBE_RECORD_DISCARD=true` ister ve önceki sentetik kayıtları siler.
Diğer modlarda otomatik temizlik yoktur. Süreçler arası prova `--no-uninstall`
ile yapıldı. SDK'nın opt-in başlangıç kararını çözmek için sentetik kayıt modunda
açık silme kararı gerekir. Bekleme süreleri flush/teslim garantisi sayılmaz.
Native crash sırasında host bağlantısının kaybı beklenen süreç sonudur; geçen
birim test gibi sayılmadı, sonraki süreç ve konsol ile doğrulandı.

Kullanıcı tarayıcıdan giriş yaptı; parola/token alınmadı. Firebase konsolunda:

| Alan | Gözlenen değer |
|---|---|
| Proje / uygulama | `nizamio-mobile` / `io.nizamio.mobile.dev` |
| Sürüm / build | **0.2.0 (2)** |
| İşletim sistemi / cihaz | **iOS 27.2.0 / iOS Simulator (iPhone)** |
| Nonfatal | `kind=unexpected op=none src=app type=state_error` ve sabit Türkçe açıklama |
| Yığın | `_discardAndRecord`, temizlenmiş `<local>` yolu |
| Anahtarlar | SDK'nın kendi `flutter_error_exception` anahtarında aynı güvenli etiket/açıklama; uygulama özel anahtar veya kullanıcı kimliği eklemiyor |
| Nonfatal log/breadcrumb | Boş |
| Native crash | `FirebaseCrashlyticsTestCrash`; uygulama Swift çerçeveleri çözümlendi |

Sentetik nonfatal için `op=none` doğrudur: iş API'si çağrılmadı. Gerçek operationId
bağlama ve eşzamanlılık davranışı hedefli testlerde doğrulandı.

İşlenmiş [nonfatal raporu](https://console.firebase.google.com/project/nizamio-mobile/crashlytics/app/ios:io.nizamio.mobile.dev/issues/7858e12dac7b11b0bc52319fdddd6410)
ve [native crash raporu](https://console.firebase.google.com/project/nizamio-mobile/crashlytics/app/ios:io.nizamio.mobile.dev/issues/88e96a972cc9e22bb45a9128133d1529)
12 Kasım 2026 17:22:41/17:22:44 olaylarıdır.

Çöken kurulu binary'nin özgün UUID'li dSYM'leri alındı; yerel kullanıcı yolu
önekleri uzunluk korunarak temizlendi. UUID ve DWARF doğrulamasından sonra resmî
upload-symbols aracı başarılı çıktı. Runner.debug UUID'si
`3BE890AA-9322-3170-A5B3-ABA8580D0286`; konsolda AppDelegate/FlutterFire Swift
çerçeveleri çözüldü. Preview/App stub'larında ve bazı Apple/Flutter simülatör
çerçevelerinde sembol eksikleri vardır; bütün yığının çözüldüğü iddia edilmez.

## Açık sınırlar ve mevcut borçlar

- Konsolda **farklı/önceki bir binary'ye ait tek işlenmemiş olay** için
  `C1659B9A-09CB-3AA4-AF88-7B2B80BF9ED9` özgün dSYM'i eksik. İlgili yerel binary,
  dSYM ve Spotlight aramasında bulunmadı; UUID uydurulmadı, olay silinmedi veya
  uyarı gizlenmedi. Olayın kökeni kesinleştirilemedi. Bu eksik, yukarıdaki yeni
  işlenmiş iki olaydan ayrıdır; özgün derleme artifaktı olmadan giderilemez.
- Native SDK'nın kendi verisi Dart ayıklamasından geçmez. Otomatik Crashlytics
  toplama her zaman false, prod Firebase kapalı, Analytics kapalıdır. Eski/harici
  kalıcı true override bulunmadığının üretim geçişinde doğrulanması gerekir.
- Fiziksel Android/iOS cihazda ve release/arşiv dağıtımında kabul yapılmadı.
  Debug APK/simülatör başarısı bunların yerine geçmez.
- Genel boyut borçları: `detail_actions.dart` 750/742, `activity_page.dart` 585 ile
  legacy listesinde, `timeline_chart.dart` 668/666, `gantt_chart.dart` 1040/868.
  Dördü de kapsam başlangıcı `44269dd` ile bayt düzeyinde aynı doğrulandı.
- Değiştirilmeyen UI/table/gantt/home/archive-preview alanlarında 16 eski
  U1/U2/U3/D2 ihlali; önceki tablet ölçüm, release-policy “Kapat” ve test-presence
  borçları sürüyor. Tam verify yeşil sayılmadı; testler zayıflatılmadı. Bu işte
  bulunan A5 sızıntısı giderildi ve ayrı hedefle doğrulandı.
- KR-27 gereği mobil CI tetiklenmedi. Push, PR veya merge yapılmadı. Yeni paket
  ve kilit dosyası değişikliği yok. Ham log/artifaktlar git'e alınmadı. Yalnız bu
  işin simülatörü kapatılıp silindi; diğer cihazlara dokunulmadı.

Süreç şeffaflığı: ilk uygulayıcı kabuk düzenlemesi/Monitor ve geçici worktree
protokolüne uymadığını bildirdi; kendi geçici worktree'sini kaldırdı. Sonraki
turda iki `sed -i` kullanımı (chat clock ve AST test beklenti sırası) araç izinden
doğrulandı. Koordinatör çıktıları inceledi; sonraki turlarda sed/Python/perl kaynak
düzenleme araçları engellendi. Reddedilen yazı denemeleri tekrarlanmadı. Kaynak
ve test sonuçları bağımsız doğrulandı; ihlaller gizlenmedi.
