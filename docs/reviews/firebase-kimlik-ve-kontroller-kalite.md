# Firebase kimliği ve uzaktan kontroller — yerel kalite

Tarih: 2026-11-11. Dal: `ozellik/mesajlasma-ui`.
Kapsam: kalıcı reverse-domain kimliği, dev/prod ayrımı, Remote Config sürüm/build
karar mantığı ve kapalı Firebase kaynağı. Gerçek Firebase projesine bağlanılmadı.

## Doğrulama

- Politika + Remote Config adaptörü + DI + mevcut push regresyonları:
  **64/64 test geçti**, `agir-is.sh` üzerinden. Yeni politika testleri 6,
  adaptör testleri 5 ve DI testleri 2.
- Değişen Dart alanlarında `flutter analyze --fatal-infos`: **bulgu yok**.
- Değişen 7 Dart dosyasında format: **fark yok**.
- `dart run tool/check_test_presence.dart`: **eksik test yok**.
- `git diff --check`: **yeşil**.
- iOS proje ve plist sözdizimi: **yeşil**.
- `xcodebuild -list`: **yeşil**; dev/prod şemaları ve Debug/Profile/Release
  yapılandırmaları tanınıyor. Runner/RunnerTests kimlikleri ve SPM prepare adımı korundu.
- iOS dev simülatör derlemesi: **yeşil**; üretilen uygulamanın plist kimliği
  `io.nizamio.mobile.dev` olarak doğrulandı.
- iOS prod simülatör derlemesi: **yeşil**; üretilen uygulamanın plist kimliği
  `io.nizamio.mobile` olarak doğrulandı. Her iki derleme de `--no-pub`, ilgili
  `--flavor` ve giriş noktasıyla `agir-is.sh` üzerinden çalıştırıldı.
- Android dev debug APK derlemesi: **yeşil** (`assembleDevDebug`, `agir-is.sh`).
  `apkanalyzer manifest application-id` çıktısı `io.nizamio.mobile.dev`.
  Derleme mevcut Firebase paketlerinin gelecekteki Built-in Kotlin geçişi,
  SDK XML sürümü ve deprecated API kullanımı hakkında uyarılar verdi; hata yok.
  Android prod APK ve mağaza imzası bu koşumun kapsamında değildir.

Politika testleri sayısal sürüm sıralamasını, platform ayrımını, eşit sürümde build
sınırını, zorunlu/isteğe bağlı ayrımını, bozuk değerlerin reddini ve backend asgari
sürümünün korunmasını doğrular. Adaptör testleri önbellek/ağ sırasını, çevrimdışı ilk
okumayı, geçerli politikanın bozuk adayla değiştirilmemesini ve güvenli varsayılanı
korur. Yapıcı/DI testleri kendiliğinden SDK isteği veya izin başlamadığını doğrular.

## Bağımsız inceleme

GPT-6.1 `push_review` salt okunur olarak politika, adaptör, DI, testler ve native
flavor yapılandırmalarını inceledi; mevcut kapsamda düzeltme gerektiren bulgu bildirmedi.
`origin.remote` tazelik garantisi değildir; bu ayrım kod yorumunda açıklandı.

## Kalan işler

Gerçek JSON/plist, Firebase başlatma, flavor'a göre dosya seçimi ve Remote Config
güncelleme ekranı bağlantısı henüz yoktur. Crashlytics/Analytics bayrakları SDK toplama
mekanizmasını henüz yönetmez. APNs/FCM teslimi veya mağaza imzalaması doğrulanmadı.
Geçerli Remote Config politikasının süreçler arası ayrı kalıcılığı ve eskime davranışı
UI zorunlu güncelleme kapısından önce tamamlanmalıdır; [plan](../yurutme/firebase-kurulum-ve-kontroller.md).

Uzak CI tetiklenmedi (KR-27). Tam verify bu dilimde tekrarlanmadı; önceki kalite
kaydındaki genel depo kapısı borçları kapanmış kabul edilmez.
