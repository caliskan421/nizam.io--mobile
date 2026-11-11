# Mesajlaşma — güncel main tabanında UI bağlantıları

## Taban ve kapsam

2026-11-11 kullanıcı isteği. Dal `ozellik/mesajlasma-ui`; açılış tabanı yerel `main` (`635dc93`), güncel `origin/main` (`47d52fb`) ve son kullanıcı ekran düzenlemelerini birlikte içerir. F64 altyapısı bu tabana `105786e` olarak taşındı. Tek çatışma açık yüz export'uydu; main'in kaldırdığı eski şirket yöneticisi indeksi geri getirilmedi. API pini main'deki `v0.15.0-api` olarak korundu.

Başlangıç doğrulaması: güncel main + taşınmış altyapıda messages testleri **143/143 geçti**. Bu iş backend veya yönetim deposuna yazmaz. Push/uzak CI KR-27 gereği tetiklenmez; sonuç yerel commit ve kanıtla teslim edilir.

## Plan ve roller

Üç uygulayıcı doğrudan **GPT-6.1 SOL** olarak açıldı; dosya sahipliğiyle aynı çalışma ağacında ilerler:

1. Composer/paylaşım: görev-koordinatörlük-arşiv referansları, taslak kartları, yapılandırılmış bahsetme, anket tarihi, dosya açıklaması ve yanıt bağlamı, sabit liste kesilme uyarısı.
2. Gruplar: programdaki bütün bağlı koordinatörlükler, rol kapsamı, kaynaklı grup oluşturma ve kaynak değiştirme/kapatma; kurucu ile yönetici yetkilerinin ayrımı.
3. Listeler/rozetler: sunucu araması ve durumları, paylaşılan tür filtreleri, program başına okunmamış/bahsetme rozetleri.

Koordinatör ortak public exports, oturum sahibiyle süzülen rozet görünümü, yazma/okundu sonrası özet yenileme, tek ortak üretim, birleştirilmiş test ve incelemeyi yürütür.

## Tasarım ve davranış kabulü

- Yeni form ve seçimler `NzBottomSheet` kullanır: telefonda alt sayfa, tablette merkezi modal. Alt eylem satırı ve mevcut form alanları kullanılır; ikinci modal sistemi kurulmaz.
- Tema, yazı, boşluk ve ikonlar mevcut kit/token/ARB kaynaklarından gelir. Yeni UI metinleri ayrı messages_compose/groups/lists JSON kaynaklarında tutulur; generated dosyalar elle değiştirilmez.
- Sayfa yerel kısıttan ölçülür; telefon/tablet aynı controller ve repository'yi kullanır. Genişlik/yön provider anahtarına eklenmez, yeniden boyutlanma taslağı kaybettirmez.
- Sunucu aramasının geçmiş metin eşleşmesi son mesaj önizlemesine göre yeniden elenmez; yalnız tür/okunmamış filtreleri uygulanır. Yazarken eski sorgu sonucu gösterilmez.
- Kullanıcıdan ham kayıt kimliği istenmez. Kaynak ve referans seçenekleri gerçek yetkili API verisinden gelir; cihaz dosya eki ile arşiv referansı ayrı eylemlerdir.
- Kurucu olması grup kaynağı değiştirmeye yetmez; bu eylem grup yöneticisine açıktır. Kaynağı kapatmanın mevcut kaynak üyelerini elle üyeliğe dönüştürdüğü açıklanır.
- Gönderim, kaynak değişimi ve seçim iptali, hata/boş/yükleniyor, geçmiş sorgusu, sahiplik ve telefon/tablet taşmaları hedefli davranış testleriyle doğrulanır. İkon/renk/piksel sabitleri için yeni test yazılmaz.
- Program rozetleri hesap değişince eski veriyi göstermez; aynı hesapta yenileme hatası geçerli önceki sayıyı korur. Rozet hatası program seçimini engellemez.

## Bildirim sorusunun mevcut kod yanıtı

Uygulama kapalıyken gelen **native mobil mesaj push bildirimi yoktur**. Paket bağımlılığı tek başına çalışan bildirim mekanizması değildir:

- ADR-0002, Firebase projesi/yapılandırması belirlenene kadar `Firebase.initializeApp` çağrılmamasını kararlaştırır. Mobil kaynakta Firebase Messaging başlatma, FCM token kaydı, arka plan işleyicisi ve bildirimden sohbet açma zinciri bulunmaz.
- Mevcut mobil notifications feature uygulama içi çan/liste/okundu işlemlerini ve ön plana dönüşte yenilemeyi yapar; arka planda çalışan bir push döngüsü değildir.
- Backend notifications dış kanalı web push'tur; native FCM/APNs token teslimi değildir. Messaging MESSAGING-K24, sohbet mesajlarının bildirim olayı üretmediğini açıkça söyler.
- Mesajlaşma SSE akışı yalnız ön planda ve mesaj ekranı dinlenirken açıktır. Uygulama kapalıyken SSE mesajı bildirim olarak gösteremez.

Native push ayrı uçtan uca iş gerektirir: backend mesaj bildirimi ve mobil cihaz/token yaşam döngüsü, FCM/APNs sağlayıcı/yapılandırma, izinler, arka plan teslimi ve bildirimden doğru kurulum/hesap/program/sohbete güvenli geçiş. Bu işte kullanıcının sorusu yanıtlanır; Firebase projesi veya bildirim politikası kendiliğinden değiştirilmez.

## Son doğrulama

Üç GPT-6.1 uygulayıcısı tamamladı; birbirlerinin dosyalarını salt okunur çapraz incelediler. İncelemede bulunan eski aday/kaynak verisinin yeniden çizilmesi, arşiv await/cursor sahipliği, modal kaynaklarının erken dispose edilmesi ve sabit footer eksikleri kapatıldı. Referansla boş metin gönderimi için doğal kayıt başlıkları kullanıldı; on kayıt sınırı eklendi.

- Mesajlaşma + scope + tablet resize/split/gezinti birleşik koşumu **296/296** geçti.
- Son tip/lint düzeltmeleri sonrası grup testleri **5/5**, ek telefon/tablet 2x kaynak formu testleri **2/2** geçti. Arşiv public export import uyarlamasının mevcut controller testleri **5/5** geçti.
- Son ağaç gerçek backend HTTP+SSE tanığı **1/1** geçti; yeni program departman okuma portu da bu senaryoda doğrulandı.
- Değişen messages/scope/archive alanları ve yeni testlerin hedefli analizi **No issues found**; hedefli format ve diff kontrolü temiz. Üretilmiş API, API pini ve bağımlılık farkı yok.
- Genel `make verify` tabandaki tables/presentation/table_page.dart formatında duruyor. Genel analyzer mesajlaşma dışındaki dosyalarda 15 info bulgusu taşıyor; sınır kontrolünde core UI/tables/timeline kaynaklı 11 ihlal var. Test-presence yeşil. Dosya boyutu testi değişmeyen üç tasks/timeline dosyasının eski tavanlarını aşmasıyla kırmızı; yeni dosyalar ve ChatPage 600 altında.
- Genel kapılar gevşetilmedi. Bu nedenle sonuç **yerel UI bağlantıları doğrulandı; genel depo kapısı/CI bekliyor** düzeyindedir. Uzak push/CI/main birleşmesi yapılmadı.

Detay: [mesajlaşma UI kalite kaydı](../reviews/mesajlasma-ui-kalite.md). Cihaz üstü ve Linux golden doğrulaması bu widget/API kanıtıyla aynı sayılmaz; fiziksel cihaz test edilmedi.
