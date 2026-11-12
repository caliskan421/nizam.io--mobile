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
| Üretim | `make gen` ve kod commit'i `c9e2163` üzerinde temiz ağaçta `make gen-check`: geçti (çıkış 0, yeniden üretim farkı yok) |
| Fark temizliği | `git diff --check`: geçti |
| Değişen dosya boyutları | 129 el yazımı Dart dosyasında yeni tavan ihlali yok; dört genel boyut borcu `44269dd` ile birebir aynı |
| Gerçek iOS SDK | Ayrı `nizamio-crashlytics-20261112-reporting` simülatöründe opt-in smoke geçti: automatic=false, güvenli recordError await kabulü ve native PackageInfo sürüm/build |

Genel `file_size_test` kırmızı: `detail_actions.dart` 750/742, `activity_page.dart` 585 ile artık
legacy listesinden çıkarılmalı, `timeline_chart.dart` 668/666, `gantt_chart.dart` 1040/868.
Bu dört dosyanın içerikleri `git show HEAD:<yol>` ile çalışma ağacında **birebir aynı** doğrulandı;
başlangıçtan gelen sorunlardır, bu işte değiştirilmedi. Genel boundaries/analiz kapılarında da
ilk turda kapsam dışı mevcut ihlaller görüldü; tam verify yeşil sayılmadı. Testler zayıflatılmadı.

Gerçek cihaz/simülatör crash üretme, konsolda nonfatal/native crash görünmesi, sürüm/build/OS/cihaz
karşılaştırması, release/arşiv ve gerçek sembol yükleme henüz yapılmadı. Eski/harici kalıcı SDK
`true` override bulunmadığı üretim geçişinde doğrulanmalı. Prod raporlama kapalıdır; Analytics
açılmadı. Push, PR ve mobil CI tetiklenmedi. Ham çıktılar git'e alınmadı.

## Uygulama geneli kapsam tamamlama ve paralel son denetim

İkinci kapsam başlangıcı `44269dd`. Sonnet uyguladı; Codex kapsam, gizlilik ve
doğrulama için üç bağımsız alt ajanı aynı anda çalıştırdı. Bulgular Sonnet'e geri
verildi, düzeltmeler yeniden incelendi. Son kaynak incelemelerinde açık somut
bulgu kalmadı; native/bulut doğrulaması aşağıdaki sonuçlarla ayrıca değerlendirilir.

- Merkezi API sınırı, yerel dönüşümler, controller/sunum catch'leri, provider
  AsyncError gözlemcisi ve global kancalar ortak sınıflandırıcıya bağlandı.
- Raporda kaynak, doğrulanmış API operationId ve sabit Türkçe teknik açıklama var.
  Ham hata/sunucu mesajı, içerik, belirteç ve dinamik işlem adı gönderilmez.
- HTTP200 SSE teknik olayları ayrı sınıflandırılır; HTTP503 uydurulmaz. JSON,
  binary/PDF indirme ve akış hatalarında özgün tür/yığın korunur.
- Ekran/kapsam kapanışı raporlamayı kesmez; yalnız durum yazısı korunur. Batch
  işlemlerde ilk hatadan sonraki hatalar da sınıflandırılır.
- Beklenen domain sonuçları ve Riverpod bağımlılık sarmalayıcıları normalize edilir.
  Dedup aynı yayılım içindir; aynı hata ve stack nesnesi süre sonunda yeniden uygundur.
- Consent fiziksel yazıları ortak platform depo şeridinde sıralanır. Bayat grant'in
  rollback'i bariyer içindedir; başarısız geri alma ortak kapıyı kapalı tutar.
  Kullanıcının revoke isteği controller kuyruğundan önce ortak kapıyı kapatır;
  sahipliği zaten kaybolmuş controller yeni onayı değiştiremez.
- Bağlantı izleyicisinde yalnız MissingPluginException beklenendir. Gerçek depolama
  hataları 500ms timeout sonrasında gelse de özgün yığınla raporlanır.

| Son bağımsız kontrol | Sonuç |
|---|---|
| Telemetri, preferences, network, HTTP, app telemetry, AST, chat clock, assistant, notifications ve meeting-room regresyonları | `flutter test --concurrency=2 … --reporter expanded`: **328 geçti**, çıkış 0 |
| Değişen el yazımı Dart | `dart analyze`: **129 dosya**, çıkış 0; yalnız `api_operation_context_test.dart:33` biçem bilgisi |
| Uygulama genelindeki hata yolları | `check_error_paths`: **1508 dosya**, ihlal yok |
| Üretilmiş kapsam envanteri | `error_path_inventory --check`: güncel; **238 yol**: 164 rapor, 15 iletim, 1 denetim akışı, 58 gerekçeli istisna |
| Bağımsız adversarial AST harness | **24 olumsuz örnek reddedildi, 5 geçerli kullanım geçti**; son finally kaçışı da E2 |
| Fark temizliği | `git diff --check`: geçti |

Gerekçeli istisnalar ve her dosya/işlevin sahibi
[`hata-takibi-kapsam.md`](../yurutme/hata-takibi-kapsam.md) içinde üretilir.
Bu statik kapı genel CFG değildir: karmaşık akışta sade giriş raporu veya dar,
denetlenmiş istisna ister. Genel proje kapılarının önceki arayüz/boyut borçları
sürüyor; tam verify/CI kabulü verilmez. Mobil CI kota kuralıyla tetiklenmedi.

Süreç kaydı: ilk kapsam uygulayıcısı kabuk düzenlemesi/Monitor ve geçici worktree
protokolüne uymadığını bildirdi; geçici iş worktree'sini kaldırdı. Sonraki geniş
düzeltmede iki `sed -i` kullanımı (chat clock ve AST test beklenti sırası) araç
izinden doğrulandı. Koordinatör sonuçlarını inceledi; sonraki turlarda sed/Python/perl
kabuk araçları ayrıca engellendi. Reddedilen yazı denemeleri tekrar edilmedi.
Bu ihlaller gizlenmedi; kaynak/test sonuçları bağımsız doğrulandı.
