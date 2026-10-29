# Tablet tasarımı (2026-10-29)

Tek kaynak: [`docs/design/tablet/12-Tablet.dc.html`](../design/tablet/12-Tablet.dc.html)
(artboard 1180×820), `ds/roketportal/tokens.css`, `components/bundle.css`, marka SVG
(`assets/7a16…svg`). Kaynak salt okunurdur. Bağımsız kullanıcı işi; program fazı değildir,
backend bağlantısı yoktur (örnek veri). Responsive altyapı:
[responsive-altyapi.md](responsive-altyapi.md), karar: ADR-0003 karar 25.

## 1. Kaynak envanteri

### Kabuk (`Component extends PhoneHost`, satır 3796–3863)

| Parça | Kaynak | Ölçü / davranış |
|---|---|---|
| Artboard | satır 77 | 1180×820, `bg-base`, `display:flex` |
| Giriş | satır 79–129 | `isLogin`: ray yok; ortada 420 genişlik, `overflow-y:auto`; içerik `padding 96 24 40`, `gap 40`; logo 44, başlık 30/36 |
| Ray | satır 133–140, `RAIL` 3852 | 100 genişlik (border-box), `padding 20 0`, `gap 4`, sağda 1 px `border-subtle`; logo 36 + alt 18; 6 modül: Ana sayfa, Görevler, Takvim, Koordinatörlükler, Arşiv, Mesajlar. Öğe 96 genişlik, `padding 7 0`, kapsül 60×34 tam yuvarlak (etkin `rgba(255,255,255,.13)` = `nav-highlight`, .35 s), ikon 20 (etkin `accent-text`), `gap 5`, etiket 10.5/13, 600/500, `-0.01em`, en çok 94 (… ile). Mesajlar rozeti `t-badge--count` (accent, üst −3 sağ 10, 2 px `bg-base` halka; sayı = `unread || mention` sohbet). Altta boşluk, zil 44 (7 px `danger` nokta, üst 10 sağ 11), "Tüm modüller" 44 cam daire, asistan 56 cam daire (+8 üst, ikon 24, `#c8f53c`) |
| Liste bölmesi | satır 144 | `notFull` iken; 390 + 1 px sağ kenar (box-sizing yok → sağ bölme 689), bağımsız kaydırma, kaydırma çubuğu gizli |
| Ayrıntı bölmesi | satır 633 | kalan genişlik, bağımsız kaydırma; `data-canback = rs.length > 1` |
| Bölme kuralları | satır 64–75 | `.tb-pane`: marka logolu kök `header` gizli, içerik üstten 18; sayfa sonu 40. `.tb-rpane`: içerik yanları 28, `header` ve yapışkan şerit −28 taşar, `header` yanları 20, yapışkan şerit 28. `[data-canback=false] [aria-label^="Geri"]` gizli |
| Merkezi modal | satır 73–74 | `[role=dialog][aria-modal]:not(aside)`: ortalı, `min(560, 100%−48)`, `max-height 100%−64`, köşe 28, 1 px `border-strong`; açılış `rpSheetUp` |
| Yan menü | satır 1717–1742 | sağdan 318, `bg-surface`, sol köşeler 28 (mobil çekmeceyle aynı) |
| Zaman çizelgesi | satır 1479–1552 | `full='gantt'`: liste+ayrıntı yerine tam genişlik bölüm; **ray kalır** (`nav` `notFull` dışında) |
| Bildirim (toast) | satır 1743 | `fixed`, `top 740` (artboard), ortalı |

### Ekranlar

| Bölme | Ekranlar (`scr_*`) | Varsayılan (`TB_DEF`) |
|---|---|---|
| Sol (L) | `home`, `tasks`, `calendar`, `coord`, `archive`, `messages` (+ `login` tam ekran) | — |
| Sağ (R) | `history`, `detail`, `cdetail`, `afolder`, `chat`, `empty` ("Bir kayıt seç") | home → history; tasks → detail `ALT-5`; calendar → empty; coord → cdetail `ALT`; archive → afolder `ALT`; messages → chat `koord` |
| Tam | `gantt` (yatay zaman çizelgesi) | — |
| Örtü | hızlı işlem sayfaları (yeni görev / toplantı / davet, `hs`, her ekrandan), çekmece, ekran içi alt sayfalar (tabletse merkezi modal) | — |

### Etkileşim (`tgo` / `tback`)

- Ray modülü ≠ geçerli: `mod` değişir, `rs = [TB_DEF[mod]]`, iki bölme kaydırması 0, çekmece ve
  tam ekran kapanır (sekme yığını **korunmaz**).
- Ray modülü = geçerli: tam ekran açıksa kapanır; `rs.length > 1` ise `rs = [TB_DEF]` (pop);
  aksi hâlde bir şey olmaz (telefondaki kısayol menüsü yok).
- Sağ ekran (ör. `detail`) yığının **sonundaysa** (aynı modülde başka kayıt seçimi): sağ bölme
  solup yeniden açılır, kaydırma 0 — yığın büyümez, "Geri" çıkmaz.
- Sağ ekran yığında daha gerideyse oraya pop; yoksa itilir (`cdetail → afolder`, `history →
  detail` gibi modüller arası) ve "Geri" görünür. `tback` yalnız sağ yığını geri alır.
- `gantt` → `full`; `closeGantt` geri döner; çizelgeden görev → `mod=tasks`, `rs=['detail']`.
- Asistan → "Asistan tablette sonraki adımda tasarlanacak" bildirimi; zil bilgi.

### Mobil ile farklar

Ray (alt menü yerine; 3 değil 6 modül + zil/menü/asistan rayda), kök üst çubuk listede gizli,
listede seçim sağ bölmeyi değiştirir, sohbet ve ayrıntılar tam ekran yerine sağ bölmede,
zaman çizelgesi ray yanında tam genişlik, ekran içi alt sayfalar merkezi modal, giriş 420 ortalı.
Liste kayıtlarında seçim vurgusu **yok** (kaynakta `aria-current` yalnız rayda).

## 2. Uygulama sırası

1. **Tur 1 (tamam):** kabuk, ray, çift bölme, gezinme entegrasyonu, bölme kuralları.
2. **Tur 2 (bu tur):** modüller arası sağ yığın, takvim ve yatay çizelge bağlantısı, kaynak SVG
   ikon uyarlayıcısı (`path_drawing`), gerçek marka logosu, tablet girişi, merkezi modal, sağ
   bölme hareketi, sabit kaynak renkleri, sayfa bölme yardımcıları, ADR-0003 karar 26.
3. **Sonra:** koordinatörün iPad 13" görsel karşılaştırması ve kalan piksel farkları (§7).

## 3. Mimari (tur 2 sonu)

Feature-first MVVM, get_it, Riverpod, go_router korunur; ikinci gezinme çerçevesi, global
servis, ikinci veri yolu, `extra` yoktur. Karar: [ADR-0003 karar 26](../architecture/adr-0003-ui-temeli.md).

| Konu | Uygulama |
|---|---|
| Eşikler | < 600 telefon (3 öğeli alt menü, değişmez) · 600–839 ray + tek bölme · ≥ 840 ray + liste + ayrıntı. Kaynağın tablet görsel kuralları (SVG ikon uyarlaması, merkezi modal, 420 giriş) `NzTabletMetrics.tabletVisualAt` = ≥ 840. |
| Rota | Aynı 3 dallı `StatefulShellRoute`. Ek: `/messages/:id` (tablet sohbet), `/calendar` (modül dalı; telefonda 3. sekme modülü). Bütün kabuk rotaları yalnız kimlik taşıyan `trail` sorgusu alır. |
| Sol modül | Yoldan (`railModuleOf`). Liste sayfası `MasterKeys` ile telefonda dal kökünde, tablette sol bölmede (aynı State). |
| Sağ yığın | Taban (yolun kaydı; modül kökünde son açılan, ilk açılışta `TB_DEF`) + iz (`?trail=folder:ALT&trail=task:ALT-5`). `splitMove` = prototip `tgo`: en üstte aynı kayıt → yenile (solup açılır, yeni State, konum aynı); en üstte aynı tür → yerinde değişir; geride aynı tür → oraya döner; yoksa itilir. Taban türü (`/tasks/X`, `/coordinatorships/X` …) yol değiştirir, iz düşer. Geri (`splitBack`, üst çubuk "Geri", sistem geri) izi kısaltır. |
| Çizim | `PaneStack` (split.dart): taban + iz katmanları; yalnız en üstteki görünür, alttakiler State'iyle bekler (prototip alt ekranları kalıcı). Her genişlikte aynı çizilir: daralıp genişlemede aynı görev/sohbet State'i ve iz korunur. |
| Niyetler | Çift bölmede `_SplitAppNav`: `openTask`, `openCoordinatorship`, `openArchiveFolder`, `openChat`, `openHistory` sağ yığını değiştirir (sol liste sabit); `openHome/Tasks/Calendar/Coordinatorships/Archive/Messages` modül köküne; `openTimeline` tam ekran çizelge. Tek bölme ve telefonda `GoRouterAppNav` (eski davranış). Yeni niyet: `NzAppNav.openCalendar`. |
| Ray | `AppTabletRail` (kabuk ve çizelge ortak): başka modül → kök; aynı modül → iz varsa tabana; tek bölmede kısayol olayı. Takvim gerçek modül. Zil kaynakta işleyicisiz (yalnız etiket); asistan kaynak bildirimi. |
| Takvim | `CalendarPage` (sol) + `CalendarEmptyDetail` (sağ, "Bir kayıt seç"); `registerCalendarModule` / `calendarOverrides` bileşim kökünde. "Seçili güne toplantı planla" → `showMeetingSheet(date:)` (aynı `MeetingFormController.prepare(date:)`). Çekmecede Takvim modülü açar. |
| Çizelge | `/timeline` `TimelineHost`: telefonda dikey `TimelinePage`; ray genişliğinde ray + `HorizontalTimelinePage` (liste/ayrıntı gizli). Raydaki etkin modül çizelgenin altındaki kabuk konumundan. Geri / aynı modül → `pop` (önceki modül ve sağ yığın); doğrudan bağlantıda `/tasks`. Çizelgeden görev → `go(/tasks/:code)` (geri çizelgeye dönmez). |
| Bölme bağlamı | `NzPaneScope` (rol, `canBack`, `onBack`), `sideInset` (sağda 28), `pageBottom` (bölmede 40). `NzPage.feed`, `NzTopBar.detail`, sohbet başlığı ve koordinatörlük ayrıntısı (`NzPage.fill` gövdesi) kullanır. |
| Hareket | `NzPaneTransition` (core/motion): solma .3 s ease; itme/geri 36 px .38 s `cubic(.2,.8,.2,1)`. Modül değişiminde sol liste ve sağ taban solar; iz itme/geri; aynı kaydı yeniden seçme solar. İçteki `PageContentEntrance` üst hareketi görür, çift animasyon yok; hareketi azalt → anlık; telefonda kapalı (yapı sabit). |
| Modal | `NzBottomSheet.show` ≥ 840'ta `showGeneralDialog` + standart `Dialog`: `min(560, W−48)`, en çok `H−64`, 28 köşe, 1 px `border-strong`, `scrim`, `rpSheetUp .42s`. Klavye payını Dialog verir; form durumu aynı içerik bileşeninde. Telefonda alttan sayfa. Çekmece (`NzSideSheet`) kök gezginde 318, rayı da örter (kaynakla aynı). |
| İkon | `NzIcon` (core): ≥ 840'ta Material `IconData`'nın kaynak karşılığı (`NzIconPaths.material`) `NzPathIcon` ile; telefonda birebir `Icon`. Kit ve sunum dosyalarındaki `Icon(` çağrıları `NzIcon(`. Yol ayrıştırma `path_drawing` `parseSvgPathData` (önbellekli). |
| Marka | `NzLogo`: kaynak SVG (32 viewBox, rx 10 `#d8f866 → #c8f53c`, `translate(6 6) scale(.8333)` roket, 2 px `#0b0b0b`). Tablet rayı (36) ve tablet girişi (44); telefon `NzBrandMark` değişmez. |
| Sabit renk | `NzFixedColors` (core/ui/theme): ray vurgusu `rgba(255,255,255,.13)`, koyu cam menü/asistan, logo — iki temada aynı, değer `NizamioColors.dark` token'ından. |
| Giriş | ≥ 840: ortada 420 (`NzContentWidth.login`), dolgu 96 / 24 / 40, bloklar 40, logo 44, giriş metni 15/22, alt satır "Developed by …" mono 11/16 · %70. Metinler kaynakla: "Şifre", "Şifren", "E-posta adresin ve şifrenle devam et.", "Şifreyi göster/gizle". |
| Ana sayfa tarihi | Selamlama tarihi ve "son işlem" göreli zamanı görev kataloğunun `today`'i (örnek çapa 21 Ekim); örnek ana sayfa deposu varsayılanı aynı çapa. |

## 4. Son entegrasyon (tur 3, 2026-10-29) ve kanıt

Feature ajanları bittikten sonra paylaşılan ağaçta `make gen` çalıştırıldı (elle yazılmış geçici
üretilmiş dosyalar yeniden üretildi). Font ajanının yalıtılmış yaması
(`/tmp/nizamio-tablet-font-fix/font-fix.patch`) kayma kontrolünden sonra uygulandı.

| Konu | Uygulama |
|---|---|
| Yeniden seçim | Kaynak yükleyicilerine göre tür bazlı (`paneReselectReloads`): sohbet (`S_chat.load` taslak/yanıt/düzenlemeyi koşulsuz sıfırlar), koordinatörlük ayrıntısı ve klasör (`openCDetail`/`openAFolder`) → ekran yeniden kurulur; görev ayrıntısı (`S_detail.load` aynı kimlikte döner) ve geçmiş → State korunur, kaydırma başa (`scrollTop = 0`) ve küçük solma. Genişlik/yön değişimi hiçbirini yeniden yüklemez (taslak kalır). Farklı kimlik → yeni ekran (sayfalar kimlikle anahtarlı). |
| Kök varsayılan | Kök sayfa üstünde kayıt sayfası varken varsayılan ayrıntıyı kurmaz (aynı sohbetin ikinci kopyası ve açılış yan etkisi yok). |
| Modal hareketi | `PageRouteBuilder` + `Dialog` (yalnız yerleşim) içinde `SlideTransition`: kayma modalın kendi boyu kadar (`translateY(100%)`), açılış .42 s `easeSheet`, kapanış .24 s `easeExit`. Takvim önizlemesi `actionsDivider: false` (kaynakta çizgi yok). |
| Örnek içerik | Kişi adları/e-posta kimlik bazlı kaynak `RP_PEOPLE` ile hizalandı (örnek fikstür notları güncellendi; gerçek hesap kaydı değil). `koord` sohbeti kaynak kurucusundan sonraki durumla başlar: okunmuş, anma yok, ayırıcı son mesajda (ray rozeti 4; gerçek okuma komutu aynı). Ekip satırı 18 (`TeamTotals.userCount`), KPI alt yazıları Türkçe iyelik ekiyle ("79 görevin 39'u bitti", "Açık görevlerin %38'i"). Baş harf kuralı kaynak `ini`: ilk iki sözcük ("MY"). |
| Çekmece (tablet) | Üst 52 / alt 28; "takip" yalnız Ana sayfa · Görevler · Takvim; hesap avatarı `rp-av` 44/15 `bg-overlay`; kapat 36 `bg-overlay` daire; örnek kipte sezon kartı fikstürden "Şanlıurfa Teknofest · 2026 sezonu" (`HomeDashboard.demoProgram*`; gerçek kapsam önceliklidir). |
| Ürün adı/sürüm | `displayBrand(flavor)`: dev (prototip/demo) giriş ve çekmece alt satırında "RoketPortal" / "v2.0"; prod ARB adı ve gerçek `appVersion`. Paket kimliği ve sürüm meta verisi değişmedi. |
| Görevler (tablet) | Görünüm kutucuğu sayı 22/26, etiket 11/14 tek satır; kutucuk–başlık 20, başlık–kart 12; görev kartı border-box (kenar + 16), başlık satırı 20, tarih satırı 58 (kicker 10/16, tarih 12/20), atanan satırı 26 (halka yerleşime girmez): kart x116 · y384 · w358 · h196 (kaynak DOM ile aynı). Ayrıntıda sekme şeridi `margin-top: -6px`. |
| Yazı tipi | `pubspec fonts:` mantıksal aileler (Inter 400/500/600/700, Poppins 500/600, Geist Mono 400/500); `NzTextStyles` normal ağırlık çözümlemesi. Testlerde `test/flutter_test_config.dart` uygulama yazı tiplerini bir kez yükler (eski google_fonts yan etkisinin yerine) ve düz testler için `HttpOverrides`'ı geri koyar. |

Kanıt (paylaşılan ağaç, 2026-10-29): `make gen` temiz; `dart format --set-exit-if-changed lib test`
0 fark; `flutter analyze --fatal-infos` sorun yok; `tool/check_boundaries.dart` 489 dosya ihlal yok;
`tool/check_test_presence.dart` eksik yok; `flutter test test --exclude-tags golden` **1628 geçti,
3 kırmızı** (§5). Golden (Linux), tam `make verify`, native derleme ve simülatör koşulmadı.
Host görüntüleri: `/tmp/nizamio-r3-shots/*.png`.

## 4a. Tur 4 (2026-10-29)

| Konu | Uygulama |
|---|---|
| Sohbet akışı | Liste yukarıdan aşağı (tembel `CustomScrollView`, `reverse` yok); "Bugün" y≈84, k1 y126 h≈103, k2 y≈281. Sona yapışma `_pinned` (sonda 80 px içinde) + ölçü değişiminde kare sonrası `maxScrollExtent`; aşağı düğmesi ve yeni mesaj aynı ölçüyü kullanır. |
| Balon | Kısa balon içerik genişliğinde (`IntrinsicWidth`), uzun en çok %80; ad 13/20 600, rol 11/20 soluk (taban çizgisi), gövde 15/21, saat sağ altta Geist 11/20 `margin-top: -2`, aralık 4. |
| Gelen kutusu | Satır x108 · y120 · w374 · h≈71 (kaynak 71.5), avatar x116 (`margin: 0 -8px` → `NzHorizontalBleed`, `LayoutBuilder` yok); ad 15/20, saat Geist 11/20; avatar paleti satır sırasına göre `avatar1..5` (kişi renkleri genelde değişmedi). |
| Yazma alanı | Sohbet ataç simgesi; dolgu 8/10/6. Başlık en az 56. |
| Koord işareti | Açılış sessiz yükleme: ayırıcı k2, okunmamış 0, ray rozeti 4; ilk ray girişi yeniden yüklemez (işaret kalır); aynı satır yeniden seçimi yükler (işaret ve taslak gider); boyut değişimi hiçbir şeyi değiştirmez. |
| Ana sayfa | KPI 150 (136–286, 296–446), hızlı eylem 90 (496–586), rol kartları 88 (636–724); "Tümü" kutucuğu 175 (ızgara: `(w − 3·8)/4`). |
| Yeni görev | Başlık alt çizgi; "Seç" accent; öncelik kapsül (iç dolgu 2, düğme 30). |
| Koordinatörlük | Örnek profiller kaynağın `D` raporunu taşır (`CoordinatorshipReport`): ALT 5 açık / %58 / 12 görev, sezon %41; gerçek veride hesap aynı. |
| Geçmiş | Tablette başlık yapışkan değil (`NzTopBar.pinned`). |
| Karartma | İleri .3 s, geri .24 s (ayrı `FadeTransition`). |
| Sohbet yeniden açma (düzeltme) | `ChatController.open()` yazma görünüm durumunu (yanıt, düzenleme, atıflar, ek paneli/arama, sabit sırası, cihaz sayacı) koşulsuz sıfırlar; gelen kutusu satırı basılınca, gezinmeden önce çağrılır (kaynak `S_chat.load`). Ekranın yeniden kurulması tek başına yetmiyordu: aynı aile sağlayıcısı aynı karede dinlendiği için otomatik atılmıyordu. Ray girişi ve boyut değişimi çağırmaz. |

Kanıt (tur 4): `flutter test test/app test/core/ui test/features/{messages,coordinatorships,scope,tasks,activity}`
**949 geçti, 26 atlandı, 1 kırmızı** (§5); `dart format --set-exit-if-changed lib test` 0 fark;
`flutter analyze --fatal-infos` sorun yok. Tam test takımı, golden, `make verify`, native koşulmadı.
Host görüntüleri: `/tmp/nizamio-r4-shots/*.png`.

## 5. Sonnet düzeneği kırmızıları (düzenek dosyalarına dokunulmadı)

`AYNI sohbette resize/dönüş…` yalnız 820×1180 adımında: `expectUnreadDivider` (`tablet_harness.dart:781`)
`inPane(NzPaneRole.detail, …)` arar; 600–839 tek bölmede `NzPaneScope.role` tasarım gereği null
olduğundan bulucu boş döner. Davranış doğrulandı (geçici test, silindi): dört boyutta da ayırıcı
1 adet ekranda, taslak "Resize taslağı", `TextEditingController` aynı nesne. Bulucu tek bölmede
kapsamsız (ya da `role == null` bölmesiyle) aranmalı.

Önceki turun `.first` bulucu notu düzeltildi (`messages`, `chat-same-reselect…` geçiyor). Bu turda
düzenek iki üretim düzeltmesi gerektirdi: `NzChatRow` `Semantics(container: true)` (satır dikdörtgeni
108) ve rol kartı etiketi "$n $rol. …". Önceki sürümde boyut değişiminde görülen
"dirty widget in the wrong build scope" hatası (tembel listede `LayoutBuilder` + `OverflowBox`)
`NzHorizontalBleed` ile giderildi.

Yazı tipi yükleme yardımcısı: `test/support/golden.dart` `loadAppFonts()` (artık
`test/flutter_test_config.dart` ile her test dosyasında otomatik); düzenekte ek çağrı gerekmez.

## 6. Kalan farklar

1. 600–839 kaynakta tanımsız: ray + tek bölme, telefon görselleri.
2. Profil ve doğrudan `/chat/:id` tablette tam ekran.
3. Golden referansları yazı tipi ve tur 3–4 görsel değişimleriyle Linux'ta yeniden üretilmeli
   (`golden-update`); bu turda golden koşulmadı.
4. Gelen kutusu satırı 70.6 (kaynak 71.5; ölçü toleransı içinde, alt çizgi yazı satırı yuvarlaması).
5. Gelen kutusu satırının taşan 8 px kenarları dokunmayı almaz (üst kutular kendi sınırı dışındaki noktayı
   eler); görsel konum kaynakla aynı.
6. Native iPad 13" / iPadOS 26.3 simülatör karşılaştırması ve tam yerel doğrulama yapılmadı.

## 7. Commit ve manuel test teslimi — 29 Ekim 2026

Bu bölüm önceki turlardaki doğrulama durumlarını günceller. Sonnet 5.5 ile host
koşumunda 231 test, iPad Pro 13 simülatöründe 44 test geçti (16 davranış senaryosu,
14 ekranın koyu/açık tema görüntüleri). Native mantıksal boyut 1376×1032, DPR 2,
üst güvenli alan 32, alt 20 puandır; klavye açık sahnelerde alanlar değişir.
Bu sonuçlar son küçük görsel düzeltme turundan öncedir; son ağacın tamamının
aynı testlerden geçtiği anlamına gelmez.

Ürün sahibi otomatik testler yerine uygulamayı kendisinin denemek istedi.
Dev giriş noktası hem iPad Pro 13 hem iPhone 17 üzerinde derlendi, ana sayfa açıldı
ve uygulamalar çalışır bırakıldı. Testler ve arka plandaki uygulayıcı durduruldu.
Son küçük turda mesaj filtreleri, koordinatörlük listesi ve örnek katalog üzerinde
yapılmış değişiklikler korunmuştur; tamamlanmış nihai parite incelemesi sayılmaz.

Commit öncesi Dart biçim kontrolü ve flutter analyze --fatal-infos geçti.
Tam yerel make verify, Linux golden yenilemesi ve Fable'ın nihai kalite incelemesi
henüz tamamlanmadı. Birebir görsel eşlik için nihai onay verilmiş değildir.
Ürün sahibinin açık talebiyle yalnız mobil depo, mevcut
codex/mobile-tablet-design dalında commitlenip pushlanır; main'e birleştirilmez.
