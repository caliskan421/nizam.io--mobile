# Mobil mesajlaşma — mekanizma ve UI bağlantı devri

2026-11-11. Bu çalışma ekranları değiştirmez; mevcut `v0.12.0-api` sözleşmesindeki imkanları domain, repository ve controller katmanlarına taşır. Backend mesajlaşma kaynağı bu etiket ile incelenen backend HEAD arasında değişmemiştir; API pini yükseltilmemiştir.

## Plan ve uygulama sınırı

1. Domain/API uygulayıcısı gönderim alanlarını ve okuma portlarını tamamlar; gerçek HTTP gövdesi/sorgusu test edilir.
2. Application uygulayıcısı bu alanları gönderim ve tekrar zincirine taşır; yarışları ve hesap/program sahipliğini korur.
3. Bağımsız tanık sözleşmeyi karşılaştırır, gerçek backend senaryosu ve SSE tanığını hazırlar; son ağacı yeniden inceler.
4. Koordinatör ortak üretimi ve birleşik yerel kalite kapılarını çalıştırır. UI, backend ve uzak birleşme bu adımın kapsamı dışındadır. KR-27 gereği mobil CI tetiklenmez.

## Kullanıcıya sunulan mekanizma nasıl çalışır?

- **Sohbet ve yetki:** Her sohbet bir programa bağlıdır. Seçili program HTTP kapsam başlığına eklenir; gerçek üyelik ve işlem yetkisini sunucu denetler. Birebir ve grup ayrı kurallara tabidir. Grup kurucu/yönetici/üye rolüyle döner; yetkisiz işlemler yalnız düğme gizleyerek engellenmiş sayılmaz.
- **Kaynaklı grup:** Elle üyeye ek olarak program veya koordinatörlük kaynağı seçilebilir. Kaynak üyeliği sunucuda güncel ekipten türetilir. Kaynak üyeleri elle çıkarılamaz/ayrılamaz. Kaynağı kapatmak o anki üyeleri elle üyeliğe dönüştürür; bu nedenle kaynak kapatma, grubu boşaltma değildir.
- **Gönderim ve tekrar:** Mesaj ilk gönderimde tek `client_message_id` alır. Metin, yanıt, bahsetmeler, referanslar, anket ve ek açıklaması tekrar boyunca aynı gönderim anlık görüntüsünden gelir. Belirsiz ağ sonucunda aynı kimlikle kullanıcı tekrarı yapılır; sunucu aynı gönderimi tek mesaj olarak döndürür. Aynı kimlik farklı içerikle kullanılırsa 409 reddi korunur. Grup ve mesajdan görev oluşturma ayrıca işlem anahtarı kullanır.
- **Düzenleme:** Mesaj taslağı açılırken alınan `edit_revision`, yazmada `expected_revision` olarak gönderilir. Başka cihaz önce düzenlediyse 409 çakışma alınır; sunucunun son mesajı yeniden okunur. Son yazan sessizce kazanmaz.
- **Canlı güncelleme:** SSE içerik yerine kimlik sinyalleri taşır. İstemci güncel yetkiyle HTTP üzerinden içeriği yeniden okur. Olaylar birleştirilir; bağlantı yeniden açılınca sohbet listesi ve görünen mesaj penceresi uzlaştırılır. Yeni mesajlar `after`, eski sayfalar `before`, belirli mesajlar `around`/`seq` ile okunur. Akış mesaj ekranı ve ön plan yaşam döngüsüne bağlıdır; kalıcı çevrimdışı mesaj kuyruğu veya arka plan push hizmeti değildir.
- **Okundu ve varlık:** Okundu imleci geriye gitmez. Birebirde karşı tarafın okuduğu sıra, yazıyor bilgisi, çevrimiçi/son görülme alanları kullanılır. Programlar arası özet program adı, okunmamış sohbet sayısı ve bahsetme bayrağını ayrı taşır.
- **Paylaşım:** Mesajla mevcut görev, koordinatörlük veya arşiv dosyası referansı gönderilir. Sunucu gönderenin güncel erişimini doğrular. Alan kişi kartı sohbet referansı üzerinden okur; bu işlem hedef görevin genel düzenleme yetkisini vermez. Dosya referansı ve cihaza ait yeni ek farklı kaynaklardır.
- **Anket ve dosya:** Anket tek/çoklu seçim, isimli sonuç, elle kapanış ve isteğe bağlı son tarih taşır. Son tarih UTC gönderilir; kapalı ankete oy kararı sunucudadır. Dosya multipart gönderilir; açıklama ve yanıt bağlamı korunur. İndirme byte akışı kullanır.
- **Yarışlar ve sahiplik:** Aramada istek nesli ve sayfalama uçuşu izlenir; eski cevap yeni sorguyu ezmez. Paylaşılanlarda eşzamanlı sayfa çağrısı birleştirilir, tekrar referanslar ayıklanır ve tür değişiminde eski imleç taşınmaz. Oturum/program değişince eski zincirin yeni durumu değiştirmesi ve gecikmiş eylemin yeni kapsamla devam etmesi engellenir.

## UI'a hazır çağrı yüzleri ve kalan bağlantılar

| Özellik | Hazır altyapı | Bir sonraki UI adımı |
|---|---|---|
| Görev / koordinatörlük / arşiv dosyası paylaşımı | `ChatRefDraft`; `ChatRoomController.send(..., refs: ...)`; DTO `refs` aktarımı | Seçici ve taslak referans kartları; gönderimden önce kaldırma. Gelen kartlar zaten gösteriliyor. |
| Kaynaklı grup kurma | `GroupDraft.source`, `sourceDepartmentId`; kaynağı da içeren işlem imzası | Yeni grup formunda elle/program/koordinatörlük seçimi; rol ve program bağına uygun seçenekler. |
| Kaynak değiştirme / kapatma | `ChatMembersController.updateSource`; `Chat.source`, `sourceDepartmentId` | Grup bilgisinde kaynak etiketi ve değiştirme; kapatmanın üyeleri koruduğunu açıklama. |
| Koordinatörlük bahsetmesi | `ChatMention.department`; gönderim ve tekrar destekli | Composer önerilerine seçili programa bağlı koordinatörlükleri ekleme. Düz `@metin` tek başına bahsetme değildir. |
| Anket kapanış tarihi | `PollDraft.closesAt`; UTC DTO aktarımı, gelen kapanışın okunması | Tarih/saat seçimi, kullanıcıya gösterilecek saat dilimi ve kapandı durumu. |
| Açıklamalı / yanıtlı ek | `sendAttachment(file, caption: ..., replyTo: ...)`; tekrar aynı içerikle | Seçim sonrası önizleme, açıklama alanı; mevcut yanıt bağlamını gönderime taşıma. |
| Bütün sohbet geçmişinde arama | `chatInboxSearchProvider(query)`; repository her sayfada aynı `q` gönderir | Ana liste aramasını bu sağlayıcıya bağlama; yükleniyor/hata/boş sonuç ve `truncated` uyarısı. Mevcut yerel arama korunmuştur. |
| Programlar arası rozet | `chatUnreadOverviewProvider`; `ChatProgramUnread` | Program seçicisinde her programın sayısı ve bahsetmesi; yazma/okundu/ön plana dönüş sonrası sağlayıcıyı yenileme. Otomatik arka plan aboneliği yok. |
| Paylaşılan tür filtresi | `ChatSharedController.setKind`; `kind`, `busy`, `nextCursor` | Tümü/görev/koordinatörlük/dosya sekmeleri; yükleme sırasında tekrar düğmesi durumu. |
| Sabit liste tamlığı | `pinnedPage`; `ChatRoom.pinsTruncated` | Sunucu listesinin kesildiği durumda uyarı. Sunucuda olmayan sonraki sayfa varmış gibi davranılmaz. |

Yeni çağrı yüzleri mevcut ekranlara bağlanmadığı için yukarıdaki eksik seçim kontrolleri bu teslimle görünür hale gelmez. Temel mesaj, yanıt, düzenleme/silme, tepki, sabitleme, anket, ek indirme, üye yönetimi, mesajdan görev ve sohbet içi aramanın mevcut ekran bağlantıları korunur.

## Kalite kanıtı ve sınırları

Son birleşik kapı sonuçları ve bağımsız inceleme, [F64 inceleme kaydında](reviews/F64-mesajlasma-kalite.md) tutulur. Gerçek backend tanığı `test_integration/messaging_mechanisms_test.dart` içindedir; kendi benzersiz program ve koordinatörlüğünü oluşturur ve temizler. Paylaşılan sunucuyu kurmaz/durdurmaz, mevcut programları değiştirmez. SSE için ayrı oturum doğrudan sunucuya bağlanır; test proxy'sinin SSE tamponlaması kanıtı maskelemez.

Test ortamındaki sentetik yönetici hesabı env ile seçilir; parola belgede veya kanıtta tekrarlanmaz. Uzak CI, Android/iOS cihaz testi ve Linux golden kontrolü bu yerel kanıtla eş tutulmaz. İndirme için gerçek platform dosya seçici/izin denetimi ve tüm yeni kontrollerin cihaz üstü doğrulaması UI adımında yapılacaktır.
