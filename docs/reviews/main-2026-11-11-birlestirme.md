# Mobil main birleştirmesi — 2026-11-11

Ürün sahibi tüm commit edilmemiş/pushlanmamış mobil içeriğin GitHub'a aktarılmasını
ve birleşmemiş işlerin main'e alınmasını istedi. Kapsam yalnız bu mobil depodur.

## Kaynak ve geçmiş denetimi

- GitHub'dan `fetch --prune` yapıldı; başlangıç `origin/main` = `47d52fbb`, yerel
  `main` = `635dc933`, güncel uygulama = `273981d`.
- Sekiz çalışma ağacı tarandı. Yalnız eski `wt-v015` taslağında 98 dosya commit
  edilmemişti. Tam içerik `bakim/v015-eski-calisma-kaydi` dalında `c47b2ec` ile korundu.
- Bu 98 dosyanın 91'i güncel uygulamayla bayt düzeyinde aynıydı. Kalan yedi dosya,
  güncel program PATCH üç hâl eşlemesi, Gantt truncation başlığı ve daha yeni i18n
  kaynak/üretimleriyle karşılanıyordu. Eski çıktılar güncel kodun üzerine uygulanmadı.
- Bağımsız GPT-6.1 dal denetimi: 34 eski `mob-ui/*` dalının birleşik yaması mevcut
  squash commitleriyle patch-id düzeyinde eşleşti. F12/F14 yamaları ve F64'ün
  `b06b24e` → `105786e` karşılığı zaten güncel uygulamada bulunuyordu.
- Uzak dalın gerisindeki dört yerel referans yalnız fast-forward ile güncellendi.
- Toplam 75 yerel/uzak referansın 40 farklı ucu, `df86322` geçmiş birleştirmesinde
  karşılanmış içerik olarak kayda alındı (`ours`). Böylece eski dalların geçmişi ve
  ham taslak kaydı korunurken daha yeni kod geri alınmadı.
- `df86322` uygulama ağacı, test edilen `273981d` ile birebir aynı:
  `5fd37970784829c133211bf2a7a9f8ff2c1da35c`. Bu kayıttan önce birleşmemiş yerel/uzak
  referans listesi boştu. Bu belge uygulama davranışını değiştirmez.

## Main'e taşınan davranış

Yerel main'deki v15 sonrası ekran düzenlemeleri, mesajlaşma altyapısı/UI bağlantıları,
native push port/kayıt yaşam döngüsü, Firebase dev/prod kimlik ayrımı ve gerçek dev
Core/Remote Config bağlantısı birlikte taşınır. Native mesaj push teslimi ve Firebase
güncelleme ekranı henüz tamamlanmış özellikler sayılmaz.

## Kabul kanıtı ve sınır

Uygulama kaynakları aynı kaldığından önceki kanıtlar geçerlidir:

- Mesajlaşma UI: 296 testlik birleşik kapsam ve telefon/tablet grup testleri;
  [UI kalite kaydı](mesajlasma-ui-kalite.md).
- Firebase dev bağlantısı: 71 ilgili + 2 native regresyon testi ve 1 gerçek iPhone
  Core/Remote Config testi; Android dev/prod ve iOS dev/prod derlemeleri;
  [bağlantı kalite kaydı](firebase-dev-baglanti-kalite.md).
- iPhone/iPad simülatörlerinde normal dev uygulaması yeniden açıldı.

Yeni davranış değişikliği yapılmadığı için aynı test/derlemeler tekrarlanmadı.
Mobil CI mevcut KR-27 gereği tetiklenmez; PR başı ve merge commit'i `[skip ci]`
taşır. Genel depo format/sınır/boyut borçları kapanmış veya CI yeşil sayılmaz.
