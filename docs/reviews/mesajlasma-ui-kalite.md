# Mesajlaşma UI — kalite ve devir

2026-11-11. Durum: **yerel doğrulama uygun; genel depo kapısı ve CI bekliyor**.

## Taban ve değişiklik sınırı

- Kullanıcı isteğiyle dal güncel yerel main'den açıldı: `ozellik/mesajlasma-ui`, taban `635dc93`; güncel origin/main `47d52fb` bu tabanın atasıdır. Son fetch'te bu ilişki değişmedi.
- F64 altyapı commit'i yeni tabanda `105786e`. Tek export çatışmasında main'in kaldırdığı eski yönetici indeksi geri alınmadı. Başlangıç messages koşumu 143/143 yeşildi.
- Üç uygulayıcı doğrudan GPT-6.1 SOL kullanıldı; compose, grup kaynakları ve listeler/rozetler ayrı dosya sahipliğiyle uygulandı. Sonrasında çapraz salt okunur inceleme yapıldı.
- Backend, API pini (`v0.15.0-api`), üretilmiş API ve bağımlılıklar değişmedi. API DTO'ları data katmanında kaldı; başka feature'ların iç katmanları yerine açık yüzler kullanıldı.
- Main'de yalnız generated ARB'ye eklenmiş dokuz mevcut metin ve değişmiş iki çeviri, doğru i18n kaynaklarına aktarıldı. Yeniden üretim eski ekran metinlerini artık düşürmez; generated dosyalar elle düzenlenmedi.

## Doğrulanan davranış

Gerçek görünür kayıt seçimi ve kaldırılabilir referans taslağı; referansla boş metnin doğal başlıklardan üretilmesi; en çok on kayıt; yapılandırılmış koordinatörlük bahsetmesi; yerel tarih/saatten UTC anket kapanışı; dosya açıklaması ve yanıt önizlemesi; seçim iptalinde yazma yapılmaması; sabit liste kesilme uyarısı.

Grup kaynağı elle/program/koordinatörlük seçilir. Kaynak oluşturma programdaki rolü, değiştirme sohbet yöneticiliğini izler; kuruculuk yeterli sayılmaz. Kaynak kapatmanın mevcut üyeleri koruduğu onayda açıklanır. Eski AsyncValue adayları ve kaynakları yükleme/hata sırasında gösterilmez; modal dönüşünde oturum/program tekrar denetlenir.

Ana arama 300ms debounce ile sunucu geçmiş sorgusuna bağlıdır; geçmiş eşleşmesi ad/son mesajla yeniden elenmez. Paylaşılan tür değişimi imleci sıfırlar; busy ve retry korunur. Program seçimi, okunmamış özeti beklemez; sayı ve bahsetme ayrı sunulur. Rozet yanıtı oturum sahibiyle süzülür; aynı hesabın yenileme hatasında geçerli önceki sayı kalır.

Telefon alt sayfa/tablet merkezi modal aynı NzBottomSheet yolundadır. Yeni grup ve kaynak düzenleme sabit actions footer kullanır. Modal controller/notifier kaynakları pop Future'ında erken değil widget dispose'unda bırakılır. Arşiv seçicisinin eski cursor ailesi ve await devamı yeni programla istek başlatamaz.

## Komut ve sonuçlar

| Kontrol | Sonuç |
|---|---|
| `flutter test test/features/messages test/features/scope test/app/router/shell_resize_test.dart test/app/router/shell_split_test.dart test/app/router/split_test.dart --exclude-tags golden --reporter=expanded` | **296/296** |
| Grup kaynak data/UI testleri, son tip/lint turu | **5/5** |
| Yeni grup/kaynak düzenleme, 390 ve 1024 genişlik, 2x yazı; iptal write0 ve save gövdesi, taşma/exception kontrolü | **2/2** |
| Arşiv controller mevcut testleri, public export uyarlaması sonrası | **5/5** |
| Gerçek backend messaging_mechanisms_test (kendi kaynaklarını oluşturup temizler; dev hesabı env üzerinden) | **1/1**, HTTP+SSE ve program departman portu |
| Değişen messages/scope/archive ve yeni testlerde `dart analyze` | **No issues found** |
| Hedefli format, `git diff --check`, API/pin/dependency diff | **temiz** |
| Genel test-presence | **eksik yok** |

İnceleme bulguları uygulayıcı ve başka GPT-6.1 okuyucu tarafından tekrar doğrulandı. Eski aday/kaynak verisi, arşiv scope/cursor devamı, boş gövde ve on kayıt sınırı, modal dispose ve footer davranışı testlerle kapandı. İlk genel analizde saptanan yeni data döngüsü tip çıkarımı ve lint'ler düzeltildi; son genel analizde değişen alanlardan bulgu yok.

## Açık genel kapılar ve limitler

- Tam verify sıra kilidinden çalıştırıldı; **değişmeyen table_page.dart formatı** yüzünden durdu.
- Genel analyzer: mesajlaşma dışındaki core UI/meetings/tables/tasks testlerinde **15 info**; hata veya warning yok.
- Genel sınır kapısı: değişmeyen core UI/tables/timeline dosyalarında **11 ihlal**. Mesajlaşma/scope bağlantılarında yeni ihlal yok.
- Dosya boyutu: değişmeyen detail_actions 750 > 742, timeline_chart 668 > 666, gantt_chart 1040 > 868; yeni el yazımı dosyalar 600 altında, ChatPage 594 satır. Tavanlar yükseltilmedi.
- Bu UI turunda bütün depo testleri tekrar çalıştırılmadı; kapsamlı ilgili paket/gezinti koşumu yukarıdadır. Genel kapı yeşil veya PR merge'e hazır iddiası yok.
- KR-27 gereği push/CI tetiklenmedi. macOS'ta Linux golden ve fiziksel cihaz/yerel dosya seçici izinleri test edilmedi.
- Native kapalı uygulama mesaj bildirimi yok; Firebase paketleri başlatılmamış, FCM/APNs token/arka plan zinciri bağlı değil ve backend messaging mesaj bildirimi olayı üretmiyor. Uygulama içi çan ve ön plan SSE ayrı mekanizmalardır.

UI kapsamı ve bildirim için gereken ayrı uçtan uca iş: [yürütme notu](../yurutme/mesajlasma-ui.md).
