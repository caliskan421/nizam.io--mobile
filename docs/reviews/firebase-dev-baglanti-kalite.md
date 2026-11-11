# Firebase dev bağlantısı — yerel kalite

2026-11-11 · `ozellik/mesajlasma-ui` · taban `9007054`.

Kullanıcının verdiği istemci dosyaları aynı `nizamio-mobile` projesi ve
`io.nizamio.mobile.dev` uygulama kimliğiyle doğrulandı. Android dosyası `src/dev`,
iOS dosyası `Firebase/dev` altında saklanır. Bunlar istemci yapılandırmalarıdır;
servis hesabı, APNs anahtarı veya backend kimlik bilgisi eklenmedi.

## Davranış

Yalnız dev Android/iOS'ta Core başlatılır; iki saniyelik süre aşımı/hata kapalı portlara
döner. Geç tamamlanan başlatma o koşumdaki bileşimi değiştirmez. Başarılı başlangıçta
ilk kareden sonra bir Remote Config okuması yapılır ve reaktif sağlayıcıda tutulur.
FCM otomatik başlatma, izin/token isteği, Analytics ve Crashlytics toplama kapalı kalır.
Prod/web/masaüstü SDK başlatmasına girmez.

Android Google Services 4.5.0 yalnız flavor'ın dosyasını işler. Prod dosyası yoksa
ilgili Google Services görevi devre dışı kalır ve kendi eski kaynaklarını temizler.
iOS copy phase her koşumda önce eski hedef plist'i kaldırır; bundle kimliği eşleşmiyorsa
derlemeyi durdurur. Prod dosyası yoksa plist eklemeden devam eder.

## Kanıt

- İlgili uygulama/config/push/DI regresyonları: **71/71 geçti**.
- Native flavor seçimi ve giriş noktası regresyonları: **2/2 geçti** (macOS).
- Gerçek iPhone simülatörü `integration_test/firebase_development_test.dart`:
  **1/1 geçti**. Native Core `nizamio-mobile` ile başlatıldı, FCM auto-init kapalı
  doğrulandı ve gerçek Remote Config `lastFetchStatus.success` verdi.
- Android dev debug APK: **derlendi**. Üretilen Google kaynaklarında doğru proje
  kimliği ve app ID doğrulandı; APK string tablosunda `google_app_id`/`project_id` var.
- Android prod debug APK: **derlendi**; APK kaynak tablosunda `google_app_id` ve
  `project_id` bulunmadığı doğrulandı. Yalnız dev Google Services çıktısı kaldı.
- iOS prod simülatör uygulaması: **derlendi**; kimlik `io.nizamio.mobile`,
  `GoogleService-Info.plist` bulunmadığı doğrulandı.
- Sonrasında `lib/main_dev.dart` ile normal dev uygulaması yeniden derlendi;
  dev plist kimliği doğrulanıp iPhone ve iPad simülatörlerine yüklendi. İki cihazda
  normal uygulama süreçleri çalışıyor; test listener paketi bırakılmadı.
- Uygulama/config/integration alanında `flutter analyze --fatal-infos`: **bulgu yok**.
- Native regresyon testi `dart analyze --fatal-infos`: **bulgu yok**.
- `dart run tool/check_test_presence.dart`: **eksik test yok**.
- `git diff --check`: **yeşil**.

İlk cihaz denemesi önceki flavor xcconfig'lerinin sabit `FLUTTER_TARGET` atamasının
Flutter test listener hedefini ezdiğini gösterdi. Altı atama kaldırıldı; CLI/Generated
hedefi korunuyor. İlk bekleyen test süreci durduruldu, düzeltilmiş gerçek test geçti.
Bu davranış kaynak denetimiyle ayrı regresyon testine alındı.

## Bağımsız inceleme ve sınırlar

GPT-6.1 `push_review` SDK yaşam döngüsü, hata/timeout, native flavor seçimi ve veri
toplama ayarlarını salt okunur inceledi; bu dilimde düzeltme gerektiren bulgu bildirmedi.
Giriş noktası hatası sonradan gerçek cihaz testinde bulundu ve yukarıdaki gibi kapandı.

Gerçek APNs/FCM teslimi veya native backend kayıt uçları bu işte yoktur. Remote Config
okuması güncelleme ekranını henüz açmaz; onaylı politikanın kalıcılığı ve UI bağlantısı
[sonraki adımlarda](../yurutme/firebase-kurulum-ve-kontroller.md) durur. SDK paketlerinin
mevcut Kotlin/SDK XML uyumluluk uyarıları nedeniyle bağımlılık sürümleri değiştirilmedi.
Uzak CI tetiklenmedi (KR-27); tam verify ve önceki genel depo borçları kapanmış sayılmaz.
