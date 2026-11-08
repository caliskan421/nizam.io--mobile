# Birleşim main ← toplantı + F60 + belge (pin v0.11.0-api) — Codex hükümleri

Dal `bakim/main-birlesimi`. Model `gpt-6-astra` (hesapta "6.1 Astra" yok), `-s read-only`, `model_reasoning_effort=medium`; her koşum ≥ 29 gerçek dosya okuması (KAPI m.13). Koordinatör doğruladığı sayıları isteme yazdı (KAPI m.14).

---

## Tur 1 — ara denetim (7079cef..ae2c0a2)

HEAD: ae2c0a2 test fikstürleri: v0.11 zorunlu alanlar (edit_revision, dates_revision) toplantı ve koordinatörlük sunucu taklitlerine eklendi

## Hüküm: DÜZELTMEYLE GEÇER
İki dalın temel davranışları birleşmiş; ancak toplantı notunun eşzamanlı gönderiminde anahtar kaybı ve görev ayrıntısında ekran ömrüyle sınırlı taslak koruması giderilmeli.

İnceleme yalnız `7079cef`, `147f91c`, `ae2c0a2` ve belirtilen ebeveynler üzerindedir; çalışma ağacı kullanılmadı, dosya yazılmadı, test/CI veya ağ çalıştırılmadı. Mobil satırlar `ae2c0a2` ağacına, backend satırları `v0.11.0-api` etiketine aittir.

## Bulgular

| # | önem (yüksek/orta/düşük) | soru | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|
| 1 | yüksek | 3 | `lib/features/meetings/application/meeting_room_controller.dart:259`; `lib/features/meetings/presentation/meeting_notes.dart:45`; `lib/features/meetings/presentation/meeting_page.dart:109` | Kilit yalnız widget’taki `_busy`. A notu gönderilirken sekmeden çıkıp dönmek kilidi sıfırlar; B metni yeni anahtarla gönderilebilir. A’nın geç gelen başarısı, B’nin bekleyen anahtarını koşulsuz siler. B sunucuda yazılıp yanıtı kaybolursa tekrar yeni anahtarla ikinci kayıt oluşturabilir. | Uçuştaki gönderimi controller’da kilitle; anahtarı yalnız tamamlanan isteğin anahtarıyla eşleşiyorsa temizle. |
| 2 | orta | 1 | `lib/features/tasks/application/task_detail_controller.g.dart:56`; `lib/features/tasks/application/task_detail_controller.dart:634`; `lib/features/tasks/presentation/detail/detail_actions.dart:411` | Görev ayrıntısı auto-dispose: sayfa kaldırılınca taslaklar ve belirsiz yazmanın anahtarı kaybolur. Alt sayfa kapanışı da düzenleme/tarih/yükleme taslaklarını temizler. Çakışma sırasında açık form korunuyor, fakat “ekran değişince kaybolmaz” garantisi genel olarak sağlanmıyor. **F60 ebeveyninde de mevcut; birleşimde yeni düşen davranış değil.** | Bekleyen taslak ve işlem anahtarını oturum/görev kapsamında sakla; başarı veya açık vazgeçme ile temizle. |
| 3 | düşük | 5 | `../nizam.io--backend/docs/api/openapi.yaml:1955`; `lib/features/tasks/data/task_catalog_api_repository.dart:346`; `lib/features/scope/data/home_dashboard_api_repository.dart:159` | “Yalnız eski mesaj uçları ve dört hata kodu kalktı” açıklaması doğru değil: zorunlu sürümler, sürümlü yazma gövdeleri ve sohbet özeti var. Eşlemeler birleşimde mevcut. Etiketler arasında katalogdan kaldırılan üst düzey hata kodu sayısı **iki**. | Geçiş açıklamasını gerçek şema ve veri katmanı değişiklikleriyle düzelt. |

## Soru özeti

1. **Kısmen:** sözleşmenin anahtar istediği oluşturmalarda anahtar korunmuş (`lib/features/tasks/data/task_write_api_repository.dart:102,155,220,416`); tek otomatik tekrar yalnız `platform.conflict_retry` içindir, ağ belirsizliğinde kullanıcı aynı anahtarla tekrarlar (`lib/features/tasks/application/task_detail_controller.dart:117,158`). Sürüm/409 paneli korunmuş (`lib/features/tasks/presentation/detail/detail_forms.dart:83`); program bağlamı ve bekleyen tarih isteği korunmuş (`lib/features/tasks/data/task_catalog_api_repository.dart:283,339`). Sessiz birleşim kaybı saptanmadı; ekranlar arası koruma bulgu 2 ile sınırlı.
2. **Sorun yok:** `convertNoteToTask` parametreleri yalnız ProgramScope, CsrfHeader ve PathNoteID; `Idempotency-Key` tanımlı değil (`../nizam.io--backend/docs/api/openapi.yaml:12323`; `lib/features/tasks/application/quick_forms_controller.dart:352`).
3. **Düzeltme gerekli:** normal sıralı kullanımda ağ hatası anahtarı koruyor, başarı/anahtar-çakışması temizliyor; düzenleme `n.editRevision` gönderiyor (`lib/features/meetings/application/meeting_room_controller.dart:262,266,272,284`). Eşzamanlı kullanımda bulgu 1 var; ayrıca sayfadan tamamen çıkışta auto-dispose anahtarın ömrünü bitiriyor (`lib/features/meetings/application/meeting_room_controller.g.dart:140`).
4. **Sorun yok:** F60 çakışma/tekrar anahtarları korunmuş (`i18n/ui/tasks.tr.json:315`). Bilerek silinen 18 görev anahtarı silinmiş kalmış; silinen ARB karşılıklarının tamamı için commit ağacında yapılan `git grep -n` taramasında `lib/` başvurusu yok. Router farkı boş.
5. **Eşlemeler uygun, iddia eksik:** görevde `edit_revision/dates_revision`, görev notu/alt görev/toplantı notunda `edit_revision`, yazmalarda beklenen sürümler eklenmiş; not güncelleme yanıtı da değişmiş (`../nizam.io--backend/docs/api/openapi.yaml:2221,2407,2506,2626,2636`). Karşılıkları mevcut (`lib/features/tasks/data/task_details_api_repository.dart:134,211,265`; `lib/features/meetings/data/meetings_api_repository.dart:274,437`). Chat özeti toplanıyor (`lib/features/scope/data/home_dashboard_api_repository.dart:159`). `/v1/coordinatorships*` yok; kullanılan department/roster şemaları aynı (`lib/features/coordinatorships/data/department_api_repository.dart:39`). Kalkan `collaboration.message_not_found/message_unread` için `lib/` ve `i18n/` başvurusu yok.
6. **Sorun yok:** beş bölmede taşınan davranış korunmuş; örnek moda ait ölü durumlar ayrıca temizlenmiş (`lib/features/tasks/application/task_detail_state.dart:1`; `lib/features/tasks/domain/date_change_request.dart:1`; `lib/features/tasks/presentation/detail/detail_list_option.dart:1`). Tavan listesine giriş eklenmemiş/büyütülmemiş; 600 altına inen toplantı repository testi çıkarılmış (`test/tool/file_size_test.dart:19`).
7. **Sorun yok:** tüketicisiz yeni katman veya soyutlama saptanmadı; `RequestKeys` görev ve toplantı yazmalarında kullanılıyor (`lib/core/domain/request_key.dart:19`; `lib/features/tasks/application/task_detail_controller.dart:165`; `lib/features/meetings/application/meeting_room_controller.dart:262`). `147f91c` dal denetimi (`.github/workflows/ci.yml:37`) ve `ae2c0a2` zorunlu alan fikstürleri (`test/features/coordinatorships/coord_backend.dart:196`; `test/features/meetings/meetings_server.dart:73`) kapsamlarıyla uyumlu.

**Koordinatör kararı:** bulgu 1 → `76b6638` + `7a0f853`; bulgu 2 F60 tasarımı, kapsam dışı (PR açık kalanlar); bulgu 3 PR metninde.

---

## Tur 2 — nihai denetim (HEAD 884cce0)


HEAD: 884cce0 check_coverage: yalnız bildirim içeren dosya lcov'da yokken KAPSAMASIZ sayılmaz (Dart kayıt üretmez)

## Hüküm: GEÇMEZ

Gönderim sürerken değiştirilen toplantı notu taslağı, önceki isteğin başarısıyla silinebiliyor; yenileme üzerinden gönderim kilidi de aşılabiliyor.

Salt okunur kaynak incelemesidir; dosya yazılmadı, test/CI çalıştırılmadı, ağ kullanılmadı. Verilen doğrulama sonuçları kabul edildi.

## Bulgular

| # | önem | eksen | soru | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|---|
| 1 | yüksek | teknik mantık / kullanım kolaylığı | 3 | `lib/features/meetings/presentation/meeting_notes.dart:61`, `:64`, `:113` | A gönderilirken metin alanı düzenlenebilir. Kullanıcı B yazarsa A başarılı olduğunda `_draft.clear()` B’yi de siler. Sonuç tipinin ayrılması bu veri kaybını kapatmıyor; sorun 76b6638 öncesinde de mevcut. | Gönderilen taslak sürümünü yakala; yalnız değişmemiş taslağı temizle veya uçuş sırasında alanı kilitle. Gecikmiş başarı sırasında düzenleme senaryosunu sına. |
| 2 | yüksek | teknik mantık | 3 | `lib/features/meetings/application/meeting_room_controller.dart:167`, `:185`, `:297`, `:330` | Yenileme yeni `MeetingRoom` ile kilidi false yapar; `_noteInFlight` girişte denetlenmez. A sürerken aynı metin tekrar gönderilirse aynı anahtarlı iki uçuş oluşabilir. A’nın bitişi B’nin kilidini açıp ortak anahtarı temizler; B belirsiz düşerse sonraki deneme yeni anahtarla çift kayıt riski taşır. | Uçuş kilidini yeniden okumadan bağımsız tut; istek kimliğini işlem anahtarından ayır. Yenileme + aynı metin + ters tamamlanma sırasını sına. |
| 3 | orta | teknik mantık | 4 | `tool/check_coverage.dart:95`, `:104`, `:144`; `test/tool/check_coverage_test.dart:152` | Regex alanlarla birlikte `const` yapıcıları da siler. `class X { const X(int n) : assert(n > 0); }` muaf sayılır; oysa const olmayan çağrıda doğrulama çalışır. Mevcut negatif test yalnız normal metot gövdesini kapsıyor. | Yapıcıları kesin reddeden dar bir ayrıştırma kullan; sabit alan dışındaki belirsiz biçimleri kapsamasız say. |
| 4 | düşük | mevcut modüllere uyum | 7 | `lib/features/meetings/presentation/meeting_card.dart:143`; `lib/features/coordinatorships/presentation/coord_hero.dart:63` | Sayısal `EdgeInsets` ve `Gap(14)` PR şablonundaki sayısal boşluk yasağına uymuyor. | Tasarım boşluk token’larını kullan. |
| 5 | düşük | aşırı mühendislik / bakım | 5 | `lib/features/coordinatorships/presentation/coord_widgets.dart:7` | `CoordGroup` tüketicisiz: `lib/` sembol taramasında yalnız sınıf ve yapıcı olmak üzere iki başvuru var. | Kullanılmayan sınıfı kaldır. |

## Soru özeti

1. Tablet testleri arama, taslak, seçim ve yığın davranışlarını gerçekten denetliyor. Ancak kaldırılanların hepsi görsel iddia değil: koordinatörlüğün son kaydını koruma beklentisi değişmiş; bunun üretim karşılığı `lib/app/router/split.dart:148` içinde zaten var.
   `test/support/tablet_invariants.dart:203` etiket seçiminde yalnız seçim UI’sini doğruluyor, seçilen kimliği doğrulamıyor. `test/support/tablet_backend.dart:11` mevcut `CoordBackend`’i genişletiyor; gerçek tüketicisi `test/support/tablet_harness.dart:239`, gereksiz ikinci katalog değil.

2. Altı dosya salt test-presence susturma değil: takvim kaynak/katalog birleşimini, activity repository eşleme/kapsam/sayfalamayı, görev listesi süzme/sıralamayı, ayrıntı controller’ı yetki ve yazma gövdesini, timeline yerel geçişleri sınar. `test/core/ui/widgets/nz_alert_icon_test.dart:15` erişilebilirlik davranışıdır; görsel sabit yasağına aykırı değil.
   Sınır: `lib/features/timeline/application/timeline_controller.dart:34` kaydetme ve tarih taleplerinin yalnız bellekte olduğunu açıkça söylüyor; yeni testler sunucuya kalıcılık kanıtı değildir.

3. Farklı anahtarlı A/B yarışında eşleşmeli temizleme doğru (`meeting_room_controller.dart:319`); ağ hatasında anahtar korunuyor, normal hata yolunda kilit açılıyor. Düğme gerçekten kapalı (`meeting_notes.dart:144`); `NoteIgnored` taslak temizletmiyor (`meeting_page.dart:279`). Yenileme/aynı anahtar ve düzenlenen taslak açıkları #1–2’de.
   `NoteSubmit` ölçülü: başarı, hata ve gönderilmeme ayrımını açık taşıyor; bool tek başına hata bilgisini kaybeder. `pendingNoteKey` test gözlem noktası olarak makul.

4. Kaçış değerlendirmeleri çalıştırılmadan, regex akışı üzerinden yapıldı; **true = muaf**, **false = kod**:
   - `class X { static const x = f(); }` → **true**, `tool/check_coverage.dart:95`; normal fonksiyon çağrısı Dart’ta geçersiz const olduğundan derlenebilir kaçış değildir.
   - `class X { const X(); }` ve `const X(int n) : assert(n > 0);` → **true**, `:95–104`; ikincisi geçerli, çalıştırılabilir yapıcı kaçışıdır.
   - `enum E { a; int f() { return 1; } }` → **false**, `:98–104`; enum/metot metni kalır.
   - `extension E on int { int f() { return this; } }` → **false**, `:98–104`; extension silinmez.
   - `int f() => 1;` ve `static IconData get x => Icons.add;` → **false**, `:94`.
   - `class X { late final x = f(); }` → **false**, `:95–104`; alan silinmez. Kural bütünüyle fail-closed değil.

5. `lib/` içinde `inMemory`/`PilotBackend` eşleşmesi yok; fakat örnek kaynaklar tamamen kaldırılmış değil: toplantı ekleri yalnız dev’de (`lib/features/meetings/meetings_module.dart:29`), koordinatörlük profili hâlâ kayıtlı (`lib/features/coordinatorships/coordinatorships_module.dart:21`); arşiv, mesaj, takvim ve etkinlik örnek depoları da sürüyor.
   Boyut listesi ilk eklendiği e259155’e göre yalnız küçülmüş; yeni giriş/tavan artışı yok, çıkarılan girdiler mevcut. Denetim küçük kalan girdileri de reddediyor (`test/tool/file_size_test.dart:65`). Tüketicisiz sınıf #5’te.

6. İncelenen zincirde sorun yok: belirteçler maskeleniyor (`lib/core/logging/log.dart:28`); S2 program, S3 program+departman başlıkları ekleniyor (`lib/core/http/interceptors.dart:170`, `:176`). Toplantı S2 uçlarına departman başlığı gerekmez.
   Hata zarfı `lib/core/errors/api_error.dart:122` üzerinden eşleniyor. Anahtar çağrıları pinli sözleşmedeki uçlarla uyumlu; fazladan uç saptanmadı, elle dosya yükleme de tanımlı uca gidiyor (`lib/core/http/file_upload.dart:38`).

7. `NzPage`/`NzAsyncView` kullanılıyor; controller’da API DTO sızıntısı saptanmadı. Sayısal boşluk ihlalleri #4’te. Üçüncü örnek: `lib/features/meetings/presentation/meeting_page.dart:160` hataları `ref.listenErrors` yerine doğrudan `errorText`+toast ile bildiriyor; mesaj kaybolmuyor ama şablon birebir karşılanmıyor.

## PR'a girecek açık kalanlar

- Görev ayrıntısındaki önceden kabul edilmiş auto-dispose taslak/anahtar kaybı kapsam dışı kaydı korunmalı.
- Yerel yeşil sonuçlar koordinatör kanıtıdır; Linux golden ve dal CI sonucu ayrıca beklenir. `main` kırmızısı dalın kabul kanıtı değildir.
- “Örnek mod kaldırıldı” ifadesi görev/ana veri akışıyla sınırlandırılmalı; kalan örnek depolar ve timeline’ın yerel yazma davranışı açıkça belirtilmeli.
- Tablet testindeki koordinatörlük dönüş beklentisinin görsel temizlik değil, mevcut üretim gezinme kuralına uyarlama olduğu PR’da yazılmalı.

**Koordinatör kararı:** B1–B5 tek Opus turunda; ardından tur 3.

---

## Tur 3 — düzeltme sonrası

HEAD: fb41185 check_coverage: belge yorumunda açılı ayraç ters tırnak içinde (analyze bilgi uyarısı)

## Hüküm: DÜZELTMEYLE GEÇER
B1–B5’in bildirilen sorunları giderilmiş; B2’de kilidin bütün istisna yollarında bırakılması için temizliğin `finally` ile güvenceye alınması gerekiyor.

## Bulgular

| # | önem | soru | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|
| 1 | düşük | 2c | lib/features/meetings/application/meeting_room_controller.dart:306 | Kilit alındıktan sonraki `_put(r)` try dışında; catch içinde hata dönüştürme de kilit bırakılmadan yapılıyor. Repository başarısı/hatası kapsanıyor, fakat bu yardımcı işlemler throw ederse kilidin kapanması garanti değil. | Kilit alındıktan sonraki işlemleri try içine al; kimlik denetimli kilit bırakmayı finally’ye taşı. |

## Soru özeti

1. **B1 kapalı.** A→B değişiminde B korunur; A→B→A dönüşünde temizlenir; başarısızlıkta taslak korunur (`lib/features/meetings/presentation/meeting_notes.dart:61`, `:64`, `:66`).  
   Karşılaştırma ham metin↔ham metindir; controller trim’i bunu bozmaz (`lib/features/meetings/application/meeting_room_controller.dart:298`). Hata bildirimi ve false dönüşü mevcut (`lib/features/meetings/presentation/meeting_page.dart:276`).

2. **B2’nin yenileme yarışı kapalı.** Anahtar String, uçuş kimliği ayrı Object; giriş kilidi ve kimlikli bırakma doğru (`lib/features/meetings/application/meeting_room_controller.dart:300`, `:305`, `:326`, `:334`).  
   Yenilemede build ve `_put` kilit alanını okuyor (`:178`, `:198`); widget kurulumu alanı sıfırlamaz. Auto-dispose sonrası yeni controller boş anahtar/kilitle başlar, yeni UI’da eski pending taşınmaz (`:144`, `:291`; `lib/features/meetings/application/meeting_room_controller.g.dart:140`, `:157`). Normal başarı/hata kapanır; **finally yok**, yukarıdaki bulgu geçerli.

3. **B3’ün sorulan kaçışları kapalı.** Akış satır bazlı değil, bütün kaynak üzerindedir (`tool/check_coverage.dart:94`).
   - `class X { static const x = Y(); }`: alan `:97`, başlık `:102`, kapanış `:108` ile silinir → **muaf**; bu yapıcı bildirimi değil, const çağrıdır.
   - Çok satırlı `static const List<int> xs = [1, 2,\n 3];`: `[^;]*` satır sonunu da kapsar (`:97`); ikinci satır ayrı sınıflanmaz → **muaf**.
   - `static const x = 1; static int f() => 1;`: `=>` kontrolü alan silinmeden false döndürür (`:95`) → **kod**.
   - `abstract final class X {}`: başlık ve kapanış gider (`:102`, `:108`) → **muaf**.
   - `part of` / `library`: satır başındaki yönerge silinir (`:80`), yalnız yönergeli dosya atlanır (`:148`) → **muaf**.
   - `@immutable`: silinmez (`:97`, `:102`, `:108`) → **kod**.
   - `typedef A = int;` ve top-level `const x = 1;`: static const desenine girmez (`:97`, `:108`) → **kod**; dar muafiyet kuralının ihtiyatlı sonucu.
   - Gerçek ikon alanları tek satırlıdır (`lib/core/ui/widgets/nz_icons.dart:8`–`:100`); mevcut test ayrıca çok satırlı alanı içerir (`test/tool/check_coverage_test.dart:142`).

4. **B4/B5 kapalı.** Değerler birebir 14/16/20 (`lib/core/theme/generated/tokens.gen.dart:665`, `:677`, `:678`); kullanımlar doğru (`lib/features/meetings/presentation/meeting_card.dart:143`; `lib/features/coordinatorships/presentation/coord_hero.dart:63`).  
   `CoordGroup` başvurusu kalmamış; dosya ve kullanılan CoordRow/CoordLink korunmuş, üç import da hâlâ kullanılıyor; export/part kırığı görülmedi (`lib/features/coordinatorships/presentation/coord_widgets.dart:1`, `:7`, `:67`).

5. **Altı commit’in stat ve patch’lerinde kapsam dışı değişiklik görülmedi.** Controller hash’i aynı `0c754e8` commit’inde güncellenmiş (`lib/features/meetings/application/meeting_room_controller.g.dart:170`).  
   Dosya yazılmadı; test/CI/ağ çalıştırılmadı. Verilen yeşil sonuçlar kabul edildi; devam eden tam verify için tamamlandı hükmü verilmedi.

**Koordinatör kararı:** bulgu 1 (düşük) son commit'te `finally` ile kapatıldı (`7da169f`); delta kapıları yeşil. Tam yerel tanık (HEAD fb41185): 2058 test, kapsama 5/5 eşik üstü, gen-check temiz. Canlı entegrasyon ağır iş kilidi nedeniyle yerelde koşulamadı; CI `integration` işi canlı kapıdır.

