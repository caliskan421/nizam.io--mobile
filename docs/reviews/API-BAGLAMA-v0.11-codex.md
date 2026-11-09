# API bağlama (pin v0.11.0-api) — Codex hükümleri

Dal `ozellik/api-baglama` (main `32628d5` tabanı). Model `gpt-6-astra`, `-s read-only`, `model_reasoning_effort=medium`; her turda ≥ 29 gerçek dosya okuması (KAPI m.13). Kapsam: bildirim çanı, arşiv, takvim, koordinatörlük profili, sohbet çekirdeği ve ekleri, yüklemede Fotoğraflar/Dosyalar seçimi, yerel geliştirme tohumu. Turlar arasındaki düzeltmeler ayrı `duzeltme/codex-*` dallarında yapılıp bu dala birleştirildi.

| Tur | Hüküm | Okunan dosya |
|---|---|---|
| 1 | GEÇMEZ | 78 |
| 2 | GEÇMEZ | 45 |
| 3 | GEÇMEZ | 35 |
| 4 | GEÇMEZ | 43 |
| 5 | GEÇMEZ | 57 |
| 6 | GEÇMEZ | 39 |
| 7 | GEÇER | 33 |

---

## Tur 1

### Hüküm: GEÇMEZ

`32628d5..cdae617` farkının salt okunur incelemesinde sessiz veri ezme, SSE uzlaştırma ve işlem tekrarı kusurları bulundu; dosya yazılmadı, test/CI/ağ çalıştırılmadı.

### Bulgular

| # | önem (yüksek/orta/düşük) | soru | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|
| 1 | yüksek | 3 | `lib/features/messages/presentation/chat_page.dart:267`; `lib/features/messages/application/chat_room_controller.dart:543` | **Düzenleme tabanı korunmuyor.** Taslak açılırken yalnız mesaj kimliği ve metin saklanıyor; `expected_revision` gönderim anındaki canlı mesajdan alınıyor. Başka cihazın düzenlemesi SSE ile geldiyse eski taslak yeni sürümle gönderilip karşı değişikliği sessizce ezebilir. | Taslak açılışındaki metin ve sürümü birlikte saklayın; gönderimde bu sürümü kullanın. Taslak açıkken SSE güncellemesi senaryosunu test edin. |
| 2 | orta | 8 | `lib/features/messages/application/chat_actions_controller.dart:193`; `lib/features/messages/application/chat_actions_controller.dart:200` | **Tepki/oy geri alma yarışıyor.** Kuyruk kaydı HTTP tamamlanmadan siliniyor. İstek sürerken sonraki dokunuş ayrı istek açıyor ve iyimser değeri “doğrulanmış” kabul ediyor. İlk isteğin geç gelen hatası sonraki başarılı seçimi geri alabilir; isteklerin sunucuya ulaşma sırası da tersine dönebilir. | Mesaj başına uçuşta tek yazma tutun; doğrulanmış ve istenen durumu ayrı saklayın. Gecikmeli başarı/hata ve ters tamamlanma testleri ekleyin. |
| 3 | yüksek | 2 | `lib/features/messages/application/chat_room_controller.dart:85`; `lib/features/messages/application/chat_room_controller.dart:130` | **İlk yükleme sırasında SSE olayları kayboluyor.** `state.value == null` iken açılış ve değişiklik sinyalleri atılıyor. Geçmiş yanıtı hazırlanmış fakat diğer başlangıç okumaları bitmemişken gelen oluşturma/silme olayı uygulanmıyor; yükleme sonunda telafi uzlaştırması da yok. | Yükleme sırasındaki sinyalleri kirli durum olarak biriktirin ve başlangıç tamamlanınca uzlaştırın. Geçmiş okumasıyla yarışan silme/oluşturma senaryosunu test edin. |
| 4 | orta | 2 | `lib/features/messages/application/chat_room_controller.dart:209`; `lib/features/messages/application/chat_room_controller.dart:253` | **Uzlaştırma sessizce yarıda kesiliyor.** `20 × 50` sınırından sonra dolu sayfa olsa da devam edilmiyor. Uzun çevrimdışı sürede yeni mesajlar, 1.000 mesajdan geniş yerel pencerede ise eski düzenleme/silmeler eksik kalabiliyor; eksiklik gösterilmiyor. | Bütçeli devam işi/imleciyle uzlaştırmayı tamamlayın veya pencereyi açıkça yeniden kurun; sınır aşımını başarı saymayın. |
| 5 | orta | 2 | `lib/features/messages/application/chat_sync_controller.dart:74`; `lib/features/messages/application/chat_sync_controller.dart:135` | **429 bekleme süresi yaşam döngüsüyle aşılabiliyor.** `Retry-After` yalnız mevcut döngünün zamanlayıcısında tutuluyor. Arka plana gidip dönmek zamanlayıcıyı iptal edip `_start()` üzerinden hemen yeni akış açıyor. | Hesap için mutlak “en erken yeniden açılış” zamanını saklayın; ön plana dönüş ve ekranın yeniden açılışı da buna uysun. |
| 6 | orta | 4 | `lib/features/tasks/data/download_sink.dart:46`; `lib/features/tasks/data/download_sink.dart:57`; `lib/features/messages/application/chat_actions_controller.dart:159` | **Aynı adlı indirme mevcut dosyayı sessizce değiştiriyor.** Yolun son parçasına indirgeme traversal’ı engelliyor; fakat bütün kaynaklar ortak `indirilenler/<ad>` hedefine atomik `rename` yapıyor. Başka sohbetin, görevin veya sunucunun aynı adlı dosyası ezilebilir. Bu mevcut sink davranışı yeni indirme yollarına da taşınmış. | Çakışmasız dosya adı veya kaynak kimliğine göre ayrı konum kullanın; üzerine yazma bilinçli kullanıcı seçimi olsun. |
| 7 | orta | 3, 8 | `lib/features/archive/application/archive_actions_controller.dart:123`; `lib/features/archive/application/archive_actions_controller.dart:134` | **Arşiv yüklemesi belirsiz sonuçta anahtarını kaybediyor.** Her seçim/gönderimde yeni anahtar üretiliyor. Başarılı yüklemenin yanıtı kaybolursa kullanıcının aynı dosyayı tekrar seçmesi ikinci kayıt oluşturabilir; `conflict_retry` için aynı anahtarlı tek tekrar da uygulanmıyor. Etiketli sözleşmenin §8 kuralı görev dosyası yüklemelerini de kapsıyor. | Yükleme niyetini dosya, görev, kapsam, etiket ve anahtarıyla saklayın; belirsiz sonuçta aynı niyeti sürdürün, `conflict_retry` için tek tekrar uygulayın. |
| 8 | orta | 8 | `lib/features/calendar/application/calendar_index_controller.dart:18`; `lib/features/meetings/application/meetings_controller.dart:99`; `lib/features/calendar/domain/calendar.dart:146` | **Takvim kesilmiş veriyi tam veri gibi gösteriyor.** Kaynak hataları yayılıyor, ancak toplantı listesinin `truncated` bilgisi `.visible` alınırken düşüyor; görev kataloğunun `truncated` bilgisi de takvimde kullanılmıyor. Eksik kayıtlar nedeniyle günler yanlış biçimde boş görünebilir. | Her iki kaynağın kesilme bilgisini takvim durumuna taşıyın; tamamlanmamış veri uyarısı/yeniden yükleme yolu sağlayın. |
| 9 | düşük | 1 | `test/core/http/operation_resolve_test.dart:16`; `lib/core/http/interceptors.dart:126` | **Yeni çözümleme testi tek başına yeterli değil.** Sabit yolun kazanması ve yanlış metaverinin reddi var; eşit özgüllükte belirsizlik, harita sırasından bağımsızlık ve farklı kapsam sınıfları arasında başlık seçimi sınanmıyor. Mevcut `api_stack_test.dart:298` genel metaveri sahteciliğini ayrıca kapsıyor. | Sentetik S1/S2/S3 çakışmaları, eşit özgüllük ve farklı kayıt sıralarıyla güvenlik regresyonları ekleyin. |

### Soru özeti

1. **DÜZELTMEYLE GEÇER:** Gerçek yöntem/yol çözülüp `operationId` eşitliği başlıklardan önce doğrulanıyor; başka işlem metaverisi reddediliyor, kapsamın yanlış işleme bağlandığını gösteren açık bulmadım; yeni test kapsamı eksik — `lib/core/http/interceptors.dart:148`, `lib/core/http/interceptors.dart:165`, `test/core/http/operation_resolve_test.dart:16`.
2. **GEÇMEZ:** Tek sağlayıcı, yaşam döngüsü kapatma, jitter/backoff ve terminal 401/403 ayrımı mevcut; ancak başlangıç olay kaybı, uzlaştırma tavanı ve 429 beklemesinin sıfırlanması var; typing 3 saniyeyle, okundu ilerleyen seq ile azaltılıyor fakat ortak 60/180 bütçe sınırlayıcısı yok; etiketli §10.5 ayrı `revoked` olayı tanımlamıyor, iptali bağlantı kapanmasıyla anlatıyor — `lib/features/messages/domain/chat_stream_policy.dart:35`, `lib/features/messages/application/chat_room_controller.dart:328`, `lib/features/messages/application/chat_room_controller.dart:574`, `lib/features/messages/data/chat_api_mapping.dart:275`.
3. **GEÇMEZ:** Mesaj/ek tekrarında kimlik korunuyor; grup ve mesajdan görevde anahtarlı tek `conflict_retry` var, `idempotency_key_reused` otomatik tekrarlanmıyor; düzenleme tabanı ve arşiv yükleme anahtarı kusurlu — `lib/features/messages/application/chat_room_controller.dart:461`, `lib/features/messages/application/new_chat_controller.dart:34`, `lib/features/tasks/application/quick_forms_controller.dart:358`, `lib/features/messages/application/chat_room_controller.dart:552`.
4. **DÜZELTMEYLE GEÇER:** Yol geçişi engelleniyor, hata yolunda geçici klasör temizleniyor; aynı adla üzerine yazma riski var; Fotoğraflar kolunda compatible seçimi, jpeg→jpg normalizasyonu ve HEIC tür reddi doğru bağlanmış, cihazdaki dönüşüm çalıştırılarak doğrulanmadı — `lib/features/tasks/data/download_sink.dart:26`, `lib/features/tasks/data/download_sink.dart:59`, `lib/features/tasks/data/file_upload_picker.dart:25`, `lib/core/domain/upload_types.dart:42`.
5. **GEÇER — statik yetki kapısı açısından:** Arşiv departmanı erişim olgularından seçiliyor, gerçek klasör kendi departmanını taşıyor; bu seçimle yetki yükseltme kanıtı yok, çoklu departmanda kapsamın dar kalması mümkün; sohbet yönetim/@herkes/görev düğmeleri rol kaynaklarına bağlı, bildirim rotası erişim yetkisi vermiyor — `lib/features/archive/application/archive_providers.dart:25`, `lib/features/archive/domain/archive.dart:46`, `lib/features/messages/presentation/chat/chat_composer.dart:56`, `lib/features/messages/presentation/chat_page.dart:248`, `lib/features/tasks/application/task_details_controller.dart:37`.
6. **GEÇER — belirtilen istisnayla:** Bağlanan özelliklerde üretim örnek kaynağı bulmadım; **activity üretimde de örnek kalıyor**, toplantı ek örnekleri yalnız dev’e bağlı; incelenen yeni eşlemelerde sunucuda olmayan alanın gerçek veri diye uydurulduğunu görmedim — `lib/features/activity/activity_module.dart:12`, `lib/features/meetings/meetings_module.dart:29`, `lib/features/messages/data/chat_api_mapping.dart:59`, `lib/features/archive/data/records_api_repository.dart:256`.
7. **GEÇER — incelenen değişikliklerde:** DTO’lar data katmanında, get_it modül/bileşim kökünde, çapraz feature kullanımları açık yüzlerden ve file_picker tek izinli dosyada; belirgin tüketicisiz yeni mimari katman bulmadım — `lib/features/messages/data/chat_api_repository.dart:10`, `lib/app/di/composition.dart:78`, `lib/features/messages/application/chat_task_planner.dart:3`, `lib/features/tasks/data/file_upload_picker.dart:1`.
8. **GEÇMEZ:** Riverpod otomatik tekrarı kapalı ve takvim kaynak hatalarını yayıyor; fakat takvim kesilmesi sessiz, tepki/oy geri alma eşzamanlı yazmalarda güvenilir değil — `lib/app/di/composition.dart:93`, `lib/features/calendar/application/calendar_index_controller.dart:18`, `lib/features/messages/application/chat_actions_controller.dart:193`.


---

## Tur 2

### Hüküm: GEÇMEZ

`f8b931c` üzerinde salt okunur incelemede dokuz bulgunun yedisi kapandı, ikisi kısmen kaldı ve okundu ertelemesinde ek eksik bulundu; dosya yazılmadı, test/CI/ağ çalıştırılmadı.

### Tur 1 bulguları

| # | durum | kanıt dosya:satır |
|---|---|---|
| 1 | KAPANDI | Açılış sürümü saklanıp gönderiliyor: `lib/features/messages/presentation/chat_page.dart:277`, `:198`; `lib/features/messages/application/chat_room_controller.dart:490`. İlgili test: `test/features/messages/application/chat_room_controller_test.dart:419` — taslak açıkken SSE düzenlemesi ve eski sürümle 409. |
| 2 | KISMEN | Uçuş kaydı istek bitene kadar korunuyor; doğrulanmış/istenen durum ayrılmış: `lib/features/messages/application/chat_actions_controller.dart:193`, `:230`. Gecikmeli başarı/hata testleri: `test/features/messages/application/chat_actions_controller_test.dart:168`, `:196`, `:210`. Ancak yeni dokunuşlar ilk gönderilen değere dönerse hata bunları da geri alıyor; N1. |
| 3 | KAPANDI | Başlangıçta sinyaller `_missed` ile tutuluyor, yükleme sonrası uzlaştırılıyor: `lib/features/messages/application/chat_room_controller.dart:119`, `:149`. İlgili test: `test/features/messages/application/chat_room_controller_test.dart:465` — başlangıç yanıtıyla yarışan oluşturma/silme. |
| 4 | KAPANDI | Yeni mesaj veya görünür pencere tavanında son sayfadan yeniden kurulum var; bekleyen gönderimler korunuyor: `lib/features/messages/application/chat_room_reconcile.dart:19`, `:85`, `:90`. İlgili testler: `test/features/messages/application/chat_room_controller_test.dart:509`, `:529` — iki tavan ve yeniden eski geçmiş yükleme. |
| 5 | KAPANDI | Mutlak bekleme zamanı akış denetleyicisinden bağımsız tutuluyor ve her açılışta denetleniyor: `lib/features/messages/application/messages_providers.dart:72`; `lib/features/messages/application/chat_sync_controller.dart:111`, `:150`. İlgili testler: `test/features/messages/application/chat_sync_controller_test.dart:105`, `:130` — ön plana dönüş, ekranı yeniden açma ve süre dolması. |
| 6 | KAPANDI | Hedef `create(exclusive: true)` ile ayrılıyor; hatada ayrılan ad ve geçici çalışma alanı temizleniyor: `lib/features/tasks/data/download_sink.dart:72`, `:76`, `:89`. İlgili testler: `test/features/tasks/data/download_sink_test.dart:117`, `:145`, `:168`, `:179`. |
| 7 | KISMEN | Aynı imzada anahtar korunuyor, `conflict_retry` aynı anahtarla bir kez deneniyor: `lib/features/archive/application/archive_actions_controller.dart:141`, `:155`. İlgili testler: `test/features/archive/application/archive_actions_controller_test.dart:165`, `:191`. Ancak imzadaki geçici dosya yolu gerçek yeniden seçimde değişiyor; N2. |
| 8 | KAPANDI | Toplantı ve katalog kesilmesi birlikte taşınıp gösteriliyor: `lib/features/calendar/application/calendar_index_controller.dart:23`; `lib/features/calendar/domain/calendar.dart:191`; `lib/features/calendar/presentation/calendar_page.dart:74`. İlgili test: `test/features/calendar/application/calendar_index_controller_test.dart:160`. |
| 9 | KAPANDI | İleri/ters kayıt sırası, eşit özgüllükte ret, S1/S2/S3 başlık seçimi ve yanlış metaveriyle kapsam değiştirme denemeleri eklenmiş: `test/core/http/operation_resolve_test.dart:74`, `:119`, `:127`, `:143`; üretim kapısı `lib/core/http/interceptors.dart:116`, `:148`. |

“KAPANDI”, kod ve mevcut test içeriği bakımındandır; testlerin çalıştığı veya CI’ın yeşil olduğu doğrulanmadı.

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N1 | orta | `lib/features/messages/application/chat_actions_controller.dart:248`, `:234` | **Yeni kuyrukta sonraki niyet silinebiliyor.** Başlangıçta tepki yokken `like` isteği uçuşa çıksın; kullanıcı uçuş sırasında `heart`, sonra yeniden `like` seçsin. İlk istek hata verdiğinde `desired == sending` olduğu için son niyet de `confirmed` olan boş değere çekiliyor. Sonraki bekleyenler istek gönderilmeden başarıyla tamamlanıyor. Aynı sorun oy kuyruğunda da var. Tur 1 #2 tamamen kapanmamış. | Geri alma kararını yalnız değer eşitliğine bağlamayın; dokunuş neslini veya yeni bekleyenlerin varlığını izleyin. Gecikmeli hata sırasında A→B→A senaryosunu tepki ve oy için sınayın. |
| N2 | orta | `lib/features/archive/application/archive_actions_controller.dart:136`, `:144`; `lib/features/tasks/data/file_upload_picker.dart:35` | **Arşiv tekrar anahtarı gerçek seçicide kararlı değil.** Her denemede seçici yeniden açılıyor ve anahtar imzasına `file.path` giriyor. Yerel bağımlılık kaynağında Android seçicisi yolu `/file_picker/<currentTimeMillis>/<ad>` olarak oluşturuyor: `android_file_picker-2.1.1/…/FileUtils.kt:771`. Başarılı yüklemenin yanıtı kaybolduktan sonra aynı dosyanın yeniden seçimi yeni anahtar, dolayısıyla ikinci kayıt üretebilir. Mevcut tekrar testi hep aynı yolu döndüren seçici kullanıyor. Bu, Tur 1 #7’nin kalan kısmı. | Bekleyen yükleme niyetini dosya kaynağı, kapsam, görev, etiket ve anahtarla saklayın; açık “yeniden dene” eylemi seçiciyi açmadan aynı niyeti göndersin. Aynı dosyanın farklı geçici yolla dönmesini kapsayan test ekleyin. |
| N3 | orta | `lib/features/messages/application/chat_room_controller.dart:263`; `lib/features/messages/domain/chat_stream_policy.dart:93` | **Kova dolunca okundu için devam işi kurulmuyor.** İmlecin ilerletilmemesi doğru; ancak kapasite açıldığında hiçbir zamanlayıcı/dinleyici tekrar denemiyor. Yeni olay veya yeniden bağlanma gelene kadar okunmamış rozeti ve karşı tarafın tiki geride kalıyor. `loadOlder()` da okundu gönderimini tetiklemiyor. Mevcut bütçe testi yalnız kovayı sınayıp denetleyicinin toparlanmasını kapsamıyor. | Son bekleyen okundu hedefini birleştirerek saklayın; kapasite açılınca, ön plan ve yaşam döngüsü koşullarıyla tek gönderim planlayın. “Kova dolu → başka olay yok → süre doldu” testini ekleyin. |

**Okundu imleci açısından:** `_readSeq` kova reddinde değişmediği için kalıcı olarak “gönderildi sanma” kusuru yok. Sağlıklı SSE’nin sonraki yeniden bağlanması uzlaştırma sonunda tekrar dener (`chat_room_reconcile.dart:22`). Dolayısıyla normal akışta kesin kalıcı kayıp iddiası doğru olmaz; eksik olan, bütçe açılınca bağımsız ve garantili devamdır.

**Diğer odaklar:** `chat_room_reconcile.dart` ayrımında ek bir katman veya yeni davranış bozulması bulmadım. `ChatStreamHold`, incelenen ön plan/ekran yaşam döngüsünde beklemeyi koruyor. İndirme adı ayırması uygulamanın eşzamanlı indirmeleri arasında atomik; hata temizliği mevcut dosyayı hedeflemiyor. Ancak “eşzamanlı” test iki aktarımın sonlandırılmasını sırayla bekliyor (`download_sink_test.dart:132`); aynı anda ad ayırma yarışını doğrudan zorlamıyor. Takvim kesilme uyarısı bağlanmış; kesilmiş kaynak için özel yeniden yükleme eylemi eklenmemiş.

**Tur 1 soru 5, 6 ve 7:** İncelenen düzeltme farkında gerileme bulmadım. Yetki görünürlüğü korunuyor (`chat_page.dart:253`, `chat_composer.dart:56`, `archive_providers.dart:25`); activity’nin üretimde örnek kalması önceki istisna olarak sürüyor (`activity_module.dart:12`), toplantı ek örnekleri hâlâ yalnız dev’de (`meetings_module.dart:29`). Yeni kod DTO/get_it sınırlarını değiştirmiyor; uzlaştırma aynı application dizininde `part` olarak ayrılmış (`chat_room_controller.dart:17`).


---

## Tur 3

### Hüküm: GEÇMEZ

`4942d00` mevcut haliyle main’e girmemeli: yüklemede farklı içerik sessizce tekrar sayılabiliyor ve ön plan rozet yenilemesi eski yanıtın yeni durumu ezmesini engellemiyor.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| Tur 1 #2 | KAPANDI | Uçuş kaydı korunuyor; hata sonrası geri alma dokunuş nesline bağlı: `lib/features/messages/application/chat_actions_controller.dart:195`, `:240`, `:256`. Gecikmeli hata altında tepki/oy A→B→A, A→B ve doğrulanmış değere dönüş testleri: `test/features/messages/application/chat_actions_controller_test.dart:224`. |
| Tur 1 #7 | KISMEN | Bekleyen niyet, seçicisiz tekrar ve aynı anahtarlı tek `conflict_retry` mevcut: `lib/features/archive/application/archive_actions_controller.dart:157`, `:181`. Testler: `test/features/archive/application/archive_actions_controller_test.dart:192`, `:258`, `:290`. Ancak yeni imza farklı dosyaları aynı niyet sayabiliyor; N5. |
| Tur 2 N1 | KAPANDI | Değer eşitliği yerine nesil karşılaştırılıyor; araya dokunuş girdiyse belirsiz sonuçtan sonra son niyet gönderiliyor: `lib/features/messages/application/chat_actions_controller.dart:235`, `:256`. Tepki ve oy regresyonları: `test/features/messages/application/chat_actions_controller_test.dart:224`. |
| Tur 2 N2 | KAPANDI | “Yeniden dene” seçiciyi açmadan saklanan dosya ve anahtarı kullanıyor: `lib/features/archive/application/archive_actions_controller.dart:157`; `lib/features/archive/presentation/archive/archive_upload.dart:102`. Seçicinin yalnız bir kez açıldığını ve aynı yol/anahtarın kullanıldığını sınayan test: `test/features/archive/application/archive_actions_controller_test.dart:258`. Yeniden seçimde yol bağımsızlığı testi: `:290`; bunun yeni çakışma riski N5’te. |
| Tur 2 N3 | KAPANDI | Kova reddinde tek zamanlayıcı kuruluyor; ateşlemede güncel hedef ve ön plan denetleniyor, dispose sırasında iptal ediliyor: `lib/features/messages/application/chat_room_controller.dart:82`, `:263`, `:275`; `lib/features/messages/domain/chat_stream_policy.dart:104`. Başka olay olmadan devam, arka plan ve kapanış testleri: `test/features/messages/application/chat_room_controller_test.dart:551`. |
| N4 | KISMEN | Ön plana dönüş bağlantısı doğru: `lib/app/foreground_refresh.dart:44`. Yaşayan akış denetleyicisi varsa ek okuma atlanıyor: `lib/features/messages/application/messages_nav_caption.dart:28`; akış açılışı listeyi yeniliyor: `lib/features/messages/application/chats_controller.dart:43`. Temel dallar testi: `test/app/foreground_refresh_test.dart:106`. Ancak devam eden okuma sırasında akışın açılması ve ters yanıt sırası sınanmıyor veya korunmuyor; N6. |

“KAPANDI” kod ve mevcut test içeriği açısından verilmiştir. Dosya yazılmadı; test, CI veya ağ çalıştırılmadı. CI’ın yeşil olduğu doğrulanmadı.

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N5 | yüksek | `lib/features/archive/application/archive_actions_controller.dart:169`; `lib/features/tasks/application/task_detail_controller.dart:578`; backend `v0.11.0-api:docs/api/istemci-akislari.md:327` | **Aynı ad/boyutlu farklı dosya, yüklenmeden başarılı sayılabilir.** A dosyası sunucuda kaydedilip yanıtı kaybolduktan sonra kullanıcı aynı kapsam/görev/etiket, ad ve boyutta farklı içerikli B dosyasını seçerse eski anahtar kullanılır. §8 yükleme istisnası açık: aynı anahtar/ad/tür, farklı içerikle de tekrar sayılır. Sunucu eski kaynağı 200 döndürebilir; istemci B yüklenmiş gibi başarı gösterir. Yeni testler yalnız yol/ad/boyut değişimini kapsıyor, farklı içeriği ayırt etmiyor. | Açık tekrar saklanan niyeti kullanmaya devam etsin; yeniden seçimde eşit ad/boyutu içerik eşitliği saymayın. İçerik özetiyle doğrulayın veya kullanıcıya mevcut niyeti tekrarlama/yeni yükleme ayrımını açıkça yaptırın. Her iki yükleme yolunda “A kaydedildi, yanıt kayboldu, aynı ad/boyutta farklı B seçildi” regresyonu ekleyin. |
| N6 | orta | `lib/features/messages/application/messages_nav_caption.dart:29`; `lib/features/messages/application/chats_controller.dart:43`, `:58` | **N4’ün çift istek koruması yalnız çağrı anını kapsıyor.** Mesaj ekranı kapalıyken ön plana dönüş R1 okumasını başlatır. R1 sürerken mesaj ekranı açılırsa akış açılışı R2’yi başlatır. R2 güncel listeyi yerleştirdikten sonra R1’in eski yanıtı gelirse `state = AsyncData(inbox)` bunu ezer; rozet/liste geriler. `refresh()` uçuş birleştirmesi veya yanıt nesli taşımıyor. Mevcut N4 testi gecikmeli yanıtları kapsamıyor. | Liste yenilemelerini ortak bir sıraya alın; uçuş sırasında gelen akış sinyalini sonradan yapılacak yenileme olarak saklayın veya eski yanıtları nesille reddedin. R1→akış açılışı→R2→R2 tamamlanması→R1 tamamlanması senaryosunu sınayın. |

**409 sunumu:** Sunucu gerçekten `*.idempotency_key_reused` döndürürse istemci bunu başarı saymıyor ve otomatik tekrarlamıyor. Arşiv `client.request_not_resent` döndürüyor, anahtarı temizliyor ve hata toast’ına iletiyor (`archive_actions_controller.dart:194`, `archive_outcome.dart:19`). Görev ayrıntısı da aynı dönüşümü yapıyor (`task_detail_controller.dart:126`, `:175`). Türkçe metin: “İstek tekrar gönderilemedi; işlemi yeniden başlatın.” (`lib/core/i18n/arb/app_tr.arb:988`). Arşiv testi `archive_actions_controller_test.dart:222`, ortak görev yazma kapısı testi `task_detail_f60_test.dart:462`. **Bu doğru hata yolu N5’i önlemiyor; ilgili çakışmada sözleşme 409 garantisi vermiyor.**


---

## Tur 4

### Hüküm: GEÇMEZ

`f935b16` üzerinde önceki dört bulgu kod ve test içeriği bakımından kapanmış olsa da yeni özet okumasının yakalanmayan hata yolu ve boyut denetiminden önce sınırsız çalışması düzeltilmeden dal main’e girmemeli.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| Tur 1 #7 | KAPANDI | Niyet ve anahtar korunuyor; seçicisiz tekrar ve aynı anahtarla tek `conflict_retry` mevcut: `lib/features/archive/application/archive_actions_controller.dart:159`, `:169`, `:187`. Testler: `test/features/archive/application/archive_actions_controller_test.dart:173`, `:199`, `:265`, `:301`. |
| Tur 3 N4 | KAPANDI | Ön plana dönüş bağlantısı ve yaşayan akış kontrolü mevcut: `lib/app/foreground_refresh.dart:44`, `lib/features/messages/application/messages_nav_caption.dart:28`; yarış N6 düzeltmesiyle korunuyor. Testler: `test/app/foreground_refresh_test.dart:106`, `test/features/messages/application/chats_controller_test.dart:66`. |
| Tur 3 N5 | KAPANDI | SHA-256 seçimde hesaplanıp iki imzaya katılıyor: `lib/features/tasks/data/file_upload_picker.dart:46`, `lib/features/archive/application/archive_actions_controller.dart:171`, `lib/features/tasks/application/task_detail_controller.dart:579`. Gerçek dosya içeriğiyle farklı yol/aynı içerik ve aynı ad-boyut/farklı içerik testleri: `test/features/archive/application/archive_actions_controller_test.dart:301`, `test/features/tasks/application/task_detail_f60_test.dart:421`; özet testi: `test/features/tasks/data/upload_digest_test.dart:16`. |
| Tur 3 N6 | KAPANDI | Son başlatılan yenilemenin nesli karşılaştırılıyor: `lib/features/messages/application/chats_controller.dart:68`, `:71`. R1 → akış açılışı → R2 → R2 yanıtı → R1 yanıtı regresyonu: `test/features/messages/application/chats_controller_test.dart:66`. |

“KAPANDI” statik kod ve test içeriği hükmüdür; testler çalıştırılmadı. Önceki turlarda kapanan diğer bulguları yeniden açacak bir değişiklik bu farkta saptamadım. Dosya yazılmadı; test, CI veya ağ çalıştırılmadı; bu HEAD için yeşil CI doğrulanmadı.

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N7 | orta | `lib/features/tasks/data/upload_digest.dart:11`; `lib/features/tasks/application/task_detail_controller.dart:546`; `lib/features/tasks/presentation/detail/detail_actions.dart:476`; `lib/features/messages/presentation/chat_page.dart:340` | **Özet okuma hatası görev ve sohbet ekranlarında yakalanmıyor.** Seçimden sonra dosyanın silinmesi/okunamaması `FileSystemException` üretir. Görev seçim zincirinde yakalama yok; sohbette seçici çağrısı `_try` dışında. Kullanıcıya hata gösterilmeden Future hatası dışarı çıkar; görevde önceki seçim kalabilir. Arşiv `_run` ile hatayı yakalıyor. Yeni özet testi yalnız başarılı okumayı kapsıyor. | Seçim/özet hatasını kullanıcıya gösterilen bir sonuca dönüştürün; iptalden ayırın. Okunamayan dosya için görev, sohbet ve arşiv hata davranışlarını sınayın. |
| N8 | orta | `lib/features/tasks/data/file_upload_picker.dart:39`, `:46`; `lib/features/tasks/data/upload_digest.dart:11`; `lib/features/archive/application/archive_actions_controller.dart:147`; `lib/features/tasks/application/task_detail_controller.dart:571` | **Boyut/tür reddinden önce dosyanın tamamı okunuyor.** Bilinen boyut 90 MiB sınırını aşsa bile özet bitmeden ret verilmiyor; örneğin çok büyük bir PDF bütünüyle okunup hash’leniyor. Akış kullanımı belleği sınırlar, toplam disk/CPU işini sınırlamaz. Başlamış özetin iptal bağlantısı da yok; ekran kapansa dahi okuma sürer. | Boyut ve türü içerik okumadan doğrulayın; özet işini yaşam döngüsüne bağlayın. Sınır dışı dosyada okuyucunun hiç açılmadığını ve iptalde okumanın durduğunu sınayın. |
| N9 | düşük | `lib/features/tasks/data/file_upload_picker.dart:46`; `lib/features/messages/presentation/chat_page.dart:340`, `:353` | **Sohbet ekinde kullanılmayan özet hesaplanıyor.** Ortak seçici her ekin içeriğini okuyor, ancak `ChatUpload` oluşturulurken `digest` atılıyor; yükleme öncesinde gereksiz tam dosya okuması eklenmiş. | Özet gereksinimini yükleme kullanımına göre belirleyin; görev/arşiv niyeti için koruyup sohbet ekinde gereksiz okumayı kaldırın. |

Sistem seçicisinde vazgeçme doğru biçimde `null` döndürüyor (`file_upload_picker.dart:37`); N8, seçimden **sonra başlayan** özet işinin iptaliyle ilgilidir.

F2 ve ADR uyumunda yeni kusur saptamadım: `crypto` yalnız izinli dosyada kullanılıyor; kesin dosya ve export yasağı `tool/boundaries.dart:448` ile uygulanıyor, negatif örnekleri `test/tool/boundaries_test.dart:638` kapsıyor. ADR-0002:24 davranışı açıklıyor. `pubspec.yaml:13` ile `pubspec.lock:228` uyumlu; kilitte yalnız bağımlılık sınıfı doğrudan bağımlılığa dönüşmüş, **3.0.7 sürümü ve paket özeti değişmemiş**.


---

## Tur 5

### Hüküm: GEÇMEZ

`ozellik/api-baglama` / `e9391f5`, önceki düzeltmeler korunmakla birlikte görev yüklemesindeki yeni hazırlık yarışı ve eksik dosya okuma hatası eşlemesi giderilmeden main’e girmemeli.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| Tur 4 N7 | KAPANDI | **Özgün özet/seçici hatasının dışarı kaçması giderilmiş:** `lib/features/tasks/data/upload_digest.dart:30`, `lib/features/tasks/application/task_detail_controller.dart:550`, `:583`; sohbet seçimi artık yakalama içinde: `lib/features/messages/presentation/chat_page.dart:341`. Testler: `test/features/tasks/application/task_detail_upload_digest_test.dart:176`, `test/features/tasks/data/upload_digest_test.dart:32`, `test/features/messages/presentation/chat_page_test.dart:213`. Multipart akışındaki ayrı eksik aşağıda N11. |
| Tur 4 N8 | KAPANDI | Tür/boyut denetimleri özetten önce: `lib/features/tasks/application/task_detail_controller.dart:575`, `lib/features/archive/application/archive_actions_controller.dart:147`. Parça başına iptal: `lib/features/tasks/data/upload_digest.dart:26`. Testler: `test/features/tasks/application/task_detail_upload_digest_test.dart:127`, `:192`; `test/features/archive/application/archive_actions_controller_test.dart:149`, `:210`; `test/features/tasks/data/upload_digest_test.dart:45`. Denetleyici kapanışı korunuyor; form yaşam döngüsündeki ayrı yarış N10. |
| Tur 4 N9 | KAPANDI | Seçici yalnız kaynak bilgisi döndürüyor: `lib/features/tasks/data/file_upload_picker.dart:49`; sohbet doğrudan `ChatUpload` oluşturuyor: `lib/features/messages/presentation/chat_page.dart:351`. İlgili sohbet akışı testi: `test/features/messages/presentation/chat_page_test.dart:201`. Ayrı “özet çağrısı sıfır” testi yok; üretim çağrı yolunda özetleyici bulunmuyor. |
| Tur 1 #7, Tur 2 N2, Tur 3 N5 | KAPANDI | Arşiv saklı niyeti ve özeti kullanıyor: `lib/features/archive/application/archive_actions_controller.dart:166`, `:178`; görev yeni seçim nesnesinde yeniden hesaplıyor: `lib/features/tasks/application/upload_digest_memo.dart:16`. Testler: `test/features/archive/application/archive_actions_controller_test.dart:348`; `test/features/tasks/application/task_detail_f60_test.dart:420`. |
| Tur 3 N4/N6 | KAPANDI | Eski yanıt nesille reddediliyor: `lib/features/messages/application/chats_controller.dart:68`. Yarış testi: `test/features/messages/application/chats_controller_test.dart:66`. |
| Diğer önceki kapanışlar | KAPANDI | Tur 2 ve Tur 3 hükümlerindeki kapanışlar korunuyor; bu farkta onları yeniden açacak değişiklik saptamadım. Bu satır önceki hükümleri devralır, bütün dalın yeniden test edildiği anlamına gelmez. |

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N10 | yüksek | `lib/features/tasks/application/task_detail_controller.dart:582`, `:586`, `:600`; `lib/features/tasks/application/upload_digest_memo.dart:19`; `lib/features/tasks/presentation/detail/detail_actions.dart:382`, `:413` | **Özet hazırlığı yazma kilidinin ve form yaşam döngüsünün dışında.** `busy`, ancak özet tamamlandıktan sonra `_write` içinde kuruluyor. İki gönderim aynı dosyayı eşzamanlı özetleyebilir; ilk gönderim başarıyla bitip anahtarı temizledikten sonra ikinci özet tamamlanırsa ikinci çağrı yeni anahtarla aynı dosyayı yeniden yükler. Ayrıca kullanıcı özet sürerken “Vazgeç” ile formu kapatınca `closeForms()` taslağı siliyor fakat denetleyici yaşıyor; yalnız `ref.mounted` kontrolü eski yerel `d/f` ile gönderimi sürdürüyor. Yeni form açılmışsa eski gönderimin başarısı onu da temizleyebilir. Mevcut kapanış testi yalnız sağlayıcının dispose edilmesini kapsıyor (`task_detail_upload_digest_test.dart:192`). | Hazırlık dahil bütün gönderimi tek uçuşla koruyun; form/seçim neslini iptal koşuluna bağlayın ve ağ isteğinden önce doğrulayın. Gecikmeli iki özet → ilk başarı → ikinci tamamlanma; özet sırasında form kapatma; kapatıp yeni taslak açma regresyonlarını ekleyin. |
| N11 | orta | `lib/core/http/file_upload.dart:88`; `lib/core/errors/api_error.dart:108`; `lib/features/messages/application/chat_room_controller.dart:473` | **`client.file_unreadable` eşlemesi gerçek içerik okumasını kapsamıyor.** Yerel Dio 5.11.1 kaynağında `MultipartFile.fromFile` yalnız `file.length()` bekliyor; `openRead()` daha sonra multipart tüketilirken çalışıyor (`…/dio-5.11.1/lib/src/multipart_file/io_multipart_file.dart:16`, `:45`). Boyutu okunabilen fakat içeriğine erişilemeyen dosyada hata `_filePart` yakalamasının dışında oluşuyor ve `toApiError` bunu ağ hatasına indiriyor. Sohbette yeni `fileUnreadable` dalı çalışmıyor; yeniden seçme bildirimi yerine başarısız/tekrarlanabilir balon kalıyor. Yeni HTTP testi yalnız bulunmayan dosyayı kapsıyor (`test/core/http/file_upload_test.dart:25`). | Dosya akışının açılma/okuma hatasını da yerel dosya hatası olarak taşıyın; ağ/TLS hatalarıyla karıştırmayın. Boyut sorgusu başarılı, içerik akışı hatalı senaryosunu gerçek multipart tüketimiyle sınayın. |

### Notlar

- Dosya yazılmadı; test, CI veya ağ çalıştırılmadı. “KAPANDI” statik kod ve mevcut test içeriği hükmüdür; bu HEAD için yeşil CI doğrulanmadı.
- **Saklı özet:** Normal yeniden seçim yeni `UploadSource` oluşturuyor; nesne kimliği değişince özet yeniden hesaplanıyor. Taslakta dosya değiştirilmesine rağmen eski özetin yeni dosyaya bağlandığını doğrulamadım. Aynı fiziksel yolun dışarıdan değiştirilmesine karşı içerik sabitleme garantisi ise yok; bunu kanıtlanmış normal seçim kusuru olarak yazmadım.
- **İzin reddi:** Seçicinin bütün `Exception` türlerini `file_unreadable` yapması ayrıntıyı kaybettiriyor; ancak kullanıcı metni “erişilemiyor olabilir” dediğinden izin reddini yanlışlıkla kesin “silinmiş” diye adlandırmıyor. Ayrı izin mesajı tercih notudur. N11 ise gerçek dosya okuma hatasının ağ hatasına dönüşmesidir.
- **Mimari:** `UploadDigest` domain portu, `tasks_module.dart` kaydı ve Riverpod bağlantısı mevcut get_it/Riverpod ayrımıyla uyumlu. F2 kesin dosya/export yasağı korunmuş (`tool/boundaries.dart:448`); negatif testler `test/tool/boundaries_test.dart:638`, ADR açıklaması `docs/architecture/adr-0002-paketler-tercih-yerel-veri-firebase.md:24`. Yeni mimari ihlal saptamadım.


---

## Tur 6

### Hüküm: GEÇMEZ
`66553a5` üzerinde N10’un özgün yarışları ve N11 kapanmış; ancak yeni nesil iptalinin sunum katmanında formu kapatıp yeni dosya seçimini silmesi giderilmeden dal main’e girmemeli.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| N10 | KAPANDI | Özet öncesi kilit ve nesil kontrolü: `lib/features/tasks/application/task_detail_upload.dart:78`; kapanışta nesil artırımı: `lib/features/tasks/application/task_detail_controller.dart:574`; eski başarının yeni formu temizlememesi: `task_detail_upload.dart:105`. Testler: `test/features/tasks/application/task_detail_upload_digest_test.dart:214`, `:234`, `:254` — ikinci gönderim, özet sırasında kapatıp açma, istek sırasında yeni taslak. Aşağıdaki N12 ayrı bir sunum entegrasyonu kusurudur. |
| N11 | KAPANDI | Boyut hatası ve içerik akışı hatası ayrı ayrı eşleniyor: `lib/core/http/file_upload.dart:93`, `:98`; içteki `ApiError` korunuyor: `lib/core/errors/api_error.dart:81`. Testler: `test/core/http/file_upload_test.dart:87` — boyut okunduktan sonra dosyanın silinmesi, görev/sohbet multipart tüketimi ve gerçek ağ hatasının korunması; `test/features/messages/data/chat_api_actions_test.dart:221` — repository üzerinden aynı hata. |
| Tur 1 #1–9; Tur 2 N1–N3; Tur 3 N4–N6; Tur 4 N7–N9 | KAPANDI — önceki hükümlerden devralındı | Tur 2–5 raporlarındaki dosya:satır ve test kanıtları geçerli kabul edildi; bu 10 dosyalık farkta önceki kapanışları yeniden açacak değişiklik saptanmadı. Bütün dalın yeniden doğrulandığı anlamına gelmez. |

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N12 | orta | `lib/features/tasks/application/task_detail_upload.dart:52`, `:90`; `lib/features/tasks/presentation/detail/detail_forms.dart:391`; `lib/features/tasks/presentation/detail/detail_actions.dart:386`, `:413` | **Özet sırasında yeni dosya seçilince yeni taslak siliniyor.** A dosyasının özeti sürerken dosya seçme düğmesi etkin kalıyor. B seçimi tamamlanınca nesil artıyor; A gönderimi doğru biçimde istek atmadan `unchanged` dönüyor. Ancak `_form`, `unchanged` sonucunda hâlâ açık olan aynı formu kapatıyor; ardından `closeForms()` B seçimini siliyor. Mevcut yeni testler denetleyici düzeyinde kapatıp yeniden açmayı kapsıyor, bu sunum yolunu kapsamıyor. | Bayat/iptal edilmiş gönderimi form kapatan `unchanged` sonucundan ayırın veya formun gönderim neslini kapatma öncesinde doğrulayın. Geciktirilmiş özet → aynı formda B seçimi → eski gönderimin tamamlanması senaryosunda formun ve B seçiminin korunduğunu sınayın. |

### Notlar

- **Kilit geçişi:** `task_detail_upload.dart:88` ile `_write` içindeki yeniden kilitleme arasında `await` yok (`task_detail_controller.dart:170–175`, `:107–114`). Mevcut üretim çağrı yolunda bu aralığa giren ikinci kullanıcı olayı veya yeniden giriş yapan dinleyici kanıtı bulmadım; bunu kusur saymıyorum.
- **Başarı temizliği:** Denetleyicide `r.ok && !stale()` yeni açılan taslağı koruyor. N12, başarı temizliğinden değil, sunumun iptal sonucunu kapatma olarak yorumlamasından kaynaklanıyor.
- **Uzunluk/akış:** Uzunluk gerçek `File.length()` sonucundan geliyor; `openRead()` dosyayı sonradan açıyor. Dosyanın arada dışarıdan değiştirilmesine karşı sabitleme yok; önceki Dio `fromFile` gerçekleştirmesi de aynı davranıştaydı. Bu farkın getirdiği yeni uzunluk kusuru kanıtlanmadı.
- **Tekrar:** Akış nesnesi saklanmıyor; `fromStream` fabrikası her çağrıda yeni `openRead()` oluşturuyor. Repository tekrarı yeni multipart kuruyor. Ayrıca 401 sonrası mevcut `FormData` otomatik tekrar edilmiyor (`lib/core/http/interceptors.dart:283`). Tüketilmiş aynı akışın tekrar kullanıldığı yol saptanmadı.
- “KAPANDI” statik kod ve test içeriği hükmüdür. Dosya yazılmadı; test, CI veya ağ çalıştırılmadı. HEAD ve dal yerelden doğrulandı; bu HEAD için yeşil CI doğrulanmadı.


---

## Tur 7

### Hüküm: GEÇER

`ozellik/api-baglama` / `47059c2`, önceki kapanışlar ve N12 düzeltmesi birlikte değerlendirildiğinde kod incelemesi kapısından geçer; main’e birleşmesi için mevcut PR ve yeşil CI koşulu korunur.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| N12 | **KAPANDI** | Bayat gönderim `superseded` döndürüyor: `lib/features/tasks/application/task_detail_upload.dart:90`. Form sonucu sessizce bırakıyor: `lib/features/tasks/presentation/detail/detail_actions.dart:405`; kapama dalına girmiyor. Denetleyici testi: `test/features/tasks/application/task_detail_upload_digest_test.dart:254`. Sunum testi: `test/features/tasks/presentation/detail_upload_form_test.dart:41`; B seçimi, açık form, başarı bildiriminin yokluğu ve POST gönderilmemesi `:94`–`:98` üzerinde sınanıyor. |
| N10 | KAPANDI | Özet öncesi kilit ve nesil kontrolü: `lib/features/tasks/application/task_detail_upload.dart:78`; kapanışta nesil artırımı: `lib/features/tasks/application/task_detail_controller.dart:574`. Testler: `test/features/tasks/application/task_detail_upload_digest_test.dart:214`, `:234`, `:270`. |
| N11 | KAPANDI | İçerik akışındaki dosya hatası eşleniyor: `lib/core/http/file_upload.dart:98`; iç hata korunuyor: `lib/core/errors/api_error.dart:81`. Multipart tüketimi ve ağ hatası ayrımı testi: `test/core/http/file_upload_test.dart:89`. |
| Tur 1 #1–9; Tur 2 N1–N3; Tur 3 N4–N6; Tur 4 N7–N9 | KAPANDI — önceki hükümlerden devralındı | Toplu kapanış kaydı: `codex-hukum-tur6.md:10`; ayrıntılı dayanaklar Tur 2–5 hükümlerinde. İncelenen dört dosyalık farkta bu kapanışları yeniden açan değişiklik saptanmadı. |

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| — | — | — | Bu farkta yeni, kanıtlı kusur saptanmadı. | — |

### Notlar

- **`WriteOutcome` tüketicileri:** Üretim ağacındaki tüm `WriteOutcome` / `WriteKind` referansları ve sonuç işleyen dallar tarandı. `superseded` yalnız `submitUpload()` tarafından üretiliyor; sunuma `detail_actions.dart:463` üzerinden ulaşıyor.
- **`case _` davranışı doğru:** `_form` içinde `:405` sessizce çıkar; `Navigator.pop()` ve başarı mesajı yalnız `:386` dalındadır. `_report` içindeki `:168` de sessizdir; durum değiştirme dalı `:130` buraya yönlenir. Not/alt görev çakışma yollarında da yanlış bildirim veya kapama saptanmadı.
- **Başarı olarak yorumlanmıyor:** `lib/features/tasks/application/task_detail_state.dart:67` yalnız `done` için `ok=true` döndürür. Yeni sonuç, başarıya bağlı temizleme işlemlerini tetiklemez.
- Sunum testi özgün N12 senaryosunu gerçek form üzerinden kapsıyor. Bildirim kontrolü özellikle yükleme başarı metnini sınar; bütün bildirimlerin yokluğu ayrıca sınanmıyor. Kodun bu sonuçtaki sessiz dalı açık olduğundan bu bir engel değildir.
- Dal ve HEAD yerelden doğrulandı; çalışma ağacı temiz. Dosya yazılmadı; test, CI veya ağ çalıştırılmadı. **GEÇER statik inceleme hükmüdür; bu HEAD için test başarısı ve yeşil CI doğrulanmış değildir.** Bütün dal baştan incelenmiş sayılmıyor; önceki altı turun kapanışları devralınıyor.

