# Mobil mesajlaşma — mekanizma ve UI bağlantı devri

2026-11-11. İlk F64 çalışması `v0.12.0-api` imkanlarını domain, repository ve controller katmanlarına taşıdı. Kullanıcının sonraki isteğiyle güncel main ve onun `v0.15.0-api` pini üzerinden UI bağlantıları eklendi; bu ikinci adım API pinini veya backend'i değiştirmez. Güncel yürütme ve kalite durumu: [mesajlaşma UI](yurutme/mesajlasma-ui.md).

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

## Çağrı yüzleri ve UI bağlantıları

| Özellik | Altyapı | UI bağlantısı |
|---|---|---|
| Görev / koordinatörlük / arşiv dosyası paylaşımı | `ChatRefDraft`; `ChatRoomController.send(..., refs: ...)`; DTO `refs` aktarımı | Ekle menüsündeki gerçek kayıt seçicileri, kaldırılabilir taslak kartları ve gelen kartlar bağlı. Referansla gönderim boş metinde kayıt başlıklarını kullanır; en çok 10 referans seçilir. |
| Kaynaklı grup kurma | `GroupDraft.source`, `sourceDepartmentId`; kaynağı da içeren işlem imzası | Yeni grup formunda elle/program/koordinatörlük seçimi; rol ve programa bağlı gerçek seçenekler. |
| Kaynak değiştirme / kapatma | `ChatMembersController.updateSource`; `Chat.source`, `sourceDepartmentId` | Grup bilgisinde kaynak etiketi, yöneticiye değiştir/kapat eylemi ve mevcut üyeleri koruma açıklamalı onay bağlı. |
| Koordinatörlük bahsetmesi | `ChatMention.department`; gönderim ve tekrar destekli | Composer önerilerinde seçili programa bağlı koordinatörlükler var. Düz `@metin` tek başına bahsetme değildir; öneriden seçilir. |
| Anket kapanış tarihi | `PollDraft.closesAt`; UTC DTO aktarımı, gelen kapanışın okunması | Ortak takvim/saat seçimi ve gelecekte olma denetimi bağlı; cihazın yerel saatiyle seçim yapıldığı açıklanır. |
| Açıklamalı / yanıtlı ek | `sendAttachment(file, caption: ..., replyTo: ...)`; tekrar aynı içerikle | Dosya seçimi sonrası önizleme/açıklama/yanıt alanı bağlı; iptal yazma isteği göndermez. |
| Bütün sohbet geçmişinde arama | `chatInboxSearchProvider(query)`; repository her sayfada aynı `q` gönderir | Ana arama 300ms debounce ile sunucuya bağlı; yükleniyor/hata/boş/kesilmiş durumları var. Tarihçe eşleşmesi tekrar son mesaj metniyle elenmez. |
| Programlar arası rozet | `chatUnreadOverviewProvider`, `chatUnreadBadgesProvider`; `ChatProgramUnread` | Program seçicisinde ve mevcut kapsam kartında sayı/bahsetme var; oturum sahipliği süzülür, açılış/okundu/yazma/ön plana dönüş yenilemesi bağlı. Arka plan aboneliği yok. |
| Paylaşılan tür filtresi | `ChatSharedController.setKind`; `kind`, `busy`, `nextCursor` | Tümü/görev/koordinatörlük/dosya filtreleri bağlı; yeni türde imleç sıfırlanır ve uçuşta tekrar kapalıdır. |
| Sabit liste tamlığı | `pinnedPage`; `ChatRoom.pinsTruncated` | Kesilme uyarısı sohbet ekranında gösterilir; sunucuda olmayan sonraki sayfa varmış gibi davranılmaz. |

UI bağlantıları telefon ve tablet için aynı mevcut kit/controller üzerinden yürür. Temel mesaj, yanıt, düzenleme/silme, tepki, sabitleme, anket, ek indirme, üye yönetimi, mesajdan görev ve sohbet içi aramanın mevcut ekran bağlantıları korunur. Kapalı uygulamaya native push bu bağlantıların parçası değildir; ayrıntı [UI yürütme notundadır](yurutme/mesajlasma-ui.md).

## Kalite kanıtı ve sınırları

Son birleşik kapı sonuçları ve bağımsız inceleme, [F64 inceleme kaydında](reviews/F64-mesajlasma-kalite.md) tutulur. Gerçek backend tanığı `test_integration/messaging_mechanisms_test.dart` içindedir; kendi benzersiz program ve koordinatörlüğünü oluşturur ve temizler. Paylaşılan sunucuyu kurmaz/durdurmaz, mevcut programları değiştirmez. SSE için ayrı oturum doğrudan sunucuya bağlanır; test proxy'sinin SSE tamponlaması kanıtı maskelemez.

Test ortamındaki sentetik yönetici hesabı env ile seçilir; parola belgede veya kanıtta tekrarlanmaz. Uzak CI, Android/iOS cihaz testi ve Linux golden kontrolü bu yerel kanıtla eş tutulmaz. İndirme için gerçek platform dosya seçici/izin denetimi ve tüm yeni kontrollerin cihaz üstü doğrulaması UI adımında yapılacaktır.
