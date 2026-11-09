# Ortak bayat veri tazeleme — yerel denetim

Tarih: 2026-11-09. Taban: `c7baceb`; dal: `duzeltme/ortak-bayat-veri-tazeleme`.
Uygulayıcı: GPT-6.1 SOL medium alt ajan. Denetçi: ana Codex ajanı; kod yazmadı.
Kabul: telefon/tablet aynı görünürlük mekanizması; ilk etkin görünüş ve dönüşte tek çağrı.
`lib/app/router/shell.dart`: tablete özel tazeleme zamanlayıcısı kaldırıldı.
`lib/core/ui/motion/page_content_entrance.dart`: hareket bitişinden sonra kare sonu çağrı;
gizlenme/dispose nesli geçersiz kılar, aynı karede yeniden başlayan üst hareket beklenir.
`lib/core/ui/page/nz_page.dart`: callback sözleşmesi güncellendi.
Tablet gerçek router/HTTP testi: Home/Görevler/Toplantılar taze=0, bayat=1 istek;
Takvim iki kaynağı için taze=0/0, bayat=1/1. Test saat eşiğiyle kontrol edilir.
İki keepAlive controller için A isteği sürerken B aynı programa geçer: geç A yanıtı
B'nin başarılı verisini veya hatasını değiştirmez (dört senaryo).
`v0.12.0-api` pini, üretilmiş API, controller korumaları ve ön plana dönüş yolu değişmedi.

| Komut | Sonuç |
|---|---|
| Değişiklik öncesi hedefli test paketi | 173 geçti, hata yok |
| `flutter test --no-pub --timeout 10m test/core test/app test/features/scope test/features/meetings test/features/calendar test/features/tasks/application test/tool --reporter expanded` | EXIT=0; 1591 geçti, 26 atlandı; 4:16 |
| `flutter analyze --no-pub --fatal-infos` | EXIT=0; sorun yok |
| Değişen Dart dosyalarında `dart format`; `git diff --check` | Temiz |

Hüküm: **GEÇER (yerel doğrulama)**. Açık kod bulgusu yok.
Sınır: PR/CI teslimi yapılmadı; push ve CI tetiklenmedi. Ham çıktılar `/tmp/nizamio-ortak-tazeleme-{test,analyze}.txt`.
