# Native push ilk dilim — yerel kalite kaydı

Tarih: 2026-11-11. Dal: `ozellik/mesajlasma-ui`.
Kapsam: kapalı native push portu, Firebase taşıma adaptörü, kayıt yaşam döngüsü,
bileşim kökü bağlantısı ve otomatik Firebase toplamanın kapalı tutulması.

## Kanıt

- `flutter test test/core/notifications test/app/notifications test/app/push_composition_test.dart test/app/composition_test.dart test/features/notifications --concurrency=1 --reporter=compact`: **79/79 geçti** (`agir-is.sh` üzerinden).
- Yeni testler: kayıt yaşam döngüsü **9**, Firebase adaptörü **14**, bileşim bağlantısı **2**.
- Değişen Dart alanlarında `flutter analyze --fatal-infos`: **bulgu yok**.
- Değişen Dart alanlarında format: **8 dosya, fark yok**.
- `dart run tool/check_test_presence.dart`: **eksik test yok**.
- iOS plist ve Android manifest sözdizimi: `plutil -lint` / `xmllint --noout` **yeşil**.
- `git diff --check`: **yeşil**.
- `dart run tool/check_boundaries.dart`: **11 mevcut ihlal**; tamamı değiştirilmeyen
  ortak UI, tables ve timeline dosyalarında. Bu dilimin dosyalarında ihlal yok.

Testler izin reddinde token/kayıt isteği olmamasını, APNs tokenı hazır değilken FCM
isteğinin yapılmamasını, Firebase olay eşlemelerini ve kapalı varsayılanı doğrular.
Oturum/sunucu değişimi, çıkış sırasında geç dönen kayıt, token yenilenme yarışı,
başarısız silmenin sonraki açık işlemde tekrar denenmesi ve dispose sırasında geç
yanıt temizliği sınanır. Firebase ve HTTP istekleri sahte portlarla ayrılır.

## Bağımsız inceleme

GPT-6.1 ajanı `push_review`, salt okunur olarak kodu, testleri, yapılandırmayı ve
yürütme belgesini inceledi. Bu ilk dilimin kapsamında düzeltme gerektiren bulgu
bildirmedi. Bu inceleme uzak CI veya gerçek cihaz teslim kanıtı yerine geçmez.

## Kabul sınırı

Backend native kayıt sözleşmesi ve mesaj bildirim olayı yoktur; gerçek HTTP repository,
oturum kancaları, UI tercihi, dokunuşun güvenli çözülmesi ve Firebase başlatma henüz
bağlanmadı. FCM/APNs gerçek teslimi sınanmadı; uygulama kapalıyken bildirim bugün
çalışıyor kabul edilmez. Dağıtım ayarları veya özel anahtar eklenmedi.

Tam verify/uzak CI bu dilimde çalıştırılmadı (mobil CI için mevcut KR-27 kısıtı sürer).
Önceki mesajlaşma kalite kaydında bulunan genel kapı borçları bu işin kapsamı dışında
kalır. Sonraki adımlar [native push yürütme planında](../yurutme/native-push-altyapisi.md).
