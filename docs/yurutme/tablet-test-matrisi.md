# Tablet test matrisi (2026-10-29) — HAZIRLIK, salt okunur envanter

Dal `codex/mobile-tablet-design`. Bu belge **test planıdır**; hiçbir test yazılmadı ya da koşulmadı
(Opus tablet kodunu yazarken `flutter test/build` başlatılmadı). Kaynaklar: `docs/design/tablet/12-Tablet.dc.html`
(+ `README.md`, `ds/roketportal/*`), koordinatör CUA referansı `/tmp/nizamio-tablet-reference/*.{jpg,ax.txt}`
(1180×820), `docs/yurutme/responsive-altyapi.md`, ADR-0003, `lib/` ve `test/` bugünkü hâli.
Sonraki aşamada Sonnet bu matristen test yazar; üretim koduna dokunmaz.

Durum sütunu: **VAR** = bu mekanizmanın mobil testi mevcut (kopyalanmaz, yalnız tablet bileşimi için ek
senaryo gerekir) · **KISMEN** · **YOK** = kod ya da test henüz yok (açıkça işaretli) · **KAPSAM DIŞI** = kaynak görünür UI'sinde yok (CAL-12) · **KIRILIR** = bugünkü test,
tablet tasarımı uygulanınca bilerek değişmeli (güncelle, silme).
Katman: **W** = host `testWidgets` (1180×820 dışı ekran, dpr 1) · **I** = gerçek iPad simülatörü integration · **G** = görsel kapı.

## 1. Gözlemlenen önemli uyuşmazlıklar (kod ↔ prototip) — testten önce bilinmeli

| # | Bulgu | Etki |
|---|---|---|
| U1 | Prototipte ray **6 öğe** (Ana sayfa, Görevler, Takvim, Koordinatörlükler, Arşiv, Mesajlar[rozet 4]) + alt blokta Bildirimler, "Tüm modüller" (sağdan çekmece), "Asistana sor". Bugünkü `NzAdaptiveShell` **3 dal** (Ana sayfa, Görevler, son modül) ve `NavigationRail`; `routes.dart`'ta `/calendar` yok. | `router_scoped_test.dart` `medium: NavigationRail…`, `expanded: genişletilmiş ray`, `sekme sayısı dal sayısıyla aynıdır`, `üçüncü öğe son girilen modüldür`, `shell_resize_test` ray beklentileri **KIRILIR/güncellenir**. |
| U2 | **Takvim sayfası, rotası, denetleyicisi, örnek verisi yok.** Yalnız `core/ui/widgets/inputs/nz_range_calendar.dart` (aralık seçici, form içi) ve `new_task_form`/`meeting_form`/`quick_forms_controller` içinde tarih kullanımı. | Bütün CAL-* senaryoları YOK. Önce sözleşme: kayıt türleri (toplantı, talep, tablo kaydı, görev) ve gün başına sayı. |
| U3 | **Mevcut Gantt DİKEY zaman eksenlidir**: `timeline_chart.dart:14` "Dikey Gantt gövdesi"; `timeline_layout.dart` `TimelineGeometry.topPad` (:13), `dateColumn` (:16), `yOf(day)=topPad+day*ppd` (:121/:253), `todayY` (:256) → zaman Y'dedir. `Axis.horizontal` (`timeline_chart.dart:234`) yalnız çapraz kaydırmadır, yatay zaman ekseni kanıtı **değil**. Prototipin yatay çizelgesi (HTML 1479–1552: `G.TW` toplam genişlik, sol sütun `G.LW` yapışkan, 52 px yapışkan ay/gün başlığı, satır = görev) için **yeni tablet yatay chart gerekir (Opus)**. Prototip ölçek Hafta/Ay/Sezon, süzgeç Tümü/Açık/Geciken·15, üstte koordinatörlük çip şeridi (Tümü + 11); mevcut `TimelineScale day/week/month`, `all/open/late/done`, alt sayfa menüsü. | Mevcut timeline testleri dikey chart'ı sınar; yatay chart için **kopyalanmaz**, yeni test yazılır. Yatay chart yoksa GAN senaryoları "geçti/blocked" sayılmaz: Opus uygulayana kadar bekler. |
| U4 | `TimelineRoute` ve `ChatRoute` **kabuk dışı** (alt menü gizli, `routes.dart`). Prototipte Gantt'ta **ray görünür** (AX: "Ana menü" var; `tgo('gantt')` yalnız `full:'gantt'` yapar, 390'lık liste bölmesi gizlenir `notFull`; `mod`/`rs` değişmez), sohbet **detay bölmesi içinde**. | Kabuk dışı rotalar tablette ray'ı kaybettirir → ROT-/NAV- senaryoları. |
| U5 | Yeni görev / toplantı / davet: prototipte **ortalanmış modal** (`[role=dialog]` `width:min(560px, 100%-48px)`, `max-height:calc(100%-64px)`, radius 28, `border-strong`); bugün **alt sayfa**. Tercih sorusu değil: kaynak neyse odur, test kaynak ölçüsünü assert eder. | Genişlik ≤ 560 ve ≤ ekran−48, yükseklik ≤ ekran−64, r 28 exact assert. |
| U6 | Prototip 1180×820. Gerçek cihaz **iPad Pro 13" M5** (beklenen yatay mantıksal ölçü ≈ 1376×1032 pt, dpr 2 — **doğrulanmadı**, ilk integration adımı `MediaQuery.sizeOf/devicePixelRatio/viewPadding` yazdırır). Detay bölmesi prototipte ≈ 1180−490 = **690**, cihazda ≈ **886**. **Tek/çift bölme yöne değil genişliğe bağlıdır**: ≥840 çift bölme (13" dikey 1032 ≥ 840 → çift kalır), 600–839 tek bölme, <600 mobil. Testler **ölçüye göre** beklenti yazar, "dikey = tek bölme" varsayılmaz. | Piksel eşleşmesi yalnız ölçü normalizasyonuyla (§4) anlamlı. |
| U7 | "Bugün" sabit değil: `home_page.dart`, `task_widgets.dart`, `quick_forms_controller.dart` doğrudan `DateTime.now()` kullanıyor (clock sağlayıcısı yok); Gantt `today` veriden. Referans ekranlar **21 Ekim 2026 Çarşamba**'ya kilitli (bugünkü gerçek tarih 29 Ekim 2026). | Görsel ve takvim testleri için tarih sabitlemesi gerekir (test-only: örnek veri deposu + fake clock; yoksa üretim değişikliği → koordinatöre bildir). |
| U8 | Mevcut 1180×820 ölçüsünü kullanan test yok; `screen_matrix.dart` boyutları 360×800, 412×915, 700×1000, 1024×1366 (hepsi dikey/telefon-tablet). | Yeni `ScreenSize('ipad-air-yatay', 1180×820)` ve `('ipad-pro13-yatay', ≈1376×1032)` test-only eklenmeli. |

### 1.1 Kaynak davranış sözleşmesi (HTML'den doğrulandı; senaryolar buna bağlıdır)

| Kural | Kaynak (12-Tablet.dc.html) |
|---|---|
| Modül varsayılan sağ ekranı `TB_DEF = {home:'history', tasks:'detail', calendar:'empty', coord:'cdetail', archive:'afolder', messages:'chat', login:'empty'}`. **Boş "Bir kayıt seç" yalnız Takvim'de**; Koordinatörlükler varsayılan ALT `cdetail`, Arşiv varsayılan `afolder`, Mesajlar `chat` ('koord' yüklü), Görevler `detail` (ALT-5 yüklü) | satır 3796, 3802, 3812–3813 |
| **Modül değişimi** (`tgo(modül)`, ray/çekmece): `rs:[TB_DEF[to]]` → sağ yığın **TÜR olarak** modül varsayılanına döner (tek giriş); **içerik ise o alt ekranın son yüklenen kaydıdır** (`subs.detail/cdetail/afolder/chat` kalıcıdır, `load` yalnız çağrıldığında değişir; ALT-5/ALT/ALT/koord yalnız İLK açılışta); master alt durumları (arama, süzgeç…) korunur; sol/sağ kaydırma 0 (DÜZELTME: önceki sürümde 'ALT-5'e sıfırlanır' yazıyordu, yanlıştı) | 3818–3821 |
| **Aynı modüle yeniden dokunma**: `full` varsa kapatır; `rs.length>1` ise `[TB_DEF]`'e pop eder; tek ise hiçbir şey | 3819 |
| **Çapraz özellik açma** (`openTask/openCDetail/openAFolder/openChat` → `sp.nav('detail'|'cdetail'|'afolder'|'chat')` → `tgo`): **yalnız sağ `rs` değişir, mevcut master modül korunur**. Hedef yığının tepesindeyse `rHide` ile yeniden çizim (animasyon), yığında daha aşağıdaysa o noktaya pop, yoksa `rs.concat` (push). Tür başına en çok bir giriş → yığın şişmez (≤6) | 3517–3522, 3823–3830 |
| `openTask(id)`: `detail.load(id)`; aynı kimlikse `load` hemen döner (durum korunur), farklıysa görev başına önbellekten geri yükler, `sheet/toast` sıfır, **sekme `ozet`**. `openCDetail(code)`: `tab:'gen'`, `sheet:null`, `toast:''`, `memOpen:false`. `openAFolder(code)`: `tab:'tasks'`, `tag/task/sheet/pv:null`. `openChat(id)`: `chat.load(id)` | 3520, 3522, 3518, 3517, 2401–2404 |
| **`S_chat.load(id)` sohbet değişiminde sıfırlar**: `draft:''`, `reply:null`, `edit:null`, `act:null`, `refs:[]`, `at/atQ`, `press`, `info:false`; okunmamışı 0 yapar. **Prototipte A→B→A taslak korunmaz; AYNI sohbet SATIRINI yeniden seçmek de `load`'u çağırır ve taslak/yanıt/ayırıcıyı sıfırlar.** Yalnız yeniden BOYUT/dönüş taslağı, yanıtı ve ayırıcıyı korur (onaylı **responsive kuralı**; prototip ekran boyutu değiştirmez). Sözleşme §13 | 3212–3216 |
| **İstisna** `openTaskFromGantt(id)`: `d.load(id)`; `full:null, mod:'tasks', rs:['detail']` (master Görevler'e atlar, sağ yığın tek `detail`; Gantt alt durumu (`hgantt`) silinmez) | 3776, 3808 |
| `tgo('gantt')`: `g._center='auto'; g.el=null; full:'gantt'`; `openCoord(code)`: `coords:[code]`, `sel:null` sonra Gantt; `closeGantt`: `full:null` (mod/rs aynı) | 3806–3807, 3817 |
| Geri düğmesi: `canBack = rs.length>1`; `tback` son girişi atar; `data-canback=false` iken `[aria-label^="Geri"]` gizli | 3832, 3859, HTML 72 |
| `kindRows` ("takvimde göster": Toplantılar/Görevler/Talepler/Tablo kayıtları/Sezon tarihleri) yalnız `buildNav` → `fly` (telefon hızlı menü) içinde, **tablet şablonunda `fly` render'ı ve takvim süzgeç kontrolü yok** (şablon 538–631 + AX); görünür UI'den ulaşılamaz → **kapsam dışı** | 3500, 3644–3650, 3700 |

## 2. Kaynak haritası (HTML → ölçü / bölüm)

| Bölüm | HTML satırı | Ölçüler (inline) |
|---|---|---|
| Artboard | 77 | 1180×820, `overflow:hidden`, `--bg-base`, `--font-sans` |
| Giriş | 79–130 | 420 genişlik ortada, `padding:96px 24px 40px`, gap 40 |
| Gezinme rayı | 133–140 | `nav[aria-label="Ana menü"]` 100 px, `padding:20px 0`, logo 36 (alt boşluk 18), öğe 96×, hap 60×34 (r 9999), etiket 10.5/13, rozet sağ 10 üst −3; zil 44, çekmece düğmesi 44 daire, asistan 56 daire (`margin-top:8`) |
| Liste bölmesi | 143–631 | `.tb-pane` **390** px, sağ kenarlık 1 px, `overflow-y:auto`, alt dolgu 40 |
| Ana sayfa | 145–239 | karşılama, KPI 2×2, hızlı işlemler 4'lü, ekip 3'lü, işlem geçmişi kartı, koordinatörlük 2'li ızgara (genişleyebilir) |
| Görevler | 240–393 | başlık, Liste/Zaman çizelgesi hapı, görünüm kutucukları (referans jpg'de 3×2: Tümü 76, Geciken 15, Devam 20, Onayda 3, Tarih talebi 3, Başlamadı 14, Biten 39), sıralama menüsü, görev kartları, filtre alt sayfası (350) |
| Koordinatörlükler | 394–424 | liste; kart: kısaltma, ad, koordinatör, `n/m bitti`, gecikme rozeti |
| Arşiv | 425–499 | arama (genişleyen), Dosya yükle, Etiketler (daralmış, 3), yeni etiket + 5 renk, Depolama, klasör listesi (Son yükleme + 11) |
| Mesajlar | 500–537 | arama, süzgeç (Tümü/Okunmamış 4/Gruplar/Kişiler), 9 sohbet satırı |
| Takvim | 538–631 | ay/hafta ızgara (Ekim 2026: 28 Eyl–1 Kas, 5 satır), seçili gün listesi, kayıt önizleme (592–619), "Bugün", "Seçili güne toplantı planla" |
| Detay bölmesi | 632–1468 | `.tb-rpane` yan dolgu 28; ekranlar: history (634), detail (728), gantt-dar (960), chat (1172), afolder (1290), cdetail (1359); boş: "Bir kayıt seç" (1470) |
| Yatay Gantt | 1479–1552 | tam genişlik, başlık 72 (geri, h1 22/28, süzgeç 34, ölçek 34, Bugün 40), çip şeridi 32, yapışkan başlık 52 (bulanık), sol sütun `G.LW` yapışkan, seçili görev kartı, lejant |
| Hızlı işlem modalleri | 1553–1716 | Yeni görev (1565), Toplantı (1609), Davet (1672), bildirim (1711) |
| Çekmece | 1717–1745 | sağdan "Yan menü", Beta rozetli öğeler |
| Hareket | 56–60 | `rpPush .38s cubic-bezier(.2,.8,.2,1)`, `rpFadeIn .3s`; `prefers-reduced-motion` → 1 ms |

## 3. Senaryo matrisi

Kayıt dili: prototip metinleri ve sayıları referans AX ağacından (21 Ekim 2026 verisi) alınmıştır.

### 3.1 KAB — Kabuk, ray, ana bölme düzeni

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| KAB-01 | 1180×820: ray 100 px + liste 390 px + detay kalan; ray ve liste arasında 1 px kenarlık, detay sol kenarı x≈490 | 133–144 | `shell.dart` `_rail` (NavigationRail + `Expanded`) | `router_scoped_test` "expanded: genişletilmiş ray" | KIRILIR | W,G |
| KAB-02 | Ray öğeleri sırayla Ana sayfa, Görevler, Takvim, Koordinatörlükler, Arşiv, Mesajlar; yalnız Mesajlar rozet "4" | 135 | `shellTabsFor` 3 sekme | `router_scoped_test` "sekme sayısı dal sayısıyla aynıdır" | KIRILIR | W |
| KAB-03 | Etkin öğe: `aria-current` ≙ hap dolgusu 60×34 + kalın etiket; geçiş `.3–.35s` | 135 | — | — | YOK | W,G |
| KAB-04 | Alt blok: Bildirimler (kırmızı nokta, etiket "3 tarih talebi ve 3 onay seni bekliyor"), Tüm modüller, Asistana sor | 137–139 | `home_menus.dart`/zil etiketi (`home_page_test` "zil etiketi bekleyenleri türüne göre sayar"), `NzNavAction` asistan tostu | `home_page_test` | KISMEN | W |
| KAB-05 | Etkin sekmeye yeniden dokunma → o sayfanın kısayol menüsü (mevcut `ShellReselectEvents`), tablet rayında da çalışır | — | `shell.dart` `_select` | `tasks_page_test` "kabukta yeniden dokunma…" (compact) | KISMEN | W |
| KAB-06 | Sekme geçişinde her modülün seçili kaydı (liste kaydırma + seçili öğe) korunur | — | `StatefulShellRoute.indexedStack` | `router_scoped_test` "sekme değiştirip dönünce iç rota korunur", "expanded rayda da…" | KISMEN (seçili kayıt yok) | W |
| KAB-07 | Giriş ekranı tam ekran 420 genişlikte ortalı, ray/liste yok | 79–130 | `login_page.dart` + `NzPage` | `login_page_test` `testScreens` (telefon/tablet) | KISMEN (420 ölçüsü yok) | W,G |
| KAB-08 | Faz kapıları (server/login/scope) tablette ray göstermez | — | `router.dart` `gateRedirect` | `router_gate_test`, `router_scoped_test` "…kabuk kurulmaz" | VAR (yalnız genişlik 800 tipik) | W |
| KAB-09 | Geçiş hareketi: sayfa içeriği `rpPush` benzeri 10 px sabit, üst çubuk sabit | 56–60 | `core/ui/motion/page_content_entrance.dart`, `transitions.dart` | `page_content_entrance_test`, `transitions_test`, `shell_motion_test` | VAR | W |
| KAB-10 | `prefers-reduced-motion` ≙ `MediaQuery.disableAnimations`: geçiş 1 ms eşdeğeri | 60 | `nz_motion.dart` | (kısmen `shell_motion_test`) | KISMEN | W |

### 3.2 HOM — Ana sayfa (varsayılan içerik + seçim sağ panel)

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| HOM-01 | Varsayılan: karşılama "Merhaba Muhammet Ali Çalışkan", tarih "21 ekim 2026, çarşamba", KPI 4 (Tamamlanma %49 · 39/79, Devam eden 40, Gecikmede 15, Onay bekleyen 3) | 159–172 | `home_page.dart`, `home_sections.dart`, `HomeDashboardController` | `home_page_test`, `home_dashboard_controller_test` | KISMEN (tarih U7) | W,G |
| HOM-02 | Varsayılan detay bölmesi: **İşlem geçmişi** (başlık, "CSV olarak indir", arama, Tür çipleri Tümü 38/Görev 3/Dosya 1/Toplantı 13/Mesaj 11/Hesap 10, "30 / 38 kayıt gösteriliyor") ana sayfa listesiyle birlikte açık | 634–727; AX home | `activity_page.dart` (ayrı `/home/history` rotası) | `activity_page_test` | KISMEN (yan yana bileşim yok) | W,G |
| HOM-03 | Hızlı işlemler: Yeni görev / Toplantı / Davet et (açılır pencere) / Rapor | 173–183 | `quick_action_sheets.dart` | `quick_action_sheets_test` | KISMEN (modal ölçü §3.9) | W |
| HOM-04 | KPI ve koordinatörlük kartı seçilince görev listesi/koordinatörlük detayı **sağ bölmede** açılır | 165–172, 202–222 | `home_page_test` "KPI ve koordinatörlük kartı gezinme hedefini çağırır" | aynı | KIRILIR (hedef sağ bölme) | W |
| HOM-05 | "İşlem geçmişini aç" bağlantısı geçmişi sağ bölmede açar; "Son işlem bugün 14:27 · Abdullah Ateş" | 194–201 | `HistoryRoute` | `home_page_test` "…geçmiş kartı geçmişi açar" | KIRILIR | W |
| HOM-06 | Koordinatörlükler kartı: sıralama ölçütü, ters çevir, durum çipleri (Tümü 11/Gecikmesi olan 7/Yolunda 4/Koordinatörsüz 1), "Tümünü göster (11)" genişletir | 202–238 | `home_coordinatorships.dart` | `home_page_test` (kısmen) | KISMEN | W |
| HOM-07 | Çekmece ("Tüm modüller") sağdan açılır; modül seçer, kapanır | 1717–1745 | `home_menus.dart` | `home_page_test` "çekmece: rol · e-posta…" | VAR (tablet yerleşimi yok) | W,G |

### 3.3 TSK — Görevler (liste/filtre/arama/sıralama, detay)

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| TSK-01 | Varsayılan: "Görevler", Liste/Zaman çizelgesi hapı, kutucuklar (76/15/20/3/3/14/39), "tüm görevler · 76", "Bitiş tarihine göre"; sağ bölme boş durum "Bir kayıt seç" | 240–349, 1470–1476 | `tasks_page.dart`, `tasks_list_parts.dart` | `tasks_page_test` "görünümler, liste başlığı…" | KISMEN (boş detay yok) | W,G |
| TSK-02 | Kutucuk (görünüm) seçimi listeyi süzer, sayı başlıkla tutarlı; yeniden dokunma kaldırmaz | 272–283 | `TasksListController` | `tasks_list_controller_test`, `tasks_page_test` "başlangıç süzgeci…" | VAR | W |
| TSK-03 | Arama (genişleyen alan) + temizle; eşleşme yok boş durumu | 254–270, 337 | `tasks_page.dart` | `tasks_page_test` "arama ve filtre alt sayfası…" | VAR | W |
| TSK-04 | Sıralama menüsü (ölçüt, yön, koordinatörlüğe göre gruplar `isHead`) | 291–303 | `tasks_page.dart` | `tasks_page_test` "sıralama menüsü…" | VAR | W |
| TSK-05 | Filtre alt sayfası (durum, öncelik, kişi); çipler, Temizle; tabletteki açılış biçimi (alt sayfa/modal) | 350–393 | `tasks_filter_sheet.dart` | `tasks_page_test` | KISMEN (biçim U5) | W |
| TSK-06 | Kart seçilince detay **sağ bölmede** açılır; liste yerinde kalır, seçili kart vurgulu | 304–336; AX tasks.jpg | `TaskDetailRoute` (tam sayfa itme) | `tasks_page_test` "gezinme: kart…" | KIRILIR / YOK | W,G |
| TSK-07 | Detay: ALT-5 üst şerit (kod, kalem, ⋮), durum/öncelik seçicileri, Kanıt yükle, sekmeler Özet/Alt görev/Dosya/Not, ilerleme zaman çizgisi "98 gündür gecikmede" | 728–866; tasks.jpg | `task_detail_page.dart`, `detail_tabs.dart` | `task_detail_page_test` (5 senaryo) | VAR (bölme içi yerleşim yok) | W,G |
| TSK-08 | Detay eylemleri: durum kuralı, talep onayı, kanıt yükle, düzenle doğrulaması, sil+geri al (alt sayfa/modal) | 867–958 | `detail_actions.dart`, `detail_forms.dart` | `task_detail_page_test` | VAR | W |
| TSK-09 | Sayfalama "Daha fazla göster" tablette de yalnız bir ek yükleme | 342 | `TasksListController` | `tasks_page_test` | VAR | W |
| TSK-10 | Başka kart seçilince detay değişir; seçim sırasında liste kaydırma konumu korunur | — | — | — | YOK | W |
| TSK-11 | Liste → "Zaman çizelgesi" hapı yatay Gantt'ı açar (`full:'gantt'`, ray kalır, liste gizlenir); "Geri: Görevler" (`closeGantt`) `mod/rs`'yi **değiştirmeden** kapatır → Görevler master'ı ve sağ yığın olduğu gibi döner | 1479–1488, 3807 | `app_nav.openTimeline` (dikey chart rotası) | — (`timeline_page_test` dikey chart) | YOK (yatay chart yok) | W,I |
| TSK-13 | Ray'dan Görevler'e **yeniden dokunma**: `rs.length>1` ise `['detail']`'e pop; tek ise değişmez. Başka modülden dönüşte sağ yığın tek `detail` girişidir ve **son yüklenen görevi** gösterir (ilk açılışta ALT-5); 'ALT-5'e sıfırlanır' DEĞİL | 3818–3821 | `shell.dart` `_select` | — | YOK | W |
| TSK-12 | Sağ bölmede olmayan görev kodu (`bilinmeyen görev`) boş durum | — | `TaskDetailPage` | `task_detail_page_test` "bilinmeyen görev" | VAR | W |

### 3.4 CAL — Takvim (**tamamı YOK**: sayfa/rota/denetleyici/örnek veri bulunmuyor, U2)

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| CAL-01 | Varsayılan: "Takvim", Ekim 2026 ay ızgarası 28 Eyl–1 Kas (5 satır, Pzt başlar), seçili 21 (bugün), hücre erişilebilirlik etiketi "21 Ekim, Çarşamba, bugün, 4 kayıt" | 538–591; calendar.ax | — | — | YOK | W,G |
| CAL-02 | Ay gezinmesi Önceki/Sonraki; ay başlığı, hafta sayısı 4–6 satır; Eylül/Kasım dış gün hücreleri soluk | 556–571 | — | — | YOK | W |
| CAL-03 | "Haftaya daralt" (ay→hafta) ve geri; hafta modu seçili gün satırını gösterir | AX 21 | — | — | YOK | W,G |
| CAL-04 | Gün seçimi: başlık "21 Ekim, Çarşamba"+ "bugün", bölümler "toplantılar · 2", "talepler · 1", "tablo kayıtları · 1" | 572–591 | — | — | YOK | W |
| CAL-05 | "Bugün" düğmesi: bugün seçiliyken devre dışı; başka güne geçince etkin, dokununca bugüne döner ve ayı geri getirir | AX 18 | — | (benzeri Gantt: `timeline_page_test` "bugüne dön") | YOK | W |
| CAL-06 | Boş gün (örn. 6 Ekim): "kayıt yok" boş durumu | 589 | — | — | YOK | W |
| CAL-07 | Kayıt sayısı gün hücresinde = gün listesindeki satır sayısı (tutarlılık sabiti; 29 Ekim = 5) | AX 57–66 | — | — | YOK | W |
| CAL-08 | Görev kaydı seçilince takvim (master) **solda kalır**, sağ `rs=['empty','detail']` ile görev detayı açılır (boş "Bir kayıt seç" kalkar); geri düğmesi görünür ve `empty`'ye döner; modül Görevler'e **atlamaz** | 90–91, 1470, 3823–3830 | `TaskDetailRoute` | — | YOK | W,G |
| CAL-09 | Toplantı / talep kaydı **önizleme penceresi** (modal), gündem/bağlantı satırları (`pk.hasAg`) ve kapatma | 592–619 | — (toplantı modeli: `meeting_form.dart`) | — | YOK | W |
| CAL-10 | "Seçili güne toplantı planla": toplantı penceresi seçili tarihle dolu açılır | AX 19; 1609–1671 | `meeting_form.dart`, `quick_forms_controller.dart` | `quick_action_sheets_test` "toplantı…" | YOK (tarih önyükleme) | W |
| CAL-11 | Oluşturma sonrası yeni toplantı o gün listesine ve hücre sayısına yansır | 620 | — | — | YOK | W |
| CAL-12 | **Kapsam dışı**: `renderVals.kindRows` yalnız telefon `fly` hızlı menüsünde; tablet şablonunda (538–631) ve AX'te görünür süzgeç kontrolü yok (§1.1). Yeni ürün özelliği yapılmaz, test yazılmaz | 3500, 3650 | — | — | KAPSAM DIŞI | — |
| CAL-13 | Dışarı kaydırma/sınır: seçili gün ay değişince korunur ya da ayın 1'ine gider (sözleşme netleşmeli) | — | — | — | YOK | W |
| CAL-14 | Yeniden boyut/dönüş: ay, seçili gün ve seçili kayıt aynı kalır (ROT) | — | — | — | YOK | W,I |
| CAL-15 | Takvim'de görev aç → ray ile Görevler → ray ile Takvim: modül değişimi sağ seçimi `empty`'e sıfırlar (seçili gün **master durumu olarak** korunur mu — alt ajan durumu korunur, doğrulanacak) | 3818–3821 | — | — | YOK | W |
| CAL-16 | Erişilebilirlik: hücre etiketleri `Semantics(selected, label)` (AX'teki "selectable/selected") | calendar.ax | — | — | YOK | W |

### 3.5 CRD — Koordinatörlükler

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| CRD-01 | Varsayılan: "11 koordinatörlük · 76 görev · 7 koordinatörlükte gecikme", 11 kart alfabetik (ALT, EĞİ, ELE, FUA, İDA, MEK, MİM, OPE, SAT, SİS, ULA) | 394–424; coordinatorships.ax | `coordinatorships_page.dart` | `coordinatorships_page_test` "başlık, özet satırı, kart içeriği…" | KISMEN (11 kart sırası/`n/m bitti`) | W,G |
| CRD-02 | Modüle girişte sağ bölme **varsayılan ALT `cdetail`** (boş durum **yok**; `TB_DEF.coord='cdetail'`, referans AX: ALT başlığı, "Ekibe mesaj", "Görev ata", sekmeler Genel/Birimler 3/Ekip 9/Hakkında); başka kart seçilince o koordinatörlük | 1359–1469, 3796 | `coordinatorship_page.dart`, `coordinatorship_tabs.dart` | `coordinatorship_page_test` (Genel, sekmeler) | KIRILIR/KISMEN | W,G |
| CRD-03 | Genel: özet 3 kutu, "dikkat gerektirenler" (ALT-5 98 gün…), Kısayollar (Zaman çizelgesinde gör 12, Arşiv klasörü 15, Toplantılar 2, Birim raporu) | AX 95–136 | `coord_widgets.dart` | `coordinatorship_page_test` "Genel: kimlik, özet…" | VAR | W |
| CRD-04 | Koordinatörsüz (İDA "Koordinatör yok · Bahar Kılıç (üye)") satırı ve tost | AX 44 | — | `coordinatorship_page_test` "koordinatörsüz…" | VAR | W |
| CRD-05 | `openCDetail(code)` açıkça `tab:'gen'`, `sheet:null`, `toast:''`, `memOpen:false` sıfırlar: Ekip sekmesinde açık üye listesi/sheet/tost varken başka koordinatörlük seçilince Genel'e döner; aynı kod yeniden seçilince de sıfırlar (`rHide` yeniden çizim) | 3522, 3823–3828 | — | — | YOK | W |
| CRD-06 | "Zaman çizelgesinde gör" → `openCoord(code)`: `coords:[code]`, `sel:null`, yatay Gantt, ray kalır; "Geri: Görevler" `full:null`, Koordinatörlükler master'ı + `cdetail` aynen kalır | 3806–3807, 1479+ | `TimelineRoute(coord)` (dikey chart) | — | YOK (yatay chart yok) | W,I |
| CRD-07 | "Arşiv klasörü 15 dosya" → `openAFolder(code)`: master **Koordinatörlükler solda sabit**, sağ `rs=['cdetail','afolder']` (push); geri düğmesi `cdetail`'e döner; Arşiv modülüne **atlamaz** (ray seçimi Koordinatörlükler) | 3518, 3823–3830 | `openArchiveFolder` | — | YOK | W |

### 3.6 ARC — Arşiv (klasör/etiket/önizleme)

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| ARC-01 | Varsayılan: "Arşiv", Depolama "559,3 MB · 227 dosya · 11 klasör", klasör listesi (Son yükleme + 11, dosya sayısı) | 425–499; archive.ax | `archive_page.dart`, `archive_texts.dart` | `archive_page_test` (3) | KISMEN | W,G |
| ARC-02 | Arama (genişleyen); sorgu klasör/dosya/etiket süzer; eşleşme yok boş metin; geri dönüşte sorgu korunur | 429–445 | `ArchiveController` | `archive_page_test` "sıralama döngüsü ve arama…", "geri dönüşte arama…" | VAR | W |
| ARC-03 | Etiketler paneli (daralmış, "3"): aç/kapa; yeni etiket adı + 5 renk (Mor, Sarı[seçili], Yeşil, Kırmızı, Gri); "Etiketi ekle" ad boşken devre dışı | 446–469; archive.ax 21–34 | `archive_page.dart` `_TagsPanel` | `shell_resize_test` (taslak korunur) | KISMEN (ekleme davranış testi yok) | W |
| ARC-04 | Etiket süzgeci: etiket seç → klasör/dosya listesi süzülür; sayaç (114/68/45) | 454 | `ArchiveController` | `archive_controller_test` | KISMEN | W |
| ARC-05 | Modüle girişte sağ bölme **varsayılan `afolder`** (referans: Altyapı ve tesisat); klasör seçince `openAFolder` `tab:'tasks'`, `tag/task/sheet/pv:null` sıfırlar; içerik: "Arşiv / ALT", ZIP indir, Yükle, sekmeler Görev klasörleri 11/Dosyalar 15 | 1290–1331, 3518, 3796 | `archive_folder_page.dart` (itme rota) | `archive_folder_page_test` | KIRILIR (bölme içi) | W,G |
| ARC-06 | Görev klasörü seçince dosyaları süzer; etiketle; geri dönüşte süzgeç sıfır | 1316–1325 | — | `archive_folder_page_test` "görev klasörü dosyaları süzer…", "silinen dosya…" | VAR | W |
| ARC-07 | Dosya önizleme (`pv.open`): ad, tür, boyut, silme; tabletteki biçim (modal/panel) | 1332–1358 | `archive_preview_sheet.dart` | `archive_folder_page_test` | KISMEN | W,G |
| ARC-08 | Dosya yükle → tost; "Yükle" klasör içinde seçili klasöre yükler | 429–445 | `ArchiveRepository` (örnek) | `archive_page_test` "yükle tostu…" | VAR | W |
| ARC-09 | Klasör seçili iken sol listede seçili satır vurgulu; sekme (Görev klasörleri/Dosyalar) korunur arama değişince | — | — | — | YOK | W |
| ARC-10 | Kısayol menüsü (diğer klasör/tüm arşiv) tablette | — | `archive_page.dart` | `archive_page_test`, `archive_folder_page_test` | VAR (compact) | W |
| ARC-11 | Tembel kurulum: uzun dosya listesi yalnız görünen bölgeyi çizer (iPad yatay yüksekliğinde) | — | `archive_folder_page.dart` | `archive_folder_page_test` "dosyalar tembel…" | VAR | W |

### 3.7 MSG — Mesajlar / Sohbet

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| MSG-01 | Varsayılan: 9 sohbet satırı sırası (Genel 10:02 [2], Koordinatörler, Sistem koord., Hidrofor teslim ekibi [1], Kadir Özbek, Bahar Kılıç [1], Fuar kurulum [2], Reha Koçak); ray rozeti 4 = okunmamış toplamı | 500–537; messages.ax | `messages_page.dart` | `messages_page_test` "satırlar…" | KISMEN (rozet tutarlılığı) | W,G |
| MSG-02 | Süzgeç Tümü/Okunmamış 4/Gruplar/Kişiler; sayaç sağ üstte; arama "Kişi, grup veya mesaj" | 504–529 | `ChatsController` | `messages_page_test` "süzgeç…", `chats_controller_test` | VAR | W |
| MSG-03 | Sohbet seç → **sağ bölmede** sohbet (başlık, "15 üye", Sohbette ara, ek menüsü, yazma alanı), ChatRoute ayrı sayfa değil | 1172–1289 | `chat_page.dart` (kabuk dışı rota) | `chat_page_test` | KIRILIR | W,G |
| MSG-04 | Yazma alanı: boşken "Gönder" devre dışı; yazınca etkin; gönder → tek tik → çift tik → okundu | 1212–1234; AX 84 | `chat_controller.dart`, `chat_parts.dart` | `chat_page_test` "gönder…" | VAR | W |
| MSG-05a | **Sohbet DEĞİŞİMİNDE kaynak gibi temizle**: A'da taslak/yanıt/düzenleme/ek (`refs`)/`@`-öneri yazılıyken B'ye geçince `draft:''`, `reply:null`, `edit:null`, `refs:[]`, `at/atQ`, `info:false`; A'ya dönünce de boş (prototipte taslak korunmaz). Aynı sohbet satırına yeniden dokunma da `load` ile taslağı, yanıtı ve okunmamış ayırıcısını temizler (§13) | 3212–3216, 3517 | `ChatController` | — | YOK | W |
| MSG-05b | **AYNI sohbette resize/dönüş**: taslak metni, yanıt bağlamı, düzenleme, ek, imleç ve kaydırma korunur (onaylı responsive kuralı; prototipten bağımsız). Genel `keepAlive` önerilmez; kural yalnız görünen sohbet için | — | `ChatController` (autoDispose) | `chat_page_test` "yeniden boyut" | VAR (bölme içi bileşimde yeniden doğrula) | W |
| MSG-06 | Yanıt (reply) bağlamı: mesajı basılı tut → "Yanıtla" → bağlam çipi; gönderince temizlenir; sohbet değişince temizlenir (MSG-05a) | 1226–1234, 1267–1280 | `ChatState.reply` | `chat_page_test`, `chat_controller_test` | KISMEN | W |
| MSG-07 | Ek (görev/koordinatörlük/arşiv) menüsü `ChatAttachTab`; arama; seçince taslağa/`refs`'e eklenir | 1215–1225 | `chat_sheets.dart`, `ChatAttachTab` | `chat_page_test` "öneriler: #görev ve @kişi…" | KISMEN | W |
| MSG-08 | Öneriler `#görev` / `@kişi` | 1214 | `chat_parts.dart` | `chat_page_test` | VAR | W |
| MSG-09 | Mesaj işlemleri (basılı tut): tepkiler, yanıtla, düzenle, göreve dönüştür | 1267–1280 | `chat_sheets.dart` | `chat_page_test` ("göreve dönüştür", "düzenle") | VAR | W |
| MSG-10 | Anket: oy ver, sonuçlar sayfası, bitir | 1249–1266 | — | `chat_page_test` "anket…" | VAR | W |
| MSG-11 | Sohbet bilgisi paneli (grup üyeleri/ortak dosyalar) tablette sağ panel mi modal mı | 1235–1248 | `chat_sheets.dart` | — | YOK | W |
| MSG-12 | Klavye (viewInsets) ve dönüş: yazma alanı klavyenin üstünde, taslak/yanıt korunur | — | — | `chat_page_test` "klavye…", "yeniden boyut" | VAR | W,I |
| MSG-13 | Yazarken balonlar yeniden kurulmaz (liste performansı bölme içinde) | — | — | `chat_page_test` "yazarken balonlar yeniden kurulmaz" | VAR | W |
| MSG-14 | Kısayol: okunmamışlar süzgeci; tümünü okundu say → ray rozeti 0 olur, "okunmamış mesajlar" ayracı | 1181 | `messages_page.dart` | `messages_page_test` "kısayol…" | KISMEN (rozet) | W |

### 3.8 GAN — Yatay Gantt (**tablet yatay chart YOK**, Opus yazacak; mevcut Gantt dikey, U3)

Mevcut `timeline_*_test.dart` dikey chart'ı sınar: **kopyalanmaz**; `timeline_controller_test` yalnız ortak mantık için referanstır. Yatay chart uygulanana kadar bu senaryolar geçti/blocked sayılmaz, bekler.

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| GAN-01 | Varsayılan: "Zaman çizelgesi · 76 görev · tüm koordinatörlükler", Tümü seçili, ölçek **Ay** seçili, 11 çip + "Tüm koordinatörlükler" | 1479–1490; gantt.ax | yok (yeni yatay chart); dikey: `timeline_page.dart` | — | YOK | W,G |
| GAN-02 | Tablet düzeni: `full:'gantt'` iken liste bölmesi gizli, **ray görünür, `mod`/`rs` aynı**, Gantt kalan genişlikte (1180−100); başlık 72 px, çip şeridi 32 | 142, 1481, 3817 | `TimelineRoute` kabuk dışı (U4) | — | YOK | W,G |
| GAN-03 | Ölçek **Hafta/Ay/Sezon** seçimi; her ölçekte toplam genişlik ve gün/ay etiketleri değişir; seçim kalıcı | 1486 | `TimelineScale` day/week/month (dikey chart'a özgü) | — | YOK | W,G |
| GAN-04 | Süzgeç Tümü / Açık / Geciken · 15; sayaç doğru (15) | 1485 | `TimelineStatusFilter` (4 değer; prototipte "Biten" yok) | — | YOK | W |
| GAN-05 | Koordinatörlük çipi (çok seçim, Tümü sıfırlar, `title` tam ad) | 1489 | `toggleCoordinatorship`, `toggleAll…` (yalnız mantık) | `timeline_controller_test` (mantık) | YOK (çip şeridi yok) | W |
| GAN-06 | Grup (koordinatörlük başlığı) daralt/aç: "ALT … 3 gecikme 13", `expanded` ↔ collapsed; çubukları gizler | gantt.ax 46… | yok (yatay chart) | — | YOK | W,G |
| GAN-07 | Çubuk seç → seçili görev kartı (modal değil, çizelge görünür kalır); durum rozeti; gecikme/Δ satırları; ayrıntıda aç; kapat | 1077–1115, 1534–1552 | `timeline_selection_card.dart` (dikey) | — | YOK (yatay) | W,G |
| GAN-08 | Karttan görevi aç: **`openTaskFromGantt`** → `full:null`, `mod:'tasks'`, `rs:['detail']`, `dirR:'push'`; ray Görevler seçili, sağ tek `detail` (yığın sıfırlanır), `hgantt` alt durumu silinmez. Genel `openTask`'tan farklı (istisna) | 3776, 3808 | `openTask` | — | YOK | W,I |
| GAN-08b | Ardından Gantt yeniden açılınca `_center='auto'`; önceki seçim/ölçek/süzgeç dönüşü **HTML kaynağından okunarak** assert edilir (kaynak `hg.state`'i silmez; varsayım yok) | 3817 | — | — | YOK | W |
| GAN-09 | Tarih taslağı → kaydet → geri al (snackbar); talep/hatırlat bildirimi | 1116–1170 | `timeline_controller.dart` `save/undo` | `timeline_controller_test` (mantık) | KISMEN (mantık) / UI YOK | W |
| GAN-10 | "Bugün" (header 40 px): bugün çizgisi konumu, tıklayınca yatay kaydırma bugüne ortalar | 1026, 1070, 1487 | `todayY` dikey; yatay karşılığı yok | — | YOK | W,I |
| GAN-11 | "Geri: Görevler" (`G.back` = `closeGantt`): `full:null`, `mod`/`rs` aynı | 1483, 3807 | — | — | YOK | W |
| GAN-12 | Sol sütun (`G.LW`) yatay kaydırmada sabit; başlık satırı (52 px, bulanık) dikey kaydırmada yapışkan; ay etiketi yapışkan | 1011–1020, 1494–1495 | dikey chart'ta yapışkan *tarih sütunu* var, eksen farklı | — | YOK | W,I |
| GAN-13 | Sezon şeridi/genel bakış, lejant (Başlamadı, Devam ediyor, Onay bekliyor, Geri gönderildi, Tamamlandı, Gecikme, Teknofest günleri) | 1030–1068, 1526–1533 | dikey `setOverview`/painters | — | YOK (yatay) | W,G |
| GAN-14 | Geniş yüzeyde (1180/1376) kaydırma + pinch yok; `Scrollbar` gizli (`scrollbar-width:none`) | 1491 | — | — | YOK | W |

### 3.9 MOD — Modal / düğme / eylemler

| ID | Senaryo | HTML | lib | Mevcut test | Durum | Kat. |
|---|---|---|---|---|---|---|
| MOD-01 | Yeni görev penceresi genişliği ≤ 560 ve ≤ ekran−48, yüksekliği ≤ ekran−64, ortalı, r 28, `border-strong`; arka karartma | 73–74 | `NzSheet`/`quick_parts.dart` | — | YOK | W,G |
| MOD-02 | Yeni görev: boş başlık hatası, Koordinatörlük zorunlu (11 seçenek radyo), "Atanan" önce koordinatörlük ("Bu koordinatörlükte kimse yok."), Tarih 21 Eki→4 Kas · 2 hafta (takvim, geçmiş günler devre dışı), Öncelik Düşük/Orta[sel]/Yüksek, Kanıt zorunlu anahtarı, Vazgeç/Oluştur | 1565–1608; task-create.ax | `new_task_form.dart`, `nz_range_calendar.dart`, `quick_forms_controller.dart` | `quick_action_sheets_test` "yeni görev: doğrulama, satırlar, oluşturma", `quick_forms_controller_test` | VAR (modal ölçü ve geçmiş-gün devre dışı kontrolü ekle) | W,G |
| MOD-03 | Başlık önceden doldurma (sohbet→göreve dönüştür) | — | `new_task_form.dart` | `quick_action_sheets_test`, `chat_page_test` | VAR | W |
| MOD-04 | Toplantı: başlık, tarih, saat çarkı, davetliler (koordinatörlük/kişi), gündem satırı | 1609–1671 | `meeting_form.dart` | `quick_action_sheets_test` "toplantı…" | VAR | W |
| MOD-05 | Davet: e-posta doğrulaması, rol, hata gövdesi | 1672–1710 | `invite_form.dart` | `quick_action_sheets_test` "davet…" | VAR | W |
| MOD-06 | Modal açıkken arka bölme ve ray dokunuşa kapalı; Kapat ve dış dokunuş; Android geri/Esc ile kapanır | 73 | `NzSheet` | — | YOK | W,I |
| MOD-07 | Modal açıkken yeniden boyut (dönüş): modal taşmaz, form değerleri korunur | — | — | — | YOK | W,I |
| MOD-08 | Çekmece (sağdan): açık/kapalı, odak, Beta rozetli satırlar | 1717–1745 | `home_menus.dart` | `home_page_test` çekmece | KISMEN | W,G |
| MOD-09 | Tost/snackbar sonuç bildirimi: tablette konum (alt orta, bölmeden bağımsız) | 1711–1716 | `NzToast` | `nz_toast_test` | KISMEN | W,G |
| MOD-10 | Düğme/etkileşim boyutları ≥ 44 dp (zil 44, çekmece 44, asistan 56) | 137–139 | `nz_icon_button.dart` | `nz_icon_button_test` | KISMEN (tablet rayında) | W |

### 3.10 NAV — Çapraz gezinme / geri

| ID | Senaryo | Mevcut | Durum | Kat. |
|---|---|---|---|---|
| NAV-01 | **Modül değişimi sağ yığını modül TÜRÜ tabanına indirir** (`tgo(modül)` → `rs:[TB_DEF[to]]`): Görevler'de MEK-6 seçili → Takvim → Görevler'e dönüş: sağ tek `detail` girişi, içerik **MEK-6 (son yüklenen)**; ALT-5 yalnız ilk açılışta; master alt durumları (arama/süzgeç/sıralama) alt ajan durumunda korunur, liste kaydırması **0** (kaynak `lbox/rbox.scrollTop=0`). "Seçili görev korunur" iddiası **yok** | `3818–3821` | — | YOK | W,I |
| NAV-02 | `openCoord`: Koordinatörlük ayrıntısı → "Zaman çizelgesinde gör" → yatay Gantt → "Geri: Görevler" → Koordinatörlükler master'ı + `cdetail` (+ sekme) aynen (`closeGantt` yalnız `full:null`) | 3806–3807 | — | YOK (yatay chart) | W |
| NAV-03 | **Gantt istisnası** `openTaskFromGantt`: kart → görev: `mod:'tasks'`, `rs:['detail']`; Geri/ray ile Gantt'a dönüş kaynak açık davranışı kadar (Gantt kendi `hg.state`'ini tutar); **"geri → aynı seçim" varsayılmaz**, kaynakta açık davranış assert edilir | 3776, 3808 | — | YOK | W,I |
| NAV-04 | Takvim görev kaydı → `openTask`: takvim **solda kalır**, sağ `rs=['empty','detail']`, geri `empty`'ye; modül Görevler'e **atlamaz** (ray seçimi Takvim) | 3520, 3823–3830 | — | YOK | W |
| NAV-05 | Sohbetteki `#ALT-7` atfı → `openTask`: master Mesajlar solda kalır, sağ `rs=['chat','detail']`; geri → chat. Sohbet durumu: görev atfı `chat.load` ÇAĞIRMAZ (yalnız sağ yığına `detail` ekler), bu yüzden taslak/ayırıcı dokunulmaz; sohbet SATIRINI seçmek ise `load` çağırır (§13) | 3519–3520, 3212 | `chat_page_test` "görev atfı açılır" | KISMEN | W |
| NAV-06 | Ana sayfa/Geçmiş kaydı (görev hedefli) → `openTask`: Ana sayfa master + sağ `rs=['history','detail']` | 3036, 3823–3830 | `activity_page_test` "görev hedefli kayıt…" | KISMEN | W |
| NAV-07 | Derin bağlantı `/tasks/ALT-5` doğrudan: ray Görevler seçili + detay açık; geri jesti sağ yığını tek tek atar, yığın boşsa uygulama kuralı | — | `router_scoped_test` "kabuk ve derin rotalar açılır" | KISMEN | W,I |
| NAV-08 | **Aynı kayda yeniden dokunma**: tepedeki `detail` ise `rHide` yeniden çizim (giriş animasyonu tekrar oynar), **yığın şişmez**; `load` aynı kimlikte durumu korur (sekme/draft), farklı kimlikte görev başına önbellek yükler ve **sekme `ozet`**, `sheet/toast` sıfır. "Hiç yüklemez" **değil** | 2401–2404, 3823–3828 | `app_nav_test` | KISMEN | W |
| NAV-09 | Reselect: `openCDetail`/`openAFolder`/`openChat` aynı kayıt tekrar seçimi — her biri kendi sıfırlama alanlarını uygular (CRD-05, ARC-05, MSG-05a); yığın tek giriş/tür | 3517–3522 | — | YOK | W |

### 3.11 ROT — Dönüş / dar pencere / yeniden yükleme değişmezleri

Her satır: **tek uygulama/yönlendirici/kapsayıcı**, yalnız `tester.view.physicalSize` değişir (mevcut `shell_resize_test` deseni; yeniden `pumpWidget` yok).

| ID | Değişmez | Boyut dizisi | Mevcut | Durum | Kat. |
|---|---|---|---|---|---|
| ROT-01 | **Ölçüye göre** (yön değil): ≥840 çift bölme, 600–839 tek bölme, <600 mobil. Dizi: 1180×820 (çift) → 820×1180 (820<840 → tek) → 1032×1376 (13" dikey, ≥840 → **çift kalır**) → 1376×1032 (çift). Her adımda rota aynı, `NzAdaptiveShell` State aynı | 1180×820, 820×1180, 1032×1376, 1376×1032 | `shell_resize_test` (Arşiv) | KIRILIR/genişlet | W |
| ROT-02 | Sağ seçili kayıt sınıf geçişinde (çift ↔ tek, eşik 840) kaybolmaz: kayıt kimliği ve ekran State'i aynı nesne; çift→tek ve tek→çift; **eşiğin altına inmeyen** dönüşte (13" dikey) bölme düzeni değişmez | 839↔840, 820↔1180, 1032×1376 | — | YOK | W,I |
| ROT-03 | Arama/etiket taslağı `TextEditingController` nesne kimliği ve metni aynı | aynı | `shell_resize_test` | VAR (Arşiv) | W |
| ROT-04 | Yazma alanı taslağı + yanıt bağlamı (sohbet) klavye açıkken dönüşte korunur | 1180×820 ↔ 820×1180, viewInsets 300 | `chat_page_test` "yeniden boyut" | VAR | W |
| ROT-05 | **Yeniden yükleme yok**: `loadFolders`, görev/sohbet/zaman çizelgesi örnek depoları çağrı sayacı 1 (sayaçlı sarmalayıcı) | aynı | `shell_resize_test` (Arşiv) | KISMEN (diğer modüller yok) | W |
| ROT-06 | Kaydırma konumu yeni sınıra sıkıştırılarak korunur (liste, Gantt yatay `ScrollController`, takvim) | aynı | `shell_resize_test` (Arşiv) | KISMEN (Gantt/takvim yok) | W |
| ROT-07 | Eşik geçişleri 599↔600 (mobil/tek bölme), 839↔840 (tek/çift bölme): ray türü, pencere sınıfı, bölme kuruluşu; yön hiçbir adımda belirleyici değil | 599/600/839/840 | `shell_resize_test`, `nz_layout_test`, `window_class_test` | VAR (tablet bölmeli düzen yok) | W |
| ROT-08 | Dar pencere / Split View / Stage Manager (iPadOS 26 yeniden boyutlanabilir pencere): 375×820, 507×1032 (≈1/3), 678×1032 (≈½) | 375×820, 507×1032, 678×1032 | `shell_resize_test` (375×820) | KISMEN (pencere boyutları ölçülmeli) | W,I |
| ROT-09 | iPad dönüşü iOS'ta tüm yönler (Info.plist 4 yön) → `OrientationPolicyHost` iOS'ta platform çağrısı yapmaz | — | `orientation_policy_test` "iOS: platform çağrısı yok…" | VAR | W |
| ROT-10 | `viewPadding` (güvenli alan) değişimi: üst/alt boşluk ray ve üst çubuğu itmez, içerik alanı doğru; gerçek cihaz safe-area farkı §4'te normalize | — | `nz_page_test` (kısmen) | KISMEN | W,G,I |
| ROT-11 | `autoDispose` ömürleri: **aynı** sohbet/form görünürken resize/dönüş/sınıf geçişi (çift↔tek) taslak, yanıt, ek, odak ve imleci korur (bölme içi `ChatController`, yeni görev formu). Sohbet DEĞİŞİMİ ise kaynak gibi temizler (MSG-05a); genel `keepAlive` önerilmez/test edilmez | — | `responsive-altyapi.md` "Limitler" uyarısı | YOK (**risk R1**) | W |
| ROT-12 | Metin ölçeği 1.0/1.3/2.0: taşma yok, `NzTextScaleLimit` 2.0 | — | `nz_page_test` "metin ölçeği 2.0…", `timeline_page_test` taşma matrisi | VAR (bölmeli düzen yok) | W |
| ROT-13 | Modal/çekmece açıkken dönüş (MOD-07) ve klavye açıkken bölme geçişi | — | — | YOK | W,I |
| ROT-14 | Rota değişmez: konum dizesi dönüşte aynı; geri yığını aynı uzunluk | aynı | `shell_resize_test` | VAR (Arşiv) | W |

## 4. Görsel kanıt kapıları

Önce çıkarımsal sınır: **"tam eşleşti" yalnız iki kapı da yeşilse ve normalizasyon yazılıysa söylenir**; golden Linux-yalnız (ADR-0003 k8) olduğu için yerel macOS çıktısı commit'lenmez, bu kapılar golden *değildir*.

### 4.1 Kapı G1 — Host offscreen widget render (1180×820)

- Tek `testWidgets`, `tester.view.devicePixelRatio = 1`, `physicalSize = Size(1180, 820)`, gerçek `createRouter` + `Harness` (`test/support/harness.dart`), `NizamioApp` flavor dev, sahte backend üzerinden gerçek giriş + program seçimi (örnek veri; prototip modu 2026-10-29'da kaldırıldı).
- Yakalama: `RepaintBoundary` + `toImage` (tester.runAsync içinde) → PNG, `Directory.systemTemp/nizamio-tablet-shots/host/<ekran>.png`. **Repo'ya yazılmaz.** Golden dosyası üretilmez.
- Yazı tipi: `loadAppFonts` (golden.dart). Aksi hâlde Ahem kare çizilir → ölçü doğru, piksel anlamsız.
- Karşılaştırma hedefi: `/tmp/nizamio-tablet-reference/<ekran>.jpg` . **Uydurma sayısal fark eşiği (ör. %10) yok.** Geometri (rect'ler: ray `x∈[0,100]`, liste `[100,490]`, detay başlangıcı 490; `tester.getRect`), içerik (metin/sayı), renk ve ikonlar **exact assert** edilir. Piksel farkı yalnız şu nedenlerle açıklanabilir ve her biri kanıtla yazılır: font rasterizasyonu (tarayıcı ↔ Skia/Impeller), OS safe-area, DPR farkı; JPEG kaynak sıkıştırması ayrıca belgelenir. Açıklanamayan fark = hata, geçti sayılmaz.
- Ekran seti (referansla birebir ad): home, tasks, calendar, coordinatorships, archive, messages, gantt, task-create (+ önerilen: login, drawer, archive-folder, chat). Çıktı: PNG + `ölçü.json` (rect'ler).

### 4.2 Kapı G2 — Gerçek iPad ekran doğrulaması (simülatör `ED5DCAAF-2A7E-480E-8316-E1B9A96DD9BC`, iPad Pro 13 M5, iPadOS 26.3, yatay)

- Ölçü farkı açıkça kayıtlı: mantıksal ≈1376×1032 pt (U6), dpr 2 (PNG ≈2752×2064), güvenli alan (durum çubuğu/pencere kontrolleri iPadOS 26) `MediaQuery.viewPadding`.
- Normalizasyon **yalnız**: (a) ölçü/dpr (PNG ÷ dpr → mantıksal), (b) native OS güvenli alan kırpma/ofseti, (c) artboard kök genişlik/yükseklik. Renk, ölçü ve düzen *ayarlanmaz*. Prototip kaynağına dokunulmaz; farklı cihaz ölçüsü için **harici bir test kopyasında** (`/tmp/...` altı) artboard `width/height` (satır 77) ayarlanıp CUA yeniden çeker.
- Prototip CSS yeni yerleşim ölçüleri (ray 100, liste 390, modal 560, r28) **olduğu gibi** Flutter'a taşınır; yalnızca detay bölmesi esner.
- Kanıt dosyaları: PNG (cihaz), JPEG (referans), ölçü tablosu (cihaz: ray/liste/detay rect, safe-area, dpr). Rapor "tam eşleşme" yerine ölçülü fark + açık normalizasyon listesi yazar.

### 4.3 Kapı G3 — Ölçü sözleşmesi (görsel olmayan, deterministik)

`getRect` ile: ray genişliği 100 (±0), liste 390 (±0) + 1 px kenarlık, hap 60×34, zil/menü 44, asistan 56, modal ≤ 560 / r 28. 1180×820 ve ≈1376×1032'de ayrı beklenti (detay: kalan). Bu, G1/G2 kanıtının *sayısal* sigortasıdır ve JPEG gürültüsünden etkilenmez.

## 5. Integration test uygulanabilirliği (bu aşamada **yalnız inceleme**, hiçbir şey eklenmedi)

| Konu | Bulgu | Öneri |
|---|---|---|
| Bağımlılık | `pubspec.yaml` dev bağımlılıkları: yalnız `flutter_test`; **`integration_test` yok**. SDK paketi yerelde var (`/Users/muhammetalicaliskan/development/flutter/packages/integration_test`), `takeScreenshot(name, [args])` var; Android'de `convertFlutterSurfaceToImage()` gerekir, iOS'ta gerekmez. | **Koordinatör ONAYLI**: `dev_dependencies: integration_test: sdk: flutter` eklenir (`pubspec.lock` değişir); ek onay istenmez. |
| Dizin çakışması | `test_integration/` zaten var: **backend ile host VM `flutter test`** (Makefile `integration` hedefi, Docker `up.sh`/`down.sh`), `test_integration/.state/src` backend kaynağı. | Cihaz testi için **ayrı** `integration_test/` (Flutter varsayılanı) kullanılmalı; `make integration` (backend'li host VM akışı) ile **karışmamalı**. **Koordinatör ONAYLI**: Makefile `DART_DIRS`'e `integration_test` eklenir (format/analiz kapsamı); ek onay istenmez. |
| iOS yerel altyapı | `ios/RunnerTests/RunnerTests.swift` (XCTest hedefi) var; `integration_test` iOS eklentisi pod ile gelir. | `flutter test integration_test/<dosya> -d ED5DCAAF-…` (host komutu; CUA/AppleScript gerekmez). |
| Ekran görüntüsü | `IntegrationTestWidgetsFlutterBinding.takeScreenshot` baytları cihazda `Directory.systemTemp/nizamio-tablet-shots/<ad>.png` yazılır; ana makineye `xcrun simctl get_app_container <udid> <bundle> data` yolundan kopyalanır (`simctl` CLI serbest, UI otomasyonu değil). Alternatif: `binding.takeScreenshot` baytlarını `reportData` içinde döndürüp `integrationDriver` ile ana makinede yazmak (`flutter drive`); **iOS'ta `flutter test integration_test` + `reportData` sürücüsüz da çalışır ama dosya çıkarımı sürücü ister.** İkisi de denenmeli; seçim ilk koşuda. | İlk integration dosyası: gerçek uygulama, `Harness`+sahte backend, `MediaQuery` ölçülerini ve ilk ekran PNG'yi yazdırsın. |
| Gerçek uygulama + sahte backend | `harness.dart`: `Composition.create(flavor, secureStore: MemorySecureStore, httpAdapter: FakeBackend, preferenceStore: MemoryPreferenceStore)`; `NizamioApp` flavor dev; bağ doğrulanmış açılır, `signIn()` sahte backend üzerinden gerçek giriş + program seçimi yapar (prototip modu 2026-10-29'da kaldırıldı). Dış ağ çıkmaz (FakeBackend). `test/support/*` `package:nizamio/...` import eder; integration dosyaları `test/support`'u **import edebilir** (aynı paket). | Yeniden kullan; kopyalama yok. Faz kapıları atlanmaz; yönlendirici testlerinde `phase` doğrudan verilir. |
| Etkileşim | `tester.tap/enterText/drag/fling` gerçek simülatörde aynı API; yatay Gantt `drag`, Takvim hücre dokunması, Arşiv/Sohbet `enterText`. Klavye `viewInsets` simülatörde gerçek (donanım klavyesi kapalıysa yazılım klavyesi). | `Scrollable.ensureVisible` ve `pumpAndSettle` yerine **sınırlı** `pump(Duration)` (sürekli animasyon varsa settle takılır). |
| Dönüş | Gerçek cihazda dönüş `SystemChrome`/OS ile; test içinden zorlamak için `tester.view.physicalSize` **simülatörde gerçek pencereyi değiştirmez** (yalnız test görünüm kimliği). Gerçek dönüşü simülatör menüsü/`simctl ui`? — **UI otomasyonu yasak**; bu nedenle gerçek native dönüş **CUA koordinatörü** tarafından yapılır (§6 görev paylaşımı). | I-katmanında ROT senaryoları: Flutter-içi boyut simülasyonu + CUA gerçek dönüş doğrulaması (ayrı kanıt). |
| Dokunma kapsamı | Test, native iPadOS Stage Manager/Split View'ı tetikleyemez (OS). | ROT-08 yalnız W-katmanı + CUA. |
| Süre/kararlılık | Her senaryo ~20–60 sn (derleme dahil ilk koşu 3–6 dk). | Sıralı (`--concurrency=1`), tek simülatör; ağır senaryolar tek `main` altında gruplanır. |

## 6. Test boşlukları ve bloker riskler

**Boşluklar (kaynağa göre):**
1. Takvim: tüm katmanlar yok (U2). Önce domain/örnek veri/denetleyici sözleşmesi → testler (CAL-01…16).
2. Ana bölme kabuğu (ray+390+detay, boş durum, "Bir kayıt seç", seçili kayıt durumu): kod yok → KAB-01/02/03, TSK-06/10, CRD-02/05, ARC-05/09, MSG-03, CAL-08 (YOK/KIRILIR).
3. **Yatay Gantt chart'ı hiç yok** (mevcut chart dikey, U3): tablet düzeni (ray görünür, liste gizli), çip şeridi, Hafta/Ay/Sezon, Tümü/Açık/Geciken, grup daraltma, yapışkan sol sütun (GAN-01…14). Opus uygulayacak; eksik uygulama passed/blocked sayılmaz.
4. Modal biçimi (U5): kaynak ölçü exact assert, odak/dış dokunuş (MOD-01/06/07).
5. Saat/tarih sabitleme (U7): `DateTime.now()` 3 yerde.
6. Seçim/taslak ömürleri: aynı kayıtta resize/sınıf geçişi korunur (ROT-02/11, MSG-05b); sohbet değişiminde temizlik (MSG-05a); modül değişiminde sağ varsayılan (NAV-01).
7. Çapraz gezinme kaynak kuralları (§1.1; NAV-01…09) ve gerçek iPad ölçüleri.
8. Rozet tutarlılığı: ray "Mesajlar 4" ↔ sohbet satırı toplamı (MSG-01/14).

**Bloker/risk:**
- **R1** `autoDispose` denetleyiciler + bölme içi ağaç: sağ panel kapanınca taslak/odak kaybı (`responsive-altyapi.md` limit; yalnız bir sohbet testi kanıtlı).
- **R2** go_router `StatefulNavigationShell`'i kendi `GlobalKey`'iyle taşır (belgelenmiş): bölme düzeni kabuk gövdesine dış anahtar eklemeyi gerektirirse yeniden ebeveynleme/State kaybı; test `shell_resize_test` bunu kırmızıya çevirir (iyi, tutulmalı).
- **R3** `ChatRoute`/`TimelineRoute`/`ArchiveFolderRoute`/`TaskDetailRoute` kök navigator itme rotaları: tablette bölme içine taşınırken `app_nav`/geri davranışı ve mevcut testleri değişir (KIRILIR listesi §3).
- **R4** Linux golden zorunluluğu (ADR-0003 k8): macOS'ta `goldenTestWidgets` atlanır; G1/G2 bu nedenle PNG/ölçü kanıtıdır, golden değil. Golden istenirse Linux CI + referans üretimi (uzak CI KR-27 gerekçesiyle tetiklenmez).
- **R5** `integration_test` bağımlılığı (onaylı) `pubspec.lock`'u değiştirir; `make verify` (format dosya sayısı, kapsama eşikleri, `check_test_presence`) etkilenir; `test_integration/` (backend'li) ile karıştırılmaz.
- **R6** Referans AX yalnız 21 Ekim 2026 veri durumunda; örnek veri depoları Opus değişikliğiyle farklı sayılar üretirse (ör. 76 görev, 38 kayıt) karşılaştırma anlamsız. Sayılar `fixture` olarak sabitlenmeli.
- **R7** Gerçek cihaz ölçüsü doğrulanmadı (≈1376×1032 varsayımı); iPadOS 26 pencere modu `viewPadding` üstte beklenmedik boşluk verebilir.
- **R8** CUA, "native UI kontrolü" için koordinatörde; Sonnet/test tarafında dönüş/Split View **yapılamaz**.

## 7. Sayım

| Modül | Senaryo | VAR | KISMEN | YOK | KIRILIR* | Kapsam dışı |
|---|---:|---:|---:|---:|---:|---:|
| KAB | 10 | 2 | 5 | 1 | 2 | 0 |
| HOM | 7 | 1 | 4 | 0 | 2 | 0 |
| TSK | 13 | 7 | 2 | 3 | 1 | 0 |
| CAL | 16 | 0 | 0 | 15 | 0 | 1 (CAL-12) |
| CRD | 7 | 2 | 1 | 3 | 1 | 0 |
| ARC | 11 | 5 | 4 | 1 | 1 | 0 |
| MSG | 15 | 8 | 4 | 2 | 1 | 0 |
| GAN | 15 | 0 | 1 | 14 | 0 | 0 |
| MOD | 10 | 4 | 3 | 3 | 0 | 0 |
| NAV | 9 | 0 | 4 | 5 | 0 | 0 |
| ROT | 14 | 6 | 4 | 3 | 1 | 0 |
| **Toplam** | **127** | **35** | **32** | **50** | **9** | **1** |

\* Sütunlar satırın baskın durumuna göre tek sayılır; "KIRILIR/KISMEN" karışık satırlar KIRILIR'a yazıldı. 123 satır korunmadı: yeni senaryolar eklendi (TSK-13, MSG-05a/b, GAN-08b, NAV-09), CAL-12 kapsam dışı. Sayımlar elle çıkarıldı, test yazılırken yeniden sayılmalı.

Görsel kapı ekranları: 8 referans (home, tasks, calendar, coordinatorships, archive, messages, gantt, task-create) + 4 önerilen (login, drawer, archive-folder, chat) = 12; ölçek: G1 (1180×820) + G2 (≈1376×1032).

## 8. Sonraki somut test adımları (öncelik sırası)

1. **Ölçü keşfi (I)**: boş integration dosyası ile cihazda `MediaQuery.size/dpr/viewPadding` ve `takeScreenshot` yolu doğrulanır (§5), çıktı bu belgenin U6/G2'sine işlenir. (`integration_test` dev bağımlılığı ve Makefile `DART_DIRS` onaylı; Opus ikinci tur kodu bitince.)
2. **Ortak test düzeneği (W)**: `test/support/tablet_harness.dart` (1180×820 ve 1376×1032 `ScreenSize`, sabit saat/örnek veri sabitlemesi, çağrı sayaçlı depo sarmalayıcıları, `getRect` yardımcıları, PNG yazıcı).
3. **G3 ölçü sözleşmesi + KAB-01…04** (Opus kabuğu bitince): ray 100 / liste 390 / hap / alt blok.
4. **Seçim-sağ-panel testleri**: TSK-06/10, CRD-02/05, ARC-05/09, MSG-03/05a/05b, HOM-04/05, NAV-01/04/08/09 (+ güncellenen KIRILIR testleri).
5. **ROT paketi**: ROT-01…08, 11 tek uygulama/yönlendirici deseniyle (`shell_resize_test` genişletilmiş; modül başına sayaçlı repository).
6. **Gantt** (yatay chart Opus'ta bitince): GAN-01…14, ardından NAV-02/03.
7. **Takvim** (Opus uygulayınca): CAL-01…16 (CAL-12 hariç; önce domain birim testi, sonra widget).
8. **MOD paketi**: modal ölçüsü, odak/kapama, form değerleri dönüşte.
9. **G1 → G2**: 12 ekran PNG + ölçü.json, ardından cihaz; normalizasyon listesi raporda.
10. Açık karar yok: modal ölçüsü, ölçek/süzgeç adları, renk/ikon prototipte ne ise odur; görsel fark eşiği tanımlanmaz (§4.1).

Not: Bu belge dışında dosya yazılmadı; `flutter test/build`, alt ajan, commit, push, branch, backend ya da yönetim deposu işlemi yapılmadı. Native UI kontrolü (dönüş, Split View, Stage Manager) CUA koordinatörde.

## 9. Test altyapısı (yazıldı, 2026-10-29) — cihaz koşumu HENÜZ YAPILMADI

| Dosya | İçerik |
|---|---|
| `test/support/tablet_harness.dart` | `TabletContract` (HTML literal'leri: ray 100 · liste 390 + 1 kenar · sağ kalan; modal `min(560, W−48)`; 6 ray modülü; Gantt Hafta/Ay/Sezon, Tümü/Açık/Geciken), `TabletModule` (TB_DEF varsayılanları), `TabletSession` (gerçek `NizamioApp` + `Harness(flavor: dev, PilotBackend)`, boş "Giriş yap", bulucular, rect ve ölçü JSON'u), `tabletScenes` (14 sahne, aynı gövde host ve cihazda), `pumpBounded`, `captureScene` (PNG + JSON). `screen_matrix.dart` ve `harness.dart` değişmedi. |
| `test/app/tablet_measurements_test.dart` | Host: 14 sahne × 1180×820 koyu, 4 açık tema, 5 ölçüye-göre-bölme boyutu (1180×820, 1376×1032, 1032×1376 çift; 820×1180 tek bölme; 599×900 mobil), tek uygulamada 1180→820→1032 geçişi. |
| `integration_test/tablet_visual_test.dart` | Cihaz: aynı sahneler koyu + açık (`-light`), görünüm boyutu AYARLANMAZ; PNG `takeScreenshot` (reportData temizlenir) + `<sahne>.json` (fiziksel/mantıksal boyut, dpr, safe area/viewPadding/viewInsets, SIMULATOR_UDID, ray/liste/sağ/modal rect) `systemTemp/nizamio-tablet-shots/` altına. Dikey yeniden koşum için `--dart-define=NIZAMIO_SHOT_TAG=portrait`. |
| `pubspec.yaml`/`pubspec.lock` | yalnız `integration_test: sdk: flutter` (+ geçişli `flutter_driver`, `fuchsia_remote_debug_protocol`, `sync_http`, `webdriver`; başka yükseltme yok). |
| `Makefile` | `DART_DIRS`'e `integration_test`. |

Kanıt durumu (bu tur): `dart format` temiz, `flutter analyze` (3 dosya) temiz, yalnız `tablet_measurements_test.dart` host'ta koşuldu: **19 geçti, 5 kırmızı**. Kırmızılar eksik özelliktir (atlanmadı): `calendar` (takvim yok; Takvim ray öğesi şimdilik tost veriyor), `gantt` ve `gantt-open-task` (yatay Gantt yok; mevcut dikey çizelge kök rotada, ray kayboluyor), `task-create` ve `task-create-light` (merkezi `Dialog` modal yok). Cihaz derlemesi/koşumu ve tam `make verify` çalıştırılmadı; hiçbir ekran görüntüsü alınmadı; "birebir aynı" iddiası yoktur.

Bilinen sınırlar ve açık maddeler:
- Örnek veri adları referanstan farklı: referans "Kadir Özbek / Bahar Kılıç / Reha Koçak" vs örnek depo "Kerem Özdal / Bengü Kılınç / Rıza Karaca" (sohbet kimlikleri `kadir`…). Görsel/içerik birebirliği için Opus'un örnek veriyi referansa hizalaması gerekir; sohbet sahnesi bu yüzden kişi adına bağlanmaz.
- Ana sayfa `DateTime.now()` (U7) Opus'un sonraki turuna bırakıldı; test sahteleme eklemedi.
- Modal yarıçapı (28) kart `Material`ından okunamazsa assert edilmiyor (JSON'a yazılmaz); modal genişlik/ortalama/yükseklik exact.
- Gantt/Takvim sahneleri şimdilik UI etiketleriyle (`Geri: Görevler`, `Seçili görev`, `Görev ayrıntısını aç`, `Hafta/Ay/Sezon`, `Takvim`, `Bir kayıt seç`) yazıldı; Opus farklı metin üretirse sahne güncellenir, silinmez.
- Rail ve bölme rect'i `NzTabletRail` / `NzPaneScope` (Opus tipleri) üzerinden okunur; yeniden adlandırılırsa derleme kırılır.
- `tasks-select`: tembel liste nedeniyle ALT-5 kartı kaydırmayla dışarıda kalabilir; "sol liste yerinde" seçilen kart ve komşusuyla sınanır.

## 10. Kaynak ↔ üretim karşılaştırması (2026-10-29, salt okunur; HİÇBİR TEST BU TURDA KOŞULMADI)

Karşılaştırma `12-Tablet.dc.html` ile `lib/app/router/{split,shell,routes}.dart`, `lib/features/calendar/**`, `lib/features/timeline/**` ve örnek veri dosyaları arasında kod okuyarak yapıldı. Aşağıdakiler gözlemdir; kanıtı bir sonraki host+cihaz turunda sahneler verecek. Gantt `keepAlive`/kapat vuruş alanı (Opus), font aileleri (core) bilerek yok.

### 10.1 Kaynakla UYUMLU görünen mekanizmalar (okuma; test bekliyor)

| Kaynak | Üretim | Sahne |
|---|---|---|
| `tgo(modül dışı)`: tür-bazlı yığın, tepede aynı → `rHide`, geride → pop, yoksa push (HTML 3823–3830) | `splitMove` (`split.dart`: `lastIndexWhere` tür, `SplitRefresh`, taban yer değiştirme, `trail.take`) | `nav-cross-feature-keeps-left-module`, `nav-same-module-rail-pops-to-base` |
| Aynı modüle ray: yığın>1 → `[TB_DEF]` (3819) | `_selectRail` (`shell.dart`: iz doluysa `withTrail(_uri, [])`) | aynı |
| Alt ekran durumu kalıcı: modüle dönünce son yüklenen kayıt (2401–2404, 3812–3813) | `SplitMemory.lastIds` + `_remember` | `nav-module-roundtrip-keeps-last-loaded-record` |
| `closeGantt`: `full:null`, mod/rs aynı (3807); aynı modüle ray Gantt'ı kapatır, başka modül gider (3817–3819) | `TimelineHost` (`closeTimeline` pop; `onSelect`) | `gantt-close-keeps-module-and-selection`, `gantt-rail-same-module-closes-other-module-leaves` |
| `openTaskFromGantt`: `mod:'tasks'`, `rs:['detail']` (3808) | `routes.dart:339-340` `go(TaskDetailRoute)` (iz yok) | `gantt-open-task-resets-stack-to-tasks` |
| `S_cal`: `pick/goToday/toggleMode/step` (3482–3490) | `calendar_controller.dart` aynı kurallar (bugünün ayında adım → bugün, değilse ayın 1'i; hafta ±7) | `calendar-mode-step-today`, `calendar-selection-survives-module-roundtrip` |
| Takvim önizleme: Gruba yaz→`openChat`, bağlı görev/koordinatörlük bağlantıları, 260 ms (3470–3480) | `calendar_preview_sheet.dart:85-106` | `calendar-meeting-preview-and-write-to-group` |
| Merkezi modal `min(560, W−48)`, `max-h H−64`, r28 (HTML 73–74) | `nz_bottom_sheet.dart:88-112` (`Dialog` + `SizedBox(560)`, inset 24/32, radius `NizamioRadius.sheet`=28) | `task-create`, `calendar-plan-meeting-modal-prefilled` |

### 10.2 Uygulamaya HENÜZ geçmeyen / şüpheli farklar (önem sırasıyla)

1. **[Engelleyici] Üretilmiş yerelleştirme eksik.** `i18n/ui/calendar.tr.json` var, ama `lib/core/i18n/arb/app_tr.arb`, `app_localizations*.dart` içinde `uiCalendar*` anahtarı **0** (grep sayımı). `calendar_texts.dart` (`uiCalendarWeekdaysShort`, `uiCalendarCollapse`…) `make gen` yapılmadan derlenemez; yatay Gantt metinleri için de `gen-check` gerekir. Bu turda `make gen` çalıştırılmadı (paylaşılan üretim yasağı).
2. **[Yüksek] Ray "Mesajlar" rozeti başlangıç değeri.** Kaynak kurucusu `chat.load('koord')`'u sessiz çağırır (HTML 3813) → Koordinatörler baştan okunmuş, ana sayfada rozet **4** (referans AX `Mesajlar · 4`). Örnek veri `sample_chat_repository.dart:107-108` `koord` için `unread: 1, mention: true` verir ve sohbet yalnız `ChatPage` açılınca okunur (`chat_page.dart:90-92`) → Mesajlar'a girilmeden rozet **5** beklenir (mevcut `messages_page_test` "okunmamış 5" ile uyumlu). `home` sahnesi `Mesajlar · 4` ister; kırmızı ise bu fark kanıtıdır.
3. **[Yüksek, doğrulanmadı] Sohbet değişiminde taslak sıfırlanması.** Kaynak `S_chat.load` taslak/yanıt/düzenleme/`refs`'i sıfırlar (3216). Üretimde taslak `ChatPage` State'indeki `_draft` denetleyicisindedir (`chat_page.dart:48`); `PaneStack` taban sayfasını sabit `'base'` anahtarıyla taşır (`split.dart` `_codes`), iz girişlerini ise `'$i:${e.code}'` (kimlik içerir) → sohbet **tabanda** değişirse State yeniden kullanılıp taslak diğer sohbete sızabilir. `chat-switch-resets-draft` karar verir. Çözüm (Opus): sohbet sayfasını kimlikle anahtarlamak; **aynı sohbette yeniden boyut korunması** (`AYNI sohbette resize…` testi) bozulmamalı.
4. **[Orta] Örnek veri kişi adları kaynaktan farklı (tümü).** Örn. `sample_task_data.dart:9-24` (Elif Nur Karaağaçlı ↔ Muhammet Ali Çalışkan, Mert Yavuz Kaynak ↔ Mevlüt Yunus Kayacan, Kerem Özdal ↔ Kadir Özbek, Rıza Karaca ↔ Reha Koçak, Bengü Kılınç ↔ Bahar Kılıç…), `sample_chat_repository.dart:174-250` (sohbet adları ve `@Elif Nur trafo onayı…` ↔ `@Muhammet Ali…`), ayrıca activity/home/coord metinleri. Yapı, kodlar, başlıklar, sayılar (79/39, 76 görev, 11 klasör/227 dosya/559,3 MB, takvim 12 toplantı/9 talep/8 tablo) kaynakla aynı görünüyor. Kişi adları kasıtlı mı? Kasıtsızsa görsel/içerik birebirliği için hizalanmalı; kasıtlıysa referans karşılaştırmasında kişi metinleri "istisna" olarak yazılmalıdır. Sahneler kişi adına bağlanmaz.
5. **[Orta] Home açılışı `DateTime.now()`** (bilinen, Opus sonraki turu): kaynak sabit 21 Ekim 2026.
6. **[Düşük] Modül gidiş-dönüşünde liste (master) alt durumu.** Kaynakta `S_tasks.q` vb. kalıcı; üretimde liste sayfası modül değişince sökülür (`shell.dart` `NzPaneTransition(key: current)`), kalıcılık `keepAlive` denetleyicilere bağlı; arama alanı metninin `TextEditingController` State'i yeniden kurulur. `master-search-survives-module-roundtrip` alan metni ve süzgeç tutarlılığını sınar.
7. **[Düşük] Modal çevre çizgisi (1 px `border-strong`)**: `Dialog` şeklinde `BorderSide` yok (`nz_bottom_sheet.dart:92-98`); çizgi `NzBottomSheetContent(modal: true)` içinde çiziliyorsa tamam; sahne yalnız genişlik/yükseklik/ortalama/yarıçapı assert eder, çizgiyi cihaz görüntüsü karşılaştırması gösterir.
8. **[Bilgi] 600–839 genişlikte** SVG ikon/merkezi modal/ortalı giriş kuralları uygulanmaz (`nz_pane.dart:84` `tabletVisualAt = splitsAt`); kaynakta bu aralık tanımsız, bilinçli.

### 10.3 Bu turda hazırlanan sahneler (invariant; implementasyon aynası değil)

`tabletInvariantScenes` (`tablet_harness.dart`, host 1180×820 ve cihazda görüntüsüz koşar): `nav-cross-feature-keeps-left-module`, `nav-same-module-rail-pops-to-base`, `nav-module-roundtrip-keeps-last-loaded-record`, `master-search-survives-module-roundtrip`, `chat-switch-resets-draft`, `gantt-close-keeps-module-and-selection`, `gantt-rail-same-module-closes-other-module-leaves`, `gantt-open-task-resets-stack-to-tasks`, `calendar-default-today-and-month`, `calendar-mode-step-today`, `calendar-selection-survives-module-roundtrip`, `calendar-meeting-preview-and-write-to-group`, `calendar-task-row-opens-detail-keeps-left`, `calendar-plan-meeting-modal-prefilled` (14) + host testi `AYNI sohbette resize/dönüş taslağı korur`. `home` sahnesine referans AX'ten rozet `Mesajlar · 4`, zil etiketi ve `79 görevin 39` eklendi; `task-create` modal köşe yarıçapını (28) okunabiliyorsa assert eder.

Durum: `dart format` ve `flutter analyze` (3 dosya) temiz. Hiçbir host/cihaz testi bu turda koşulmadı; "127 senaryo geçti", görsel parity ya da Gantt/Takvim çalışıyor iddiası yoktur. Takvim sahneleri `make gen` sonrası derlenen kodu bekler.

## 11. Harness düzeltme turu (2026-10-29) — HAZIRLIK, koşulmadı

Opus tur-2 izole tam koşusu (rapor `/tmp/nizamio-tablet-opus-wire-result.json`): 1620 geçti, 5 kırmızı; kırmızıların hepsi bu düzenekte. Ele alınış (yalnız `dart format` + dosya `flutter analyze` temiz; host/cihaz testi koşulmadı, geçti iddiası yok):

| Kırmızı | Neden | Düzeltme |
|---|---|---|
| `home` ve `home-light` (`Mesajlar · 4` bekleniyor, 5 geliyor) | Gerçek kaynak/fixture farkı (§10.2-2) | Assertion **korundu**; Opus son bağlamada örnek veriyi düzeltecek |
| `chat-reply` | Gönder düğmesi artık `NzIcon`; `Icons.arrow_upward_rounded` bulunamıyor | `find.bySemanticsLabel('Gönder')` ile bulunuyor |
| `gantt` | Kaynakta süzgeç `Geciken · N` (referans 15); düzenek `'Geciken'` bekliyordu | `TabletContract.ganttLateFilter = RegExp(r'^Geciken · 15$')`, semantik etiketle |
| `gantt-close-keeps-module-and-selection` | `tapText`→`ensureVisible` listeyi kaydırınca tembel liste tepedeki "Zaman çizelgesi" hapını kurmuyor | `openTimelineFromTasks`: hap yoksa Görevler master'ının dikey `Scrollable`ını `scrollUntilVisible(-300)` ile başa kaydırır (kullanıcı akışı); üretim listesi tembel kalır. Altı Gantt sahnesi bunu kullanır |
| (5.) `gantt-rail-same-module…` / ilgili sahne | Aynı hap bulucu | Aynı yardımcı |

Yeni sahneler / testler:
- **`chat-same-reselect-follows-source`** (invariant) ve host testi **modal açıkken görev başlığı taslağı yeniden boyut/dönüşte korunur** (820×1180 → 1032×1376 → 1180×820, modal açık kalır, taslak ve sınır korunur, `Dialog` ölçüsü sınırı aşmaz). Mevcut `AYNI sohbette resize…` testi kalır.
- **Koordinatöre not (kaynakla çelişen talimat):** istenen "aynı sohbet yeniden seçiminde taslak/yanıt korunur" kaynakta YOK. `S_chat.load` (HTML 3212–3216) `id` aynı olsa da `draft:''`, `reply:null`, `edit:null`, `refs:[]` yazar (aynı-kimlik koruması yoktur; `S_detail.load` 2402'deki gibi bir `return` bulunmaz) ve her seçim `openChat` (3204, 3517) üzerinden `load`'u çağırır. `rHide` yalnız yeniden çizer. Bu yüzden sahne kaynağı izler: aynı sohbeti satırdan yeniden seçmek taslağı **temizler**, mesajlar kalır, yığın büyümez; **yeniden boyut** ise taslağı korur (ayrı onaylı kural). Opus tur-2 raporu "aynı sohbette korunuyor" diyor; bu, resize için doğru, satır yeniden seçimi için kaynaktan sapmadır. Karar koordinatörde: kaynak mı, ürün tercihi mi.
- Yazı tipi: `loadAppFonts` ek çağrısı veya ikinci yükleyici yazılmadı; ana yazı tipi çözümü Opus'ta, native manifest otomatik yüklenir.

## 12. "okunmamış mesajlar" ayırıcısı sözleşmesi (2026-10-29) — HAZIRLIK, koşulmadı

Kaynak kanıtı (HTML): kurucu `quiet(chat, load('koord'))` (3813) → `load` (3213–3215) `unread=1` iken `nb = msgs[max(0,len−unread)]` = **k2**, `c._newBefore = nb`, ardından `unread=0`, `mention=false` → ray rozeti 4. Ayırıcı `c._newBefore === m.id` ile k2'nin önüne konur (3252; metin `okunmamış mesajlar` = `uiMessagesNewMessages`). İlk Mesajlar ray seçimi `tgo('messages')` (3815–3831) `load` çağırmaz → ayırıcı k1 (08:40) ile k2 (09:51) arasında kalır. Aynı satırın yeniden seçilmesi `load('koord')`'u tekrar çağırır: `unread=0` ⇒ `nb=null` ⇒ ayırıcı kaybolur (+ taslak sıfırlanır). Gönderme `_newBefore=null` yapar (3394). Kök çıkarımı doğrulandı.

Üretim riski (okuma): fixture'da yalnız `koord.unread` 0 yapılırsa `unreadMarkerOf` (`chat_logic.dart:179`) `null` döner ve varsayılan sohbette ayırıcı hiç görünmez. Bu yüzden ortak yardımcı `expectUnreadDivider(s, present:)` üç **farklı** beklentide kullanılır:

| Sahne/test | Beklenti |
|---|---|
| `messages` (referans sahnesi) | rozet `Mesajlar · 4` **ve** ayırıcı var, k1–k2 arasında (dikey sıra rect ile) |
| `chat-same-reselect-follows-source` | önce ayırıcı var; aynı satır yeniden seçilince ayırıcı **yok** ve taslak boş |
| host `AYNI sohbette resize/dönüş…` | ayırıcı başta var ve her yeniden boyuttan sonra **hâlâ var**, taslak korunur |

Gönderme/başka sohbet davranışına dokunulmadı. Test koşulmadı; geçti iddiası yok. `home` sahnesindeki `Mesajlar · 4` assertion'ı aynen duruyor.

## 13. Sohbet durumu sözleşmesi ve kaynak DOM geometrisi (2026-10-29) — HAZIRLIK, koşulmadı

**Sohbet (tek sözleşme, §1.1 ile aynı; eski çelişkili ifadeler kaldırıldı).** Kaynak: `S_chat.load` (3212–3216) aynı kimlikte de çalışır (koruma yok), `openChat` her satır seçiminde onu çağırır (3204, 3517). Kurucu `quiet(load('koord'))` `_newBefore='k2'` hesaplar; ilk Mesajlar ray seçimi (`tgo`) `load` çağırmaz.

| Olay | Taslak/yanıt | "okunmamış mesajlar" ayırıcısı |
|---|---|---|
| İlk Mesajlar ray seçimi | boş | k1 ile k2 arasında (varsayılan sohbet) |
| Sohbet SATIRINI (aynı ya da başka) seçmek | **sıfırlanır** | aynı satır: kaybolur (`unread=0 ⇒ nb=null`) |
| Yeniden BOYUT/dönüş (onaylı responsive kuralı) | **korunur** (denetleyici nesnesi aynı) | **korunur** |
| Görev atfı `#ALT-7` (yalnız sağ yığına `detail`) | dokunulmaz | dokunulmaz |

Sahneler: `messages` (ayırıcı var), `chat-same-reselect-follows-source` (satır seçimi sonrası ayırıcı yok, taslak boş), host `AYNI sohbette resize…` (taslak ve ayırıcı korunur). Ayırıcı bulucuları sağ bölmeyle sınırlandı (sol önizleme aynı metni taşır); k1 < ayırıcı < k2 dikey sırası gevşetilmedi (3 kırmızıdan biri bu bulucuydu).

**Kaynak DOM geometrisi** (`/tmp/nizamio-tablet-reference/*.metrics.json`, 1180×820; ölçüler bölme kökünden, yani native güvenli alan `pane.top` kendiliğinden eklenir; ~1.5 pt tolerans, büyük sapma gizlenmez; üretim sabitleri kopyalanmadı):

| Sahne | Doğrulanan (bölme-göreli) |
|---|---|
| `messages` / sohbet (her genişlik) | satır sol 12, genişlik `pane−24`; ilk satır üstü 126 (başlık 64 + üst boşluk 8 + gün dolgusu 12/8 + hap 26 + ilk mesaj `mt 8`); `k2.top − k1.bottom = 52` (ayırıcı 28 + 10/6 + `mt 8`); saat gövde metniyle aynı sağ kenarda, solda değil. **Yalnız sağ bölme 689 iken (kanonik 1180):** k1 665×102.5, k2 üst 280.5 665×103.5, saat sağı `satır.left + 558`. iPad Pro 13" yatayda sağ bölme ≈885, satır ≈861: gerçek duyarlı uyarlama, daha az metin satırı sığar; yükseklikler 102.5/103.5 sayılmaz, görünüm 1180'e zorlanmaz |
| `messages` / gelen kutusu | ilk satır sol 8, üst 120, 374×71.5; başlık sol 80, üst 132, yükseklik 20; saat sağ kenarı 374, üst 133.5 |
| `home` | KPI 174×150 (sol 16/200, üst 136/296), hızlı işlem 83.5×90 (sol 16/107.5/199/290.5, üst 496), rol kartı 114×88 (sol 16/138/260, üst 636), "Yeni görev" etiketi satır yüksekliği 16 |
| `tasks` | Tümü kutucuğu 175×78 (sol 16, üst 144; eski 171 yanlış), Geciken 83.5×78 (sol 199) |

Liste bölmesi 390 sabit olduğundan Ana sayfa/Görevler/gelen kutusu geometrisi cihazda kanonikle aynıdır (`_expectFixedMaster` farklı genişlikte karşılaştırmayı geçersiz sayar). 600 genişlik tek-bölme ayrı yerleşimdir, bu sahneler orada koşmaz. Eski R3 değerleri (148/88/86) uydurma sayılmaz; yalnız kaynak ölçüsü geçerlidir. Bilinen sınırlar: semantik bulucular sarmalayıcı kutuyu ölçer (renkli balon yerine `NzChatBubble` tam satırı 665); saat/metin genişlikleri font bağımlıdır, bu yüzden yalnız kenar/yükseklik doğrulanır. Gerçek host/cihaz koşumu ve ekran görüntüsü yok; geçti iddiası yok.

## 14. Gerçek host koşumu (2026-10-29, üretim donmuş) — NATIVE KOŞULMADI

Harness düzeltmeleri (yalnız sahipli dosyalar): `expectUnreadDivider`/`expectChatSourceGeometry` bulucuları `ChatPage` torunuyla sınırlandı (820×1180 tek bölmede `NzPaneScope.role == null`); `tapText` önce `hitTestable()` bakar, yalnız görünmüyorsa `ensureVisible`; `chat-reply` gönderim sonrası `pump(2 s)`+settle (500 ms tek tik / 1600 ms okundu); `chat-same-reselect-follows-source` önce gerçek UI ile k2'ye Yanıtla + taslak, sonra aynı satır yeniden seçimi ⇒ ayırıcı yok, taslak boş, yanıt çipi yok; resize testi yanıt çipini de korumayı sınar. `test/flutter_test_config.dart` (gerçek yazı tipleri) zaten mevcuttu, dokunulmadı.

| Koşum | Sonuç |
|---|---|
| `tablet_measurements_test.dart` (41 test: 14 sahne koyu, 4 açık, 14 değişmez + modal/resize, 5 boyut + geçiş) | **40 geçti, 1 KIRMIZI** (`/tmp/nizamio-tablet-sonnet-host1.log`) |
| calendar + timeline + split + shell_split/motion/resize + orientation + core motion | **149 geçti, 0 kırmızı** (`/tmp/nizamio-tablet-sonnet-host2.log`) |

Kırmızı: `chat-same-reselect-follows-source` — aynı sohbet satırı yeniden seçilince **yanıt bağlamı çipi ("Reha Koçak kişisine yanıt") kalıyor**; ayırıcı kayboluyor ve taslak boşalıyor (o assert'ler çipten önce geçti). Kaynak `S_chat.load` `reply:null` (HTML 3216). Kök (okuma + kanıt): `ChatPage` State yeniden kuruluyor (taslak sıfırlanıyor), ama aynı `chatControllerProvider(id)` görünüm durumu (autoDispose, dinleyici o karede canlı) `reply`'ı koruyor. Düzeltme Opus'ta: görünüm durumuna UI niyetli sıfırlama komutu (backend/Inbox yenilemesi değil).

Uyarı (hata değil): Gantt çubuğu bulucusu `^ALT-5 ·` / `^MEK-6 ·` merkezi dokunuşta `would not hit test` uyarısı veriyor (dokunuş TextSpan'e düşüyor), testler yine de geçiyor; çubuk semantik sarmalayıcısının ortası ile asıl vuruş alanı örtüşmüyor olabilir (Opus Gantt kapat/vuruş alanı işine not).

Native iPad koşumu başlatılmadı (host kırmızı olduğundan talimat gereği). Hiçbir ekran görüntüsü/JSON alınmadı; görsel birebirlik hükmü yok.

## 15. Retest + gerçek iPad native koşumu (2026-10-29, üretim donmuş)

Opus yanıt-sıfırlama düzeltmesi (`/tmp/nizamio-tablet-opus-reply-reset-result.json`) sonrası. Harness düzeltmeleri (yalnız sahipli dosyalar, assertion gevşetilmedi): (1) **Gantt çubuk dokunuşu** `tapGanttBar`: çubuk ∩ görünüm penceresi − yapışkan etiket sütunu (`labelsKey` sağı) kesişimi ölçülür, gerekirse kullanıcı gibi dikey `ensureVisible` + yatay sürükleme yapılır, dokunuş yolunun çubuğun render nesnesini içerdiği kanıtlanır, sonra `tapAt` (önceki `would not hit test` uyarısı ortadan kalktı; log'da 0). Etiketten seçim ayrı invariant `gantt-label-selects-task` (`labelsKey` torunu); çubuktan seçim/Görev ayrıntısı akışı `gantt-open-task` ve `gantt-open-task-resets-stack-to-tasks` sahnelerinde. (2) **Native güvenli alan**: kaynak dikey konumları pencere üstünden başlar, iPad'de bölme içeriği `viewPadding.top` (ölçülen **32 pt**) altında başlar; ilk native koşuda altı geometri sahnesi tam 32 pt farkla kırmızıydı (`home`, `tasks`, `messages` × koyu/açık). `TabletSession.safeTop` bölme başlangıcına eklendi (host'ta 0, tolerans 1.5 değişmedi).

| Koşum | Sonuç |
|---|---|
| Host hedefli (`tablet_measurements` + calendar + timeline + messages + split/shell_split/shell_motion/shell_resize/transitions + orientation + core motion) | **231 geçti, 0 kırmızı** (`/tmp/nizamio-tablet-sonnet-host-retest.log`); güvenli alan düzeltmesi sonrası `tablet_measurements` yeniden: 42 geçti |
| Native iPad Pro 13 M5 / iPadOS 26.3 (`ED5DCAAF-…`), ilk koşum | 38 geçti, **6 kırmızı** (hepsi +32 pt güvenli alan; harness hatası) |
| Native, düzeltme sonrası (`--no-uninstall`, `/tmp/nizamio-tablet-sonnet-native.log`) | **44 geçti, 0 kırmızı** (14 sahne × koyu/açık + 16 invariant) |

Native ölçümler (28 PNG + 28 JSON, `/tmp/nizamio-tablet-native-landscape/`; 14 sahne × koyu/açık; invariant'lar görüntü üretmez): hepsinde `hostControlled=false`, fiziksel 2752×2064, DPR 2, mantıksal **1376×1032**, yön landscape, PNG **2752×2064** (landscape, mantıksal×2), `deviceId=ED5DCAAF-…`, güvenli alan üst 32 / alt 20 (bazı sahnelerde alt 0), `pump.idle=true` (hepsi). Çift bölme: ray 100, liste 390, sağ bölme x=491, **genişlik 885** (≠ 689 kanonik); `gantt` sahnesinde liste/sağ yok (tam genişlik), ray var. Görünüm üzerinde hiçbir override yapılmadı. `--no-uninstall` yalnız çıktıların konteynerden kopyalanabilmesi içindi (uygulama simülatörde kurulu kaldı).

Yapılmayanlar: görsel birebirlik hükmü yok (PNG'ler üretildi; koordinatör/Fable karşılaştıracak); dikey (portrait) yeniden koşum; tam `make verify`. Metadata değişikliği: pod/Runner kaynağına dokunulmadı.
