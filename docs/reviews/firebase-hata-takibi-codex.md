# Firebase hata takibi — Codex denetimi

2026-11-12 · Dal: `ozellik/firebase-hata-takibi-ve-surum-yonetimi`.
Uygulayıcı: Sonnet 5.5; koordinatör ve denetim: Codex. Başlangıç: `773e456`.

**Hüküm: yerel uygulama uygun; yayın/CI kabulü verilmedi.** Kod üç uygulama/inceleme turunda
okundu. Otomatik toplamanın kalıcı açılması, hatanın dönüşüm sırasında kaybı, çift rapor,
gönderim/geri alma yarışları, başarısız silme sonrası izin, kişisel yığın yolları ve iOS AOT
çerçevelerinin kaybı giderildi. Native veri Dart ayıklamasından geçmez; gerçek konsol provası açık.

| Kontrol | Codex'in bağımsız sonucu |
|---|---|
| Telemetri, platform kanalı, izin, HTTP, giriş, görev, sohbet, bileşim/açılış, tercih, native yapı/betik ve profil akışı regresyonları | `flutter test` / `--exclude-tags golden --timeout 120s --reporter failures-only`: **532 geçti**, çıkış 0 |
| Değişen Dart dosyaları | `dart analyze` **48 dosya**, sorun yok |
| Değişen el yazımı Dart dosyaları | **37 dosya**; 600 satır/mevcut legacy tavanında, ihlal yok |
| Native yapılandırma | Gradle help, `plutil -lint`, `sh -n`: geçti |
| Android | `flutter build apk --debug --flavor dev -t lib/main_dev.dart --no-pub`: geçti |
| Android, Firebase yapılandırması olmayan prod | `flutter build apk --debug --flavor prod -t lib/main_prod.dart --no-pub`: geçti |
| iOS | `flutter build ios --simulator --debug --flavor dev -t lib/main_dev.dart --no-pub`: geçti |
| Üretim | Son kaynaklardan `make gen` geçti; commit sonrası `make gen-check` kapanış kontrolüdür |
| Fark temizliği | `git diff --check`: geçti |

Genel `file_size_test` kırmızı: `detail_actions.dart` 750/742, `activity_page.dart` 585 ile artık
legacy listesinden çıkarılmalı, `timeline_chart.dart` 668/666, `gantt_chart.dart` 1040/868.
Bu dört dosyanın içerikleri `git show HEAD:<yol>` ile çalışma ağacında **birebir aynı** doğrulandı;
başlangıçtan gelen sorunlardır, bu işte değiştirilmedi. Genel boundaries/analiz kapılarında da
ilk turda kapsam dışı mevcut ihlaller görüldü; tam verify yeşil sayılmadı. Testler zayıflatılmadı.

Gerçek cihaz/simülatör crash üretme, konsolda nonfatal/native crash görünmesi, sürüm/build/OS/cihaz
karşılaştırması, release/arşiv ve gerçek sembol yükleme henüz yapılmadı. Eski/harici kalıcı SDK
`true` override bulunmadığı üretim geçişinde doğrulanmalı. Prod raporlama kapalıdır; Analytics
açılmadı. Push, PR ve mobil CI tetiklenmedi. Ham çıktılar git'e alınmadı.
