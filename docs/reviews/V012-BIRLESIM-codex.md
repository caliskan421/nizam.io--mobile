# v0.12.0-api birleşimi — Codex hükümleri

Dal `bakim/v012-birlesim` (main `280b34a` tabanı). Kapsam: pin v0.11.0-api → v0.12.0-api; F63 toplantı alanları (place, invite_mode, deleted_by, liste özeti, son konferans, bağlı kişiler, katılımcı ekipleri, not kalıcı silme + geri al); ADR-0030 yönetici alt görev, yükleme ve kendi dosyasını silme; koordinatörlük ekle ve düzenle; pasifleştir, üst birim ve arşiv klasör oluştur kaldırıldı (ürün sahibi kararı); "Üye ekle" `createUser`'a bağlandı. Model `gpt-6-astra`, `-s read-only`, `model_reasoning_effort=medium`; her tur ≥ 29 dosya (KAPI m.13).

| Tur | Hüküm | Okunan dosya |
|---|---|---|
| 1 | GEÇMEZ | 56 |
| 2 | GEÇMEZ | 62 |
| 3 | GEÇER | 43 |

---

## Tur 1

### Hüküm: GEÇMEZ

Pin ve ADR-0030 uyumlu olsa da kişi daveti, yarım kalan koordinatörlük işlemleri, konferans durumu ve üretimde kalan sahte başarı bildirimleri nedeniyle nihai kapı geçilemiyor.

### Bulgular

| # | önem | soru | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|
| 1 | P1 | 5 | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:65` | Yeni `keepAlive` controller, `pending` departmanı oturum/kurulum kimliğine bağlamıyor ve oturum değişince temizlemiyor. Bağlama başarısız olduktan sonra çıkış ve başka hesapla giriş yapılınca önceki departmanın adı/açıklaması yeni hesabın formuna taşınıyor; tekrar deneme eski kimliği kullanıyor. | Bekleyen işlemi oturum nesli, kurulum ve hedef programla ilişkilendir; oturum değişiminde temizle ve eski uçuş sonuçlarını reddet. |
| 2 | P2 | 3 | `lib/features/meetings/presentation/meeting_people.dart:242`; `lib/features/tasks/data/task_catalog_api_repository.dart:86` | `person` seçicisi “programdaki herkes” yerine görev kataloğunu kullanıyor. Yönetici olmayan koordinatörün kataloğunda yalnız kendi ekip satırlarının departmanları bulunuyor; ekip okuması da koordine ettiği departmanlarla sınırlı. Dolayısıyla başka koordinatörlükteki kişiyi kuruluşta veya sonradan seçemiyor. | Toplantı daveti için program kapsamındaki uygun kişileri sunan ayrı bir kaynak kullan; sözleşmede yeterli okuma yüzü yoksa backend işi aç. |
| 3 | P2 | 2, 6 | `lib/features/meetings/application/meetings_planner.dart:37`; `lib/features/tasks/presentation/quick_action_sheets.dart:113` | Oluşturma yanıtındaki `failedParticipants` eşlenmesine rağmen planner yalnız toplantı kimliğini döndürüyor. Bildirim, gerçekten eklenenleri değil formdaki bütün kişileri “davet edildi” sayıyor. Kısmi başarısızlık kullanıcıya tam başarı olarak gösteriliyor; devirdeki beklenti karşılanmamış. | Oluşturma sonucunu forma taşı; başarılı/başarısız katılımcıları ayrı bildir ve tekrar ekleme olanağı ver. |
| 4 | P2 | 2 | `lib/features/meetings/application/meeting_room_controller.dart:387`; `lib/features/meetings/domain/meeting.dart:219` | Konferans bitirilince yalnız `conference=null` yapılıyor; `lastConference` yenilenmiyor. İlk konferansın ardından özet `none` oluyor ve toplantı yeniden “başlatılmadı/bekliyor” görünümüne düşüyor; önceki konferans varsa onun eski süresi gösteriliyor. Bu yanlış özet listeye de yazılıyor. | Bitirme sonrasında sunucudan ayrıntıyı yeniden oku; kapanma/geçmiş durumunu yerel `null` atamasından üretme. |
| 5 | P2 | 2 | `lib/features/meetings/presentation/meeting_hero.dart:120`; `lib/features/meetings/presentation/meeting_page.dart:234` | `observedAt` için yalnız null denetimi var. Saatler önce gözlenen bağlı kişiler hâlâ güncel bağlı kişiler olarak gösteriliyor; silme uyarısı da eski sayıyı kesin bağlantı kesilmesi sayısı olarak kullanıyor. Devirdeki eskilik davranışı uygulanmamış. | Gözlem yaşını değerlendir; eski görüntüyü zamanıyla belirt veya güncel bağlılık iddiasını kaldır. Silme uyarısında da aynı kararı kullan. |
| 6 | P2 | 2 | `lib/features/meetings/presentation/meeting_page.dart:286`; `lib/features/meetings/application/meeting_room_controller.dart:358` | F63 devrindeki snackbar süresince “Geri al” akışı yok. Onay penceresinden sonra kalıcı DELETE hemen gönderiliyor. Mevcut onay diyaloğu, devredilen gecikmeli silme davranışını karşılamıyor. | Notu geçici olarak gizle; geri alma süresi dolunca DELETE gönder, geri alınırsa isteği gönderme. |
| 7 | P2 | 5 | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:104` | Bağlama sunucuda başarılı olup yanıt kaybolursa kayıt `pending` kalıyor. Kullanıcı adı değiştirip tekrar deneyebiliyor; fakat sözleşmeye göre mevcut bağ için `linkDepartment` eski bağı döndürür, adı değiştirmez. Controller dönüşü yok sayıp başarı bildiriyor; girilen yeni ad kaydedilmiyor. | Dönen `DepartmentLink.displayName` değerini karşılaştır; farklıysa `renameDepartmentLink` çağır veya bekleyen işlemde adı sabitle. |
| 8 | P1 | 6 | `lib/features/tasks/application/quick_forms_controller.dart:557`; `lib/features/tasks/presentation/quick_action_sheets.dart:135` | **Önceden mevcut, bu farktan sonra da üretimde kalan sahte başarı:** “Üye ekle” formu yalnız yerel doğrulama yapıp taslağı sıfırlıyor; hiçbir sunucu yazması olmadan “Davet gönderildi” bildiriyor. Koordinatörlük ekranından bu forma ulaşılabiliyor (`coord_people_sheet.dart:47`). | Gerçek davet işlemine bağla; bağlanana kadar gönderme eylemini kapat ve başarı mesajını kaldır. |

### Soru özeti

1. **GEÇER — statik inceleme kapsamında.** `api-pin.json:3`, `lib/core/api/generated/operations.gen.dart:2` ve `error_catalog.gen.dart:2`, `v0.12.0-api` etiketinin çözüldüğü `861beb5e…` commit’iyle tutarlı. İncelenen DTO/serileştirme değişiklikleri sözleşmeyle uyumlu. `collaboration.note_deleted` başvurusu `lib`, `i18n` ve testlerde kalmamış; `ui.*.t_note_deleted` başarı metinleri farklı anahtarlardır.

2. **DÜZELTMEYLE GEÇER.** Temel eşleme doğru: `meetings_api_repository.dart:426` liste alanlarını, `:129` detay alanlarını, `:354` bağlı kişileri, `:466` ekipleri eşliyor. Nullable konferanslar/yer/silen adı korunuyor; silinen kartta özet gösterilmiyor (`meeting_card.dart:53`). Ancak devir bütünüyle karşılanmamış: bulgular 3–6.

3. **DÜZELTMEYLE GEÇER.** Tek sahip departman ve `membersIncluded=false` kuruluş akışında korunuyor (`meeting_form_controller.dart:327`); kişi kipindeki PATCH departmanları ve üye bayrağını göndermiyor (`meetings_planner.dart:49`, `update_meeting_request.g.dart:25`). Yönetim `viewer_role` üzerinden; koordinatörlük kipindeki katılımcı yönetimi istisnası korunmuş (`meeting_board.dart:219`). Konferans başlat/bitir düğmeleri yönetim iznini kullanıyor (`meeting_hero.dart:116`). Kişi havuzu ise bulgu 2 nedeniyle eksik.

4. **GEÇER.** `task_permissions.dart:157`, `:185`, `:193`: yönetici tüm alt görevleri kapatıp açabiliyor, dosya yükleyebiliyor ve yalnız kendi dosyasını silebiliyor. Not yazmadaki yönetici reddi korunuyor (`:146`). Controller ve görünüm bu izinleri kullanıyor.

5. **DÜZELTMEYLE GEÇER.** Şirket yöneticisi görünürlük kapısı doğru (`coordinatorship_form_controller.dart:58`). Tür/açıklama için `updateDepartment`, programdaki ad için `renameDepartmentLink` seçimi doğru (`:139`, `:147`). Hatalar, aynı ad 409 dahil, başarıya çevrilmiyor. Bekleyen işlemde bulgular 1 ve 7 var. Kaldırılan üç menü satırının ilgili metinleri ve özel ikonları temizlenmiş.

6. **GEÇMEZ.** `SampleMeetingExtras` ve kart başına ayrıntı okuması kaldırılmış (`meetings_module.dart:14`, `meeting_card.dart:53`). Buna rağmen bulgu 8 gerçek bir sahte başarı; bulgu 3 de kısmi başarıyı yanlış bildiriyor. Açıkça “yakında” diyen eylemler ayrıca mevcut.

7. **GEÇER — incelenen değişiklikler açısından.** DTO’lar data katmanında kalıyor; açık portlar domain tipleri taşıyor (`department_repository.dart:10`). get_it kayıtları modüllerde, bağlama bileşim kökünde (`coordinatorships_module.dart:19`, `composition.dart:71`). Kanıtlı yeni katman ihlali veya aşırı mühendislik saptamadım; yaşam döngüsü kusuru bulgu 1’de.

### Notlar

- İnceleme `main=280b34a` → `HEAD=80f98d6`, altı commit üzerinde yapıldı. Dosya yazılmadı; test, CI, üretici veya ağ çalıştırılmadı. Bu hüküm CI başarısı ya da yeniden üretimin birebir doğrulanması değildir.
- Bulgular 3 ve 8’deki davranışlar önceden mevcut; kullanıcının “bu farktan sonra kalanlar” sorusu kapsamında raporlandı. Bulgu 6, karşılanmamış F63 devir beklentisidir.
- `department_id/from/to` liste süzgeçleri üretilmiş istemcide bulunmasına rağmen repository bunları dışarı açmıyor (`meetings_api_repository.dart:77`). Süzgeç arayüzünün zorunlu teslim kapsamı net olmadığı için ayrı kusur saymadım.
- `last_conference.id/end_reason` ve `deleted_by.account_id` domain’e taşınmıyor; mevcut görünüm bunları kullanmadığından bu sadeleştirmeyi kusur saymadım.
- Açık yer tutucular: konferansa katılım (`meeting_page.dart:175`), arşiv yükleme (`archive_page.dart:85`) ve koordinatörlük birleştirme (`coordinatorship_page.dart:237`). Birleştirme bildirimi “önizlemesi açılır” diyor, fakat yalnız toast gösteriliyor. Bunlar gerçek başarı olarak değerlendirilmemeli.
- Bilinen `activity` örnek veri istisnası korunuyor.


---

## Tur 2

### Hüküm: GEÇMEZ

`459ab37` main’e giremez: sekiz bulgunun beşi kapanmış, üçü kısmen giderilmiş; gecikmeli silmede kapsam kayması ve kullanıcı eklemede yanlış hesaba aktarım üreten iki yeni kusur var.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| 1 | **KISMEN** | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:77` oturum/program bildirimiyle temizliyor; fakat `:101` yalnız yerel `_epoch` değerini denetliyor. `lib/core/session/session_controller.dart:154` nesli artırıp depo temizliğini bekliyor, durum bildirimini `:159`’da yayımlıyor. Bu aralıkta dönen oluşturma yanıtı `:139` kontrolünü geçip `:142`’de bağlamayı sürdürebilir. Gerçek oturum nesli de doğrudan denetlenmeli. **Test:** `test/features/coordinatorships/application/coordinatorship_form_controller_test.dart:179` çıkışın tamamen bitmesini bekliyor; bu aralığı sınamıyor. |
| 2 | **KAPANDI** | `lib/features/tasks/data/meeting_invitee_api_repository.dart:44` iki okuma isteğini aynı programa sabitliyor; `:74` seçili programdaki rolleri kullanıyor. `lib/features/tasks/application/tasks_providers.dart:100` havuzu kendi ekipleriyle birleştiriyor; kuruluş ve sonradan ekleme bunu tüketiyor. **Test:** `test/features/tasks/data/meeting_invitee_api_repository_test.dart:65` başka koordinatörlükteki kişileri, program başlığını ve programsız adayın elenmesini sınayan test; `:77`, `:89`, `:101` kesilme/hata/yönetici dalları. |
| 3 | **KAPANDI** | `lib/features/meetings/application/meetings_planner.dart:38` başarısız kimlikleri döndürüyor; `lib/features/tasks/application/meeting_form_controller.dart:362` forma taşıyor; `lib/features/tasks/presentation/quick_action_sheets.dart:144` başarılı/başarısız sayıları ayırıyor, `:126` toplantıya erişim sunuyor. **Test:** `test/features/tasks/application/meeting_form_controller_test.dart:90` kısmi sonucu doğruluyor. |
| 4 | **KAPANDI** | `lib/features/meetings/application/meeting_room_controller.dart:490` bitirme sonrasında ayrıntıyı yeniden okuyor; okuma hatasında geçmişi silmek yerine kapanıyor durumunu kullanıyor. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:267` geçmişi ve liste özetini; `:298` yeniden okuma hatasını sınayan testler. |
| 5 | **KISMEN** | `lib/features/meetings/presentation/meeting_hero.dart:117` yaş hesabını yalnız `build` sırasında yapıyor. Taze açılıp üç dakikadan uzun süre değişmeden duran kart kendiliğinden eski duruma geçmiyor; avatarlar ve güncel bağlılık metni kalıyor. `lib/features/meetings/presentation/meeting_page.dart:238` silme uyarısını eylem anında doğru hesaplıyor. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:315` yalnız yaş fonksiyonunu sınayan test; açık ekranın zamanla eskimesini kapsamıyor. Eşik anında yerel yeniden çizim gerekli. |
| 6 | **KISMEN** | `lib/features/meetings/application/meeting_room_controller.dart:392` gecikmeli silmeyi, `:411` geri almayı uyguluyor; `lib/features/meetings/presentation/meeting_page.dart:297` bildirime bağlıyor. Ancak yeni **N1** kapsam kusuru var. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:358` geri alma, hata, yenileme ve ekran kapanmasını kapsıyor; program/oturum değişimini kapsamıyor. |
| 7 | **KAPANDI** | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:148` dönen bağ adını karşılaştırıp `renameDepartmentLink` çağırıyor. **Test:** `test/features/coordinatorships/application/coordinatorship_form_controller_test.dart:207` bağın kurulup yanıtın kaybolmasını ve değiştirilmiş adla tekrarı sınayan test. |
| 8 | **KAPANDI** | Sahte başarı kaldırılmış: `lib/features/tasks/application/invite_form_controller.dart:188` yazmayı bekliyor; `lib/features/tasks/data/task_write_api_repository.dart:357` `createUser` çağırıyor; `lib/features/tasks/presentation/quick_action_sheets.dart:168` yalnız başarılı sonuçta bildirim üretiyor. **Test:** `test/features/tasks/application/invite_form_controller_test.dart:139`, `:212`, `:247`, `:260` başarı/yetki/hata dallarını kapsıyor. Yeni aktarım yarışı ayrıca **N2**’de. |

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| N1 | **P2** | `lib/features/meetings/application/meeting_room_controller.dart:398`, `:427`; `lib/features/meetings/data/meetings_api_repository.dart:300`; `lib/core/http/interceptors.dart:170` | **Bekleyen silmenin programı sabit değil.** A programında not silinir, süre dolmadan B’ye geçilir ve sağlayıcı yeniden kurulur: bekleyen kayıt korunur, fakat saklanan repository program taşımayan singleton’dır. DELETE eski not kimliğiyle **B program başlığını** kullanır. Backend notu program kapsamında aradığı için silme gerçekleşmez; ekran kapanmışsa hata bildirimi de görünmez. Repository referansını saklamak oturum/kurulum kimliğini de sabitlemez. | Bekleyen silmeye başlangıç programını ve oturum/kurulum neslini bağla. DELETE’i açık programla gönder; oturum değişiminde iptal et. A→B ve çıkış/yeniden giriş sırasında bekleyen silme testlerini ekle; başlık ve istek sayısını doğrula. |
| N2 | **P1** | `lib/features/tasks/application/invite_form_controller.dart:129`, `:193`, `:201`; `lib/features/tasks/presentation/quick/invite_form.dart:71` | **Geciken aktarım teklifi başka e-postanın taslağına yazılıyor.** Yönetici A e-postasını gönderirken alanı B olarak değiştirebilir; alanlar `busy` sırasında açık. A’nın 409 yanıtı geldiğinde controller güncel B taslağına A’nın `accountId` değerini ekler. Sonraki gönderim B e-postasıyla A’nın `transfer_account_id` değerini taşır. Pinli backend aktarımda e-posta eşleşmesini doğrulamadan bu kimliğe üyelik yazar (`internal/modules/organization/usecase/users.go:235`, `:247`); sonuç yanlış hesaba üyelik, seçilmişse yöneticilik verilmesidir. | Yanıtı gönderilen taslağın nesline/e-postasına bağla; değişmiş taslağa teklif uygulama. Teklifi kaynak e-postasıyla saklayıp gönderimde eşleştir. Bekletilmiş A yanıtı → B’ye düzenleme → A teklifi senaryosunu test et. |

### Notlar

- İnceleme `80f98d6..459ab37` commit farkına aittir. Çalışma ağacındaki commit dışı üretilmiş API değişiklikleri hükme katılmadı. Dosya yazılmadı; test, CI veya ağ çalıştırılmadı. Yukarıdaki testler **okunan test kaynaklarıdır**, başarılı koşum iddiası değildir.
- `listAssignable` kullanımı yetki ihlali değil: pinli `openapi.yaml:6172` bu programda ilgili departmanın koordinatörüne izin veriyor; `listProgramDepartments` da programda ekip satırı olan hesaba açık (`:5071`). Program dışı kişilerin boş `roles` üzerinden elenmesi sözleşmeyle uyumlu.
- `createUser` rol matrisi doğru uygulanmış: yönetici rol/yöneticilik seçebilir; koordinatör kendi departmanına üye ekler; üye gönderemez. Aktarım teklifinin yalnız yöneticiye verilmesi backend’de `internal/modules/organization/usecase/users.go:290` ile korunuyor. Normal 409 teklif ayrıştırması ve diğer hataların başarıya çevrilmemesi doğru; N2 bu teklifin **hangi taslağa ait olduğuyla** ilgili.
- Önceki #1’in testi, güvenli depo temizliği bekletilirken eski oluşturma yanıtı tamamlanacak şekilde genişletilmeli. `_live` gerçek oturum neslini ve hedef programı kontrol etmeli; yazma sonrası `_reload()` bekleyişinden sonraki dönüş de aynı sahipliğe bağlı olmalı.
- Üç dakikalık eskilik eşiğini ürün tercihi olarak ayrıca kusur saymadım; #5’teki sorun seçilen eşiğin açık ekranda kendiliğinden uygulanmaması.
- Bu hüküm birleşme onayı veya CI yeşilliği kanıtı değildir.


---

## Tur 3

### Hüküm: GEÇER

`7cd3b8c` için incelenen fark önceki açık bulguları kapatıyor; kanıtlı yeni kusur veya gerileme saptamadım, dal zorunlu PR/CI kapıları sağlandığında main’e girebilir.

### Önceki bulgular

| # | durum | kanıt dosya:satır |
|---|---|---|
| N1 | KAPANDI | `lib/features/meetings/application/meeting_room_controller.dart:415` başlangıç programını ve oturum neslini saklıyor; `:448` değişmiş oturumu iptal ediyor; `:457` açık programla siliyor. `lib/features/meetings/data/meetings_api_repository.dart:301` programı isteğe taşıyor. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:434`, `:454` — A→B başlığı ve çıkış/yeniden girişte sıfır DELETE. |
| N2 | KAPANDI | `lib/features/tasks/application/invite_form_controller.dart:63` teklif/e-posta eşleşmesini zorunlu tutuyor; `:188` yalnız eşleşen hesabı gönderiyor; `:197`, `:201`, `:211` eski oturumun veya farklı e-postanın teklifini uygulamıyor. Görünüm de `lib/features/tasks/presentation/quick/invite_form.dart:58` üzerinden doğrulanmış teklifi kullanıyor. **Test:** `test/features/tasks/application/invite_form_controller_test.dart:218` — bekletilmiş A yanıtı, B’ye düzenleme ve sonraki istekte aktarım kimliğinin bulunmaması. |
| 1 | KAPANDI | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:113` gerçek oturum nesli, program ve yerel nesli denetliyor. Oluşturma/bağlama/yeniden adlandırma, düzenleme, hata ve yeniden okuma sonrası dönüşlerde kontrol korunuyor (`:155`, `:163`, `:171`, `:174`, `:208`, `:214`, `:217`, `:220`). **Test:** `test/features/coordinatorships/application/coordinatorship_form_controller_test.dart:220` depo temizliğini bekleterek bildirim öncesi aralığı sınayan test. |
| 2 | KAPANDI | Program genelindeki davet havuzu korunmuş: `lib/features/tasks/data/meeting_invitee_api_repository.dart:45`, `lib/features/tasks/application/tasks_providers.dart:103`. **Test:** `test/features/tasks/data/meeting_invitee_api_repository_test.dart:65`. Bu fark yeniden açmıyor. |
| 3 | KAPANDI | Başarısız katılımcılar `lib/features/meetings/application/meetings_planner.dart:38` → `lib/features/tasks/application/meeting_form_controller.dart:362` üzerinden bildirime ulaşıyor; `lib/features/tasks/presentation/quick_action_sheets.dart:142` sayıları ayırıyor. **Test:** `test/features/tasks/application/meeting_form_controller_test.dart:89`. |
| 4 | KAPANDI | `lib/features/meetings/application/meeting_room_controller.dart:519` bitirme sonrası ayrıntıyı okuyor; `:523` okuma hatasında kapanıyor durumunu koruyor. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:268`, `:299`. |
| 5 | KAPANDI | `lib/features/meetings/presentation/meeting_hero.dart:134` tek seferlik eskime zamanlayıcısını kuruyor; `:141` değişen hedefte eskisini, `:128` kapanışta zamanlayıcıyı iptal ediyor; `:147` mounted denetimi yapıyor. **Test:** `test/features/meetings/presentation/meeting_hero_test.dart:19` açık kartın eskimesini ve taze kartın kapanmasını kapsıyor. |
| 6 | KAPANDI | `lib/features/meetings/application/meeting_room_controller.dart:428`, `:434` gecikmeli silme ve geri almayı koruyor; N1 de kapandı. **Test:** `test/features/meetings/application/meeting_room_controller_test.dart:359`, `:399`, `:413`, `:434`. |
| 7 | KAPANDI | `lib/features/coordinatorships/application/coordinatorship_form_controller.dart:164` mevcut bağın adı farklıysa yeniden adlandırıyor; eklenen nesil kontrolleri bunu bozmuyor. **Test:** `test/features/coordinatorships/application/coordinatorship_form_controller_test.dart:260`. |
| 8 | KAPANDI | `lib/features/tasks/application/invite_form_controller.dart:195` gerçek yazmayı bekliyor; `lib/features/tasks/data/task_write_api_repository.dart:357` `createUser` çağırıyor; `lib/features/tasks/presentation/quick_action_sheets.dart:172` başarısız sonucu bildirmiyor. **Test:** `test/features/tasks/application/invite_form_controller_test.dart:141`, `:296`, `:309`. |

### Yeni bulgular

| # | önem | dosya:satır | bulgu | öneri |
|---|---|---|---|---|
| — | — | — | İncelenen farkta kanıtlı yeni kusur saptanmadı. | — |

### Notlar

- Dal `bakim/v012-birlesim`, HEAD `7cd3b8c`; çalışma ağacı temiz. İnceleme `459ab37..7cd3b8c` arasındaki 15 dosyalık farkı ve ilgili bağımlılıkları kapsıyor.
- Program değişiminde bekleyen silmenin **başlangıç programında tamamlanması**, oturum nesli değişiminde ise **gönderilmeden iptali** açık ve tutarlı uygulanmış. Program değişimini mutlaka iptal sebebi yapmayı gerektiren sözleşme bulmadım.
- Koordinatörlük formunda uçuştaki yazmaların bütün devam yolları gerçek nesli denetliyor. Değişiklik olmayan düzenlemenin erken dönüşünde ağ isteği veya bekleme yok.
- Aktarım koruması ayrı bir taslak revizyon sayacı değil, gönderilen e-posta ve oturum nesli üzerinden çalışıyor. N2’deki farklı e-postaya yanlış hesap aktarımı bununla engellenmiş.
- Eskime zamanlayıcısı üç dakikalık sınıra bir saniye ekliyor. Yeni gözlemde yeniden kuruluyor, gözlem/konferans kalkınca ve kart kapanınca iptal ediliyor. Bu küçük toleransı engelleyici kusur saymadım.
- Test dosyaları **okundu, çalıştırılmadı**. Dosya yazımı, test, CI veya ağ işlemi yapılmadı. Hüküm statik kod incelemesidir; CI yeşilliği veya testlerin geçtiği iddiası değildir.

