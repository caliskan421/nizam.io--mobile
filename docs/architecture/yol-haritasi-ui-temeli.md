# Yol haritası — UI temeli (MOB-UI-0)

- **Durum:** Kabul (2026-10-14, MOB-UI-0 O1; kararlar ve ölçümler
  [ADR-0003](adr-0003-ui-temeli.md)) · program dışı çalışma (D-0174: ekranlar program dışı)
- **Yürütme:** dalga planı ve oturum istemleri [`docs/yurutme/mob-ui-0/`](../yurutme/mob-ui-0/README.md)
- **Önkoşul:** MOB-0 kapandı (F14). Tasarım henüz yok → bu çalışma **tasarımdan bağımsız
  anlamsal katmanı** kurar; tasarım geldiğinde yalnız token'lar ve kit içi değişir, ekranlar
  değişmez.

## 0. Mevcut durum — ne var, ne yok

| Alan | Var (MOB-0) | Eksik |
|---|---|---|
| DI | get_it bileşim kökü + Riverpod portları (ADR-0001) | — |
| HTTP / DTO | dio + OpenAPI'den freezed DTO + retrofit istemci; `ApiError` tek hata biçimi; `errorText` | Sayfalama/liste modeli, domain eşleme kalıbının yazılı standardı |
| Durum | `AppPhase` makinesi; `ValueNotifier` → Riverpod köprüsü (`_listen`) | Ekran durumu kalıbı (AsyncNotifier), form, yan etki dinleme |
| Router | Fazdan türetilen yönlendirme, boş yer tutucu rotalar | Tipli rotalar, kabuk (sekme/ray), feature rota kaydı |
| Tercih | `AppPreferences` (yalnız tema), sabit anahtar | Genellenmiş tipli anahtar, dil, diğer tercihler |
| Tema | `tokens.gen.dart` (renk rolleri, palet, boşluk, yarıçap, tipografi); `ThemeData` `app.dart` içinde satır içi | Tema kurucusu, metin stilleri, bileşen temaları, context erişimleri |
| Layout | — | Kırılma noktaları, pencere sınıfı, uyarlanabilir yardımcılar |
| Widget kiti | — | Tamamı |
| Ağ durumu | `ApiError` ağ/TLS kodları | Bağlantı izleyici, çevrimdışı şerit |
| Sınır kuralı | B/D/S/U1/G/A kuralları | UI kuralları (ham renk, ham TextStyle, `MediaQuery.of`) |

## 1. Temel ilkeler

1. **Ekran ham değer görmez.** Ekran kodu `Color(0x…)`, `Colors.*`, `TextStyle(...)`, sayı
   literal boşluk/yarıçap kullanmaz; yalnız anlamsal rol (`context.colors.textMuted`,
   `context.text.titleMd`, `NzGap.md`). Tasarım geldiğinde değişiklik `tokens.json` (web ile
   tek kaynak) + `make gen` + kit içidir.
2. **Kalıtım değil bileşim.** "Base view" soyut sınıf hiyerarşisi kurulmaz
   (`abstract class BaseView<VM>` Riverpod'un tipli sağlayıcılarıyla çatışır, test zorlaşır).
   Yerine: tek kabuk widget'ı (`NzPage`) + durum görünümü (`NzAsyncView`) + `WidgetRef`
   extension'ları. Bağlanma bir satırdır, tekrar yoktur.
3. **Kural kodla zorlanır.** Her yeni standart `tool/boundaries.dart`'a kural + negatif test
   olarak girer (U1 emsali). Belgede kalıp, CI'da kural.
4. **Mevcut katman yönü korunur.** presentation → application → data → domain; DTO yalnız
   `data`'da (A1). Yeni UI temeli `lib/core/ui/` altındadır (core → features yasak, B1).
5. **Ölçeğe göre kalıp.** Basit olan basit kalır: yerel geçici durum `StatefulWidget`,
   ekran durumu Riverpod notifier, uygulama geneli durum mevcut controller + port.

## 2. Hedef dizin düzeni

```text
lib/core/ui/
  theme/
    app_theme.dart            ThemeData kurucusu (token → ColorScheme, TextTheme, bileşen temaları)
    nz_text_styles.dart       ThemeExtension: anlamsal metin rolleri (display/title/body/label/caption/mono)
    nz_spacing.dart           NzGap / NzInsets kısayolları (token'dan, const)
  layout/
    breakpoints.dart          WindowClass {compact, medium, expanded} + eşikler
    adaptive.dart             AdaptiveValue<T>, AdaptiveBuilder, NzContentWidth (azami genişlik)
  extensions/
    context_ext.dart          context.colors / text / layout / l10n / theme
    ref_ext.dart              ref.listenErrors(...), ref.listenSuccess(...)
  state/
    nz_async_view.dart        AsyncValue<T> → yükleniyor / hata (errorText) / boş / veri
  page/
    nz_page.dart              sayfa kabuğu: scaffold + safe area + uyarlanabilir dolgu + çevrimdışı şerit
  widgets/
    buttons/ inputs/ feedback/ surfaces/ lists/ overlays/   (kit; §5)
lib/core/network/
  connectivity.dart           port + durum (çevrimiçi/çevrimdışı/bilinmiyor)
lib/app/
  router/                     router.dart (faz kapısı) + routes.dart (tipli rotalar) + shell.dart
  dev/catalog_page.dart       yalnız dev flavor: kit kataloğu
lib/features/<f>/presentation/
  pages/  widgets/  controllers/   (controllers = Riverpod notifier'lar; yalnız application'ı çağırır)
```

> `presentation/controllers` application katmanını çağırır; B4 kuralı (presentation →
> application, domain) buna zaten izin verir. Controller içinde iş kuralı yazılmaz — iş
> kuralı `application/*_service.dart`'tadır (IdentityService emsali).

## 3. Aşamalar (bağımlılık bağlayıcı; dalga planı `docs/yurutme/mob-ui-0/`; her PR CI yeşil)

### A0 — Karar kaydı + UI sınır kuralları (önce kural, sonra kod)

- `docs/architecture/adr-0003-ui-temeli.md`: bu belgedeki seçimler (kit öneki `Nz`, kırılma
  noktaları, durum kalıbı, base view yerine bileşim, paket eklemeleri).
- Yeni kurallar (`tool/boundaries.dart` + negatif matris):
  - **U2** `Color(...)`, `Color.fromARGB/RGBO`, `Colors.*` yalnız `lib/core/ui/theme/**` ve
    üretilmiş token dosyasında (+ `core/security/privacy_mask.dart`, kesin dosya). **Geçiş
    istisnası:** `lib/app/app.dart` yalnız A1 birleşene kadar U2'den (ve U3'ün `google_fonts`
    maddesinden) muaftır; A1 PR'ı muafiyeti siler. Tam tanım ve ölçüm: ADR-0003 Ek A.
  - **U3** `TextStyle(...)` yapıcısı yalnız `lib/core/ui/theme/**` (ekran `copyWith` ile
    yalnız rengi/ağırlığı değiştirebilir); `google_fonts` importu yalnız tema + bootstrap.
  - **U4** `MediaQuery.of(context)` yasak → `MediaQuery.sizeOf/paddingOf/…` ya da
    `context.layout` (gereksiz yeniden çizimi önler).
  - **U5** `Theme.of(context).extension<…>()` yalnız `context_ext.dart` içinde (tek erişim
    yolu).
  - **U6** `features/**/presentation/**` içinde `Scaffold(` yasak → `NzPage` (çevrimdışı
    şerit, safe area, dolgu her sayfada garanti).
  - **G3** `features/**/presentation/**` içinde `*Service` / `*Repository` yapıcı çağrısı
    yasak (tip çözümlemeli, `api_surface.dart` yanında): bağımlılık yalnız Riverpod portundan
    okunur — bugün import yönü dışında bunu engelleyen kural yok.
- Test kapıları (CI'da `make test`'ten sonra ayrı adım; bugün yalnız "testler geçer" zorunlu,
  kapsama ve test varlığı zorunlu değil):
  - **Q1 Kapsama eşiği** — `flutter test --coverage` + `tool/check_coverage.dart` (lcov
    ayrıştırma, ek paket yok). Dizin bazlı asgari satır kapsaması: `lib/core/**` %80,
    `features/*/application` ve `features/*/data` %80, `features/*/presentation` %60,
    `lib/core/ui/widgets/**` %70. Üretilmiş dosyalar (`generated/`, `*.g.dart`,
    `*.freezed.dart`) hariç. Eşik düşürülmez, yalnız ADR ile değişir.
  - **Q2 Test varlığı** — her `features/*/application/*_service.dart`,
    `features/*/data/*_repository.dart`, `features/*/presentation/controllers/*.dart` ve
    `core/ui/widgets/**/nz_*.dart` için aynı göreli yolda `test/**/<ad>_test.dart` bulunur
    (`tool/check_test_presence.dart`; negatif testli). Bugünkü açık (O1 ölçümü, 2 eksik):
    `IdentityService`'in doğrudan testi yok; `IdentityRepository` testi aynı göreli yolda
    değil — kapı açılmadan önce kapatılır (ADR-0003 Ek B).
  - **Q3 Kayıt denetimi** — `test/app/composition_test.dart`'a: bileşim kökü kurulduktan
    sonra bütün Riverpod portları (core + her feature'ın `*Overrides` listesi) okunur, hiçbiri
    `UnimplementedError` atmaz. Yeni feature modülü bileşime eklenmeden ya da portu
    geçersiz kılınmadan CI kırılır ("kayıt unutuldu" açığı çalışma anından teste çekilir).
- **UI metin kaynağı:** `i18n/ui/<grup>.tr.json` (elle yazılır, grup başına ayrı dosya →
  paralel uygulayıcılar çakışmaz) → `make gen` → `app_tr.arb`. Anahtar öneki `ui.<grup>.`;
  sunucu/istemci anahtarıyla çakışma `make gen`'de hatadır. ARB elle düzenlenmez.
- **Golden referans yolu:** referans görüntüler yalnız Linux'ta üretilir ve doğrulanır
  (O1/W02'nin kurduğu araç: CI işi ya da `make` hedefi); yerel macOS çıktısı commit'lenmez.
- Lint eklemeleri: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`,
  `sort_child_properties_last`, `use_key_in_widget_constructors`, `avoid_unnecessary_containers`,
  `use_colored_box`, `use_decorated_box`, `sized_box_for_whitespace` (Gap ile çakışmaz — U1
  zaten daha sıkı), `require_trailing_commas` gerekmez (format tall stili).

### A1 — Tema

- `AppTheme.light()/dark()`: `ThemeData`'yı `app.dart`'tan alır. `ColorScheme` **tohumdan
  değil rollerden** kurulur (`primary`, `onPrimary`, `surface` = `background`, `error` =
  `danger`, `outline` = `border`); tohum üretimi tasarım rengini bozar.
- `NzTextStyles` (ThemeExtension, `lerp` + `copyWith`): `displayLg, titleLg, titleMd,
  titleSm, bodyLg, bodyMd, bodySm, labelLg, labelMd, caption, mono`. Değerler
  `NizamioTypography`'den; renk varsayılanı `colors.text`. Material `TextTheme` de aynı
  rollerden doldurulur (Material widget'ları tutarlı kalsın).
- Bileşen temaları tek yerde: `filledButtonTheme`, `outlinedButtonTheme`,
  `inputDecorationTheme`, `cardTheme`, `dividerTheme`, `snackBarTheme`,
  `bottomSheetTheme`, `navigationBarTheme`, `navigationRailTheme` — yarıçap/boşluk token'dan.
- Token eksikleri (gölge/elevation, süre/eğri, opaklık, ikon boyutu) **web ile birlikte**
  `tokens.json`'a eklenir; mobilde elle sabit tutulmaz. Eklenene kadar `app_theme.dart`
  içinde tek yerde, `// TOKEN-BEKLİYOR` işaretiyle.
- `context_ext.dart`:

  ```dart
  extension NzContext on BuildContext {
    NizamioColors get colors => Theme.of(this).extension<NizamioColors>()!;
    NzTextStyles get text => Theme.of(this).extension<NzTextStyles>()!;
    NzLayout get layout => NzLayout.of(this);      // A2
    AppLocalizations get l10n => AppLocalizations.of(this);
  }
  ```

- Test: token sayfası golden'ı (açık/koyu); her rolün `ColorScheme`'e eşlendiği birim testi;
  `lerp` testi (tema geçişi).

### A2 — Layout ve ekran boyutları

- Pencere sınıfı (Material 3 eşikleri, **genişlikten**, yöne değil):
  `compact < 600`, `medium 600–839`, `expanded ≥ 840`. Telefon dikey = compact, telefon
  yatay/küçük tablet = medium, tablet = expanded.
- `NzLayout` (değer nesnesi): `windowClass`, `width`, `isCompact…`, `pagePadding`
  (compact 16 · medium 24 · expanded 32 — token'dan), `contentMaxWidth` (form 480, okuma 720,
  liste 960), `columns` (4/8/12).
  `NzLayout.of(context)` yalnız `MediaQuery.sizeOf` dinler (klavye/inset değişiminde
  yeniden çizilmez).
- `AdaptiveValue<T>(compact:, medium:, expanded:)` — eksik sınıf bir küçüğüne düşer:
  `context.layout.pick(compact: 1, expanded: 3)`.
- `AdaptiveBuilder` (farklı ağaç gerektiğinde): `compact: (_) => List(), expanded: (_) =>
  ListDetail()`; ara değerde sabit sınıf, `LayoutBuilder` tabanlı (üst kısıta göre — bölünmüş
  ekran/iPad çoklu pencere doğru çalışır).
- Gezinme kalıbı: compact → `NavigationBar` (alt), medium → `NavigationRail`, expanded →
  genişletilmiş ray + liste-ayrıntı. Kabuk A5'te bunu kullanır.
- Metin ölçeği: `MediaQuery.textScalerOf` saygı görür; kabukta üst sınır (`clamp(max: 2.0)`)
  tek yerde. Kit bileşenleri 2.0 ölçekte taşmaz (golden ile sınanır).
- Yön kilidi yok (tablet desteği); güvenli alan `NzPage`'de.
- Test: 360×800, 412×915, 700×1000, 1024×1366 matrisi; her kit bileşeni bu matrisle.

### A3 — Durum kalıbı + sayfa kabuğu ("base view")

> **Kapsam düzeltmesi (O1):** A4'ün `feedback` grubu (`NzLoader`, `NzSkeleton`,
> `NzEmptyState`, `NzErrorState`, `NzBanner`, `NzToast`) ve katalog altyapısı
> (`lib/app/dev/catalog_page.dart` iskeleti) A3'e alınır: `NzPage` ve `NzAsyncView` bunlara
> bağlıdır (A3 ↔ A4 döngüsü). A4 kalan grupları kapsar.

Ölçeğe göre üç katman:

| Durum türü | Araç | Örnek |
|---|---|---|
| Geçici, tek widget | `StatefulWidget` | metin denetleyicisi, sekme indeksi, şifre görünürlüğü |
| Ekran / akış | `@riverpod class XController extends _$XController` (AsyncNotifier, otomatik dispose) | liste yükleme, form gönderme |
| Uygulama geneli | Mevcut core controller + port (get_it) | oturum, kapsam, tema |

Kurallar:
- Controller durumu **domain varlığı** taşır (DTO değil — A1). Durum nesnesi birden çok alan
  içeriyorsa `freezed` (yalnız `freezed_annotation`, json yok → D1 ile uyumlu).
- Hata tipi daima `ApiError` (`toApiError`); controller başka istisna sızdırmaz.
- Yükleme `AsyncValue` ile; komutlar (gönder/sil) controller metodudur ve
  `state = await AsyncValue.guard(...)` ya da ayrı "gönderim" durumu döndürür. Riverpod 3
  `Mutation` API'si deneysel olduğu sürece kullanılmaz.
- Yan etkiler (snackbar, yönlendirme, diyalog) `build` içinde değil `ref.listen` ile.

Ortak yapı taşları:

```dart
// Sayfa kabuğu: her ekran bununla başlar (U6).
NzPage(
  title: context.l10n.programsTitle,
  width: NzContentWidth.list,          // azami genişlik + ortalama
  body: NzAsyncView(
    value: ref.watch(programListControllerProvider),
    onRetry: () => ref.invalidate(programListControllerProvider),
    isEmpty: (list) => list.isEmpty,
    empty: const NzEmptyState.programs(),
    data: (list) => ProgramList(items: list),
  ),
);

// Yan etki: tek satır, her ekranda aynı davranış (errorText + snackbar).
ref.listenErrors(loginControllerProvider, context);
```

- `NzPage`: `Scaffold` + `SafeArea` + `context.layout.pagePadding` + `NzContentWidth` +
  çevrimdışı şerit (A3b) + isteğe bağlı `loading` örtüsü + `PrivacyMask` ile uyumlu.
- `NzAsyncView<T>`: yükleniyor (iskelet ya da gösterge), hata (`errorText` + yeniden dene;
  `ApiError.retryAfter` varsa geri sayım), boş, veri. İlk yüklemeden sonra yenilemede eski
  veri gösterilir (`skipLoadingOnRefresh`).
- `ref_ext.dart`: `listenErrors`, `listenSuccess(onData)`; oturum bitti
  (`client.session_ended` vb.) hatası ekrana gösterilmez — faz makinesi zaten yönlendirir.

**A3b — Bağlantı durumu.** Uygulama tek sunucuyla konuşur; "internet var" ölçütü sunucuya
ulaşmaktır. `ConnectivityMonitor` (core/network, port) iki girdiden türetir: (1)
`connectivity_plus` arayüz olayı (yalnız ipucu — ADR-0003'te paket kararı), (2) son istek
sonucu (`ApiError` ağ kodu → çevrimdışı, başarılı yanıt → çevrimiçi). Çevrimiçine dönüşte
otomatik yeniden deneme **yapılmaz** (CLAUDE.md: belirsiz yenilemeyi tekrar deneme yasağı);
şerit "yeniden dene" sunar. Riverpod'a `connectivityStateProvider` olarak açılır.

### A4 — Widget kiti v0

İlkeler:
- Önek `Nz`; her bileşen tek dosya, `const` yapıcı, iş mantığı yok, yalnız geri çağrı.
- Varyant = isimli yapıcı + enum: `NzButton.primary / secondary / ghost / danger`,
  `size: NzSize.sm|md|lg`, `loading:`, `icon:`, `expand:`. Görünüm farkı içeride tek
  `_resolveStyle` fonksiyonunda; dışarıdan `style:` kaçış kapısı **verilmez** (tutarlılık).
- Özelleştirme sırası: varyant → boyut → yuva (`leading`, `trailing`, `child`) — rastgele
  renk/padding parametresi yok.
- Erişilebilirlik: asgari dokunma alanı 48, `Semantics` etiketi, odak sırası, 2.0 metin ölçeği.

v0 envanteri (tasarımsız, token'la nötr görünüm):

| Grup | Bileşenler |
|---|---|
| buttons | `NzButton`, `NzIconButton` |
| inputs | `NzTextField` (`ApiFieldError` → alan hatası eşleme dahil), `NzPasswordField`, `NzSearchField`, `NzCheckbox`, `NzSwitch`, `NzSelect` |
| feedback (A3'te) | `NzLoader`, `NzSkeleton`, `NzEmptyState`, `NzErrorState`, `NzBanner` (çevrimdışı/uyarı), `NzToast` (snackbar servisi) |
| surfaces | `NzCard`, `NzSection`, `NzDivider`, `NzBadge`, `NzAvatar` |
| lists | `NzListTile`, `NzPagedList` (sayfalama + aşağı çek yenile) |
| overlays | `NzDialog.confirm`, `NzBottomSheet` |

- Form: `NzForm` + alan doğrulayıcıları; sunucu `fields[]` hataları `ApiError.fields`'tan
  alana `field` adıyla eşlenir (tek yardımcı, her formda aynı).
- Katalog: `lib/app/dev/catalog_page.dart` — yalnız dev flavor, tüm varyant × açık/koyu ×
  pencere sınıfı. Ayrı paket (widgetbook) **eklenmez**; gerekirse ADR ile sonra.
- Test: her bileşen için golden (açık/koyu × compact/expanded × metin 1.0/2.0) + davranış
  testi (loading'de dokunma kapalı vb.).

### A5 — Router

- Faz kapısı aynen kalır (`routeForPhase` + `redirect`); güvenlik akışı router'a bağlı.
- Tipli rotalar: `go_router_builder` (dev bağımlılığı, ADR-0003) →
  `const ProgramDetailRoute(id: x).go(context)`; dize yol ve `extra` ile nesne taşıma yasak
  (derin bağlantı ve yeniden başlatmada kaybolur — yalnız kimlik taşınır, veri controller'dan
  yüklenir).
- `scoped` fazında `StatefulShellRoute.indexedStack` + `NzAdaptiveShell` (A2 gezinme kalıbı);
  her sekmenin yığını korunur.
- Feature rota kaydı: her feature açık yüzünden `List<RouteBase> get <f>Routes` verir;
  `app/router/routes.dart` birleştirir (B2/B3 ile uyumlu: app → feature facade).
- Geçiş animasyonları ve 404/bilinmeyen rota sayfası tek yerde.

### A6 — Tercihler

- `AppPreferences` içinde tipli anahtar tanımı (dışarı açılmaz, S7 korunur):
  `_Pref<T>(key, default, encode, decode)`; her tercih yine adlandırılmış get/set metodudur.
- Her tercih: anahtar + get/set + `XController(ValueNotifier)` + Riverpod `_listen`
  sağlayıcısı (ThemeModeController emsali). Açılışta okunması gerekenler bootstrap'te
  `runApp` öncesi yüklenir (titreşim yok).
- Aday tercihler: dil (şimdilik yalnız tr, altyapı hazır), son seçili kapsam (gizli değil
  mi — kapsam kimliği; oturuma bağlıysa SecureStore), liste yoğunluğu, ilk açılış rehberi.
- Gizli/kişisel veri tercihe yazılmaz (S1/S5).

### A7 — Pilot dikey dilim (altyapının kanıtı)

Tasarımsız, kit'le kurulmuş, işlevsel ekranlar: **sunucu bağlama → giriş → zorunlu parola
değişikliği → kapsam seçimi → boş ana kabuk**. Amaç görsel değil: zincirin uçtan uca
(controller → service → repository → generated client, hata → ARB metni, faz → router,
compact/expanded) çalıştığını göstermek. Widget testleri + mevcut entegrasyon hattında bir
akış testi. Bu dilim sonraki her feature'ın şablonudur.

### A8 — Tasarım gelince

1. Tasarım token'ları web ile birlikte `tokens.json`'a → `make gen`.
2. Kit içi stil (`_resolveStyle`) ve `app_theme.dart` güncellenir; goldenlar yeniden üretilir,
   fark incelenir.
3. Yeni bileşen gerekiyorsa önce kit'e + kataloğa, sonra ekrana.
4. Ekran kodu değişmez (A0 kuralları bunu garanti eder).

## 4. Veri ve DTO kalıbı (yazılı standart)

- DTO'lar elle yazılmaz; `make gen` backend **etiketinden** üretir (mevcut).
- Her feature `data/<f>_repository.dart`: üretilmiş istemciyi kurar, her çağrıyı
  `apiCall(...)` ile sarar (hata → `ApiError`), DTO'yu **özel** `_toX` statik eşleyiciyle
  domain varlığına çevirir (IdentityRepository emsali). Açık API'de DTO yok (A2).
- Domain varlıkları `domain/` altında saf Dart, değişmez; çok alanlıysa `freezed` (json yok).
  Enum'lar için domain enum'u; bilinmeyen sunucu değeri `unknown` üyesine düşer (yeni backend
  etiketi uygulamayı kırmasın).
- Ortak liste/sayfalama: `core/domain/page_slice.dart` (`items`, `nextCursor`, `truncated`) —
  backend sayfalama biçimi `openapi.yaml`'dan doğrulanarak (`v0.1.0-api`: yalnız imleç —
  `limit`/`cursor` → `next_cursor`; `total` yok; imleçsiz listelerde `X-Result-Truncated`).
  Rehber: `docs/architecture/veri-kalibi.md`.
- İstek gövdesi elle `Map` ile kurulmaz (D2); her zaman üretilmiş request DTO.
- Yerel önbellek (drift) ilk ekranlarda **yok**; ihtiyaç doğan feature'da ADR ile.

## 5. Kod standartları (özet kontrol listesi — PR şablonuna eklenecek)

- [ ] Ekranda ham renk/TextStyle/sayısal boşluk yok (U2/U3, `Gap` + `NzGap`).
- [ ] Ekran `NzPage` ile başlar; async veri `NzAsyncView`; hatalar `ref.listenErrors`.
- [ ] Widget `build` metodu ~80 satırı aşıyorsa alt widget'a (yardımcı metot değil, sınıf)
      bölünür; `const` yapıcı.
- [ ] Controller'da iş kuralı yok; servis/repository'de. Controller DTO görmez.
- [ ] Kullanıcı metni yalnız ARB'den (`context.l10n`); hata metni yalnız `errorText`.
- [ ] Yeni kit bileşeni: katalog girişi + golden + davranış testi.
- [ ] Yeni tercih: `AppPreferences` adlandırılmış metot + controller + sağlayıcı.
- [ ] Yeni rota: tipli rota sınıfı; nesne değil kimlik taşır.
- [ ] Uyarlanabilirlik: compact ve expanded'da test edildi; metin ölçeği 2.0'da taşma yok.
- [ ] Yeni service/repository/controller/kit bileşeni için test dosyası var (Q2); kapsama
      eşiği korunuyor (Q1).
- [ ] Yeni feature modülü bileşim köküne eklendi, portları geçersiz kılındı (Q3 yeşil).

## 6. Açık kararlar (ADR-0003'te varsayılanla kapandı — 2026-10-14)

| Konu | Varsayılan |
|---|---|
| `connectivity_plus` eklenmesi | Eklenir (yalnız ipucu; asıl ölçüt sunucu yanıtı) |
| `go_router_builder` eklenmesi | Eklenir (dev bağımlılığı) |
| Widget kataloğu aracı | Uygulama içi dev rotası; widgetbook yok |
| Golden test altyapısı | Flutter yerleşik `matchesGoldenFile`; CI'da tek platform (Linux) referansı |
| `riverpod_lint` | Analyzer eklenti desteği netleşince ayrı PR ile değerlendirilir |
| Kapsama eşikleri (Q1) | core/application/data %80 · widgets %70 · presentation %60; yalnız ADR ile değişir |
| Kapsama aracı | Kendi lcov ayrıştırıcımız (`tool/`); harici servis (Codecov vb.) yok |
| Gölge/süre/ikon token'ları | Web ile birlikte `tokens.json`'a; o zamana kadar `// TOKEN-BEKLİYOR` |
