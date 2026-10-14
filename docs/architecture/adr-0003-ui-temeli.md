# ADR-0003 — UI temeli: kit, pencere sınıfı, durum kalıbı, UI kuralları ve kapılar

- **Durum:** Kabul edildi (2026-10-14)
- **Karar dayanağı:** [yol haritası — UI temeli](yol-haritasi-ui-temeli.md) §6 "Açık kararlar";
  ürün sahibine oturum içinde soru sorulmaz — her açık karar yol haritası varsayılanıyla
  kapanır (MOB-UI-0 O1). Yürütme planı: [`docs/yurutme/mob-ui-0/`](../yurutme/mob-ui-0/README.md).
- **İlgili:** ADR-0001 (get_it bileşim kökü), ADR-0002 (paket seti, U1/S5/S6), sınır kuralları
  `tool/boundaries.dart`

## Bağlam

MOB-0 ekransız altyapıdır; tasarım henüz yok. MOB-UI-0 tasarımdan bağımsız anlamsal UI
katmanını (tema, layout, durum kalıbı, sayfa kabuğu, kit, router, tercihler) kurar. Tasarım
geldiğinde yalnız token'lar ve kit içi değişmeli, ekranlar değişmemelidir; bunu belge değil
sınır kuralı ve test kapısı garanti eder. Bu ADR yol haritasındaki seçimleri ve O1'de ölçülen
başlangıç değerlerini kaydeder.

## Karar

| # | Konu | Karar |
|---|---|---|
| 1 | Kit öneki | `Nz` (`NzButton`, `NzPage`, …); her bileşen tek dosya `nz_<ad>.dart`, `lib/core/ui/widgets/<grup>/`. |
| 2 | Pencere sınıfı | Material 3 eşikleri, **genişlikten** (yönden değil): `compact < 600`, `medium 600–839`, `expanded ≥ 840`. Sayfa dolgusu 16/24/32, sütun 4/8/12, içerik azami genişliği form 480 · okuma 720 · liste 960. `NzLayout.of` yalnız `MediaQuery.sizeOf` dinler. |
| 3 | Durum kalıbı | Üç katman: geçici → `StatefulWidget`; ekran/akış → `@riverpod` AsyncNotifier controller (otomatik dispose); uygulama geneli → mevcut core controller + port. Controller domain varlığı taşır (DTO değil), hata tipi daima `ApiError`. Riverpod 3 `Mutation` API'si deneysel kaldıkça kullanılmaz. Yan etki `ref.listen` ile. |
| 4 | "Base view" | Soyut sınıf hiyerarşisi **yok**; bileşim: `NzPage` (kabuk) + `NzAsyncView` (durum görünümü) + `WidgetRef` uzantıları (`listenErrors`, `listenSuccess`). |
| 5 | `connectivity_plus` | Eklenir (bağımlılık). Yalnız ipucu; asıl ölçüt sunucu yanıtıdır (A3b). Çevrimiçine dönüşte otomatik yeniden deneme yok. |
| 6 | `go_router_builder` | Eklenir (dev bağımlılığı); tipli rotalar, nesne değil kimlik taşınır (A5). |
| 7 | Widget kataloğu | Uygulama içi dev rotası `lib/app/dev/catalog_page.dart` (yalnız dev flavor); widgetbook eklenmez. |
| 8 | Golden altyapısı | Flutter yerleşik `matchesGoldenFile`; referans **yalnız Linux'ta** üretilir ve doğrulanır (CI tek platform). Golden testleri etiketle ayrılır; macOS'ta `make test` golden koşmaz. Üretim yolu O1/W02'nin kurduğu araçtır (`Makefile` / CI; yol README'de). Yerel macOS çıktısı commit'lenmez. |
| 9 | `riverpod_lint` | Eklenmez; analyzer eklenti desteği netleşince ayrı PR ile değerlendirilir. |
| 10 | Kapsama eşikleri (Q1) | Satır kapsaması: `lib/core/**` %80 · `lib/features/*/application/**` %80 · `lib/features/*/data/**` %80 · `lib/features/*/presentation/**` %60 · `lib/core/ui/widgets/**` %70 (bu dizin `lib/core/**` eşiğinden ayrı ölçülür). Üretilmiş dosyalar (`generated/`, `*.g.dart`, `*.freezed.dart`) hariç. Eşik **yalnız ADR ile** değişir; geçiş notu yok (Ek B: bugün hepsi eşik üstünde). |
| 11 | Kapsama aracı | Kendi lcov ayrıştırıcımız (`tool/check_coverage.dart`), ek paket ve harici servis (Codecov vb.) yok. lcov'da hiç görünmeyen (hiçbir testin yüklemediği), eşikli dizindeki üretilmemiş dosya **kapsamasız sayılır ve kapıyı kırar** (fail-closed); yalnız yönerge (import/export/part/library) içeren dosya hariç. |
| 12 | Test varlığı (Q2) | `features/*/application/*_service.dart`, `features/*/data/*_repository.dart`, `features/*/presentation/controllers/*.dart`, `core/ui/widgets/**/nz_*.dart` için **aynı göreli yolda** `test/…/<ad>_test.dart` (ör. `lib/features/identity/data/identity_repository.dart` → `test/features/identity/data/identity_repository_test.dart`). |
| 13 | Kayıt denetimi (Q3) | `test/app/composition_test.dart`: bileşim kökü kurulduktan sonra core + her feature `*Overrides` listesindeki bütün portlar okunur, hiçbiri `UnimplementedError` atmaz; port listesi koddan toplanır. |
| 14 | Gölge/süre/opaklık/ikon token'ları | Web ile birlikte `tokens.json`'a; o zamana kadar `app_theme.dart` içinde tek yerde `// TOKEN-BEKLİYOR`. |
| 15 | UI metin kaynağı | `i18n/ui/<grup>.tr.json` (elle yazılır, **grup başına ayrı dosya** → paralel uygulayıcılar çakışmaz) → `make gen` → `lib/core/i18n/arb/app_tr.arb`. Anahtar öneki `ui.<grup>.`; `ui.*` anahtarının sunucu/istemci hata anahtarlarıyla çakışması `make gen`'de hatadır. ARB elle düzenlenmez. |
| 16 | Lint eklemeleri (A0) | `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `sort_child_properties_last`, `use_key_in_widget_constructors`, `avoid_unnecessary_containers`, `use_colored_box`, `use_decorated_box`, `sized_box_for_whitespace`. `require_trailing_commas` eklenmez (biçimleyici tall stili). Ölçüm: bugünkü kodda **1 bulgu** (`test/core/session/session_controller_test.dart:126`, `prefer_const_constructors`). |
| 17 | UI sınır kuralları | U2, U3, U4, U5, U6, G3 — tanımlar Ek A'da; uygulama `tool/boundaries.dart` (G3 tip çözümlemeli, `tool/api_surface.dart` yanında). |
| 18 | Geçiş istisnası | `lib/app/app.dart` yalnız A1 (tema) birleşene kadar U2'den ve U3'ün `google_fonts` maddesinden muaftır; A1 PR'ı (O2/W11) `ThemeData`'yı `lib/core/ui/theme/app_theme.dart`'a taşır ve muafiyeti **siler**. Başka geçiş istisnası yoktur. **Uygulandı (O2/W11, 2026-10-14): istisna `tool/boundaries.dart`'tan silindi; `app.dart` U2/U3'e tam tabidir.** |
| 19 | Dalga planı sapması | Yol haritası §3'teki "sıra bağlayıcı; her aşama ayrı PR" yerine **bağımlılık bağlayıcı**; aşamalar paralel uygulayıcılarla, oturum başına birden çok PR'la yürür (`docs/yurutme/mob-ui-0/`). A4 `feedback` grubu (`NzLoader`, `NzSkeleton`, `NzEmptyState`, `NzErrorState`, `NzBanner`, `NzToast`) ve katalog altyapısı A3'e alınır (`NzPage`/`NzAsyncView` bunlara bağlı; A3 ↔ A4 döngüsü kırılır). |

## Ek A — UI sınır kuralları (W01 uygulama tablosu)

Ortak: kurallar yalnız `lib/` altında (`tool/check_boundaries.dart` kapsamı) uygulanır;
`lib/core/api/generated/**` ve `lib/core/i18n/generated/**` dosyaları kuralların dışındadır
(üretilmiş kod). Yasak kalıplar `const`/`new`'li ve `new`'siz çağrıyı, takma adlı import
(`import '…/material.dart' as m; m.X`), yapıcı tear-off'u (`X.new`) ve `typedef Y = X` takma
adını kapsar (U1 emsali). Yalnız tip açıklaması (`final Color color;`) kural dışıdır.

| Kimlik | Yasak kalıp | İzinli yollar | Pozitif örnek (geçer) | Negatif örnekler (yakalanır) | Bugünkü ölçüm |
|---|---|---|---|---|---|
| **U2** ham renk | `Color(…)`, `Color.from(…)`, `Color.fromARGB(…)`, `Color.fromRGBO(…)`, `Color.new`; `Colors.<x>`, `CupertinoColors.<x>` erişimi | `lib/core/ui/theme/**`; `lib/core/theme/generated/**` (üretilmiş token); `lib/core/security/privacy_mask.dart` (kesin dosya — güvenlik maskesi temadan bağımsız opak olmalı: tema yüklenmeden ve tema geçişinde de içerik gizlenir). (`lib/app/app.dart` geçişi O2/W11'de silindi, karar 18) | `features/x/presentation/a.dart`: `color: context.colors.textMuted`; `core/ui/theme/app_theme.dart`: `const Color(0xFF000000)` | (1) `features/x/presentation/a.dart`: `const Color(0xFF112233)`; (2) `core/session/b.dart`: `Colors.red`; (3) atlatma: `import 'package:flutter/material.dart' as m;` → `m.Colors.red` ve `m.Color.fromARGB(255,0,0,0)`; (4) atlatma: `typedef C = Color;` → `C(0x1)`; `final f = Color.new;` | Ham 64 isabet: `lib/core/theme/generated/tokens.gen.dart` 63 (izinli), `lib/core/security/privacy_mask.dart:28` 1 (izinli kesin dosya), `lib/app/app.dart` 0. **İzinler sonrası 0.** |
| **U3** ham metin stili | `TextStyle(…)` yapıcısı (`TextStyle.new` dahil); `package:google_fonts` importu (`GoogleFonts.*()` `TextStyle` döndürür — kaçış yolu) | `TextStyle(…)`: yalnız `lib/core/ui/theme/**`. `google_fonts` importu: `lib/core/ui/theme/**`, `lib/app/bootstrap.dart` (çalışma anı indirmeyi kapatır, ADR-0002). (`lib/app/app.dart` geçişi O2/W11'de silindi.) `x.copyWith(color:/fontWeight:)` her yerde serbest | `features/x/presentation/a.dart`: `context.text.titleMd.copyWith(color: context.colors.danger)`; `core/ui/theme/nz_text_styles.dart`: `const TextStyle(fontSize: 14)` | (1) `features/x/presentation/a.dart`: `const TextStyle(fontSize: 12)`; (2) `core/ui/widgets/buttons/nz_button.dart`: `TextStyle(fontWeight: FontWeight.w600)`; (3) atlatma: `m.TextStyle(…)` (takma adlı import) ve `final s = TextStyle.new;`; (4) `features/x/presentation/a.dart`: `import 'package:google_fonts/google_fonts.dart';` | `TextStyle(` 0; `google_fonts` importu 2 (`app.dart`, `bootstrap.dart`, ikisi de izinli). **İzinler sonrası 0.** O2/W11 sonrası: 2 (`core/ui/theme/`, `bootstrap.dart`). |
| **U4** tüm-MediaQuery bağımlılığı | `MediaQuery.of(…)` ve `MediaQuery.maybeOf(…)` (ikisi de bütün `MediaQueryData`'ya bağlanır, klavye/inset değişiminde yeniden çizer) ve tear-off'ları | Yok. Serbest: `MediaQuery.sizeOf/paddingOf/viewInsetsOf/textScalerOf/…` ve `maybe…Of` boyut yöntemleri, `MediaQuery.withClampedTextScaling`, `context.layout` | `final w = MediaQuery.sizeOf(context).width;` | (1) `MediaQuery.of(context).size`; (2) `MediaQuery.maybeOf(context)?.padding`; (3) atlatma: `m.MediaQuery.of(context)` ve `final f = MediaQuery.of;` | 0 |
| **U5** tema uzantısı erişimi | `.extension<…>()` çağrısı (hangi hedefte olursa) ve `ThemeData.extensions` erişimi (`.extensions[…]`, `.extensions.values`) | Yalnız `lib/core/ui/extensions/context_ext.dart`. `ThemeData(extensions: […])` adlandırılmış argümanı kural dışıdır (erişim değil kurulum) | `core/ui/extensions/context_ext.dart`: `Theme.of(this).extension<NizamioColors>()!` | (1) `features/x/presentation/a.dart`: `Theme.of(context).extension<NizamioColors>()!`; (2) atlatma: `final t = Theme.of(context); t.extension<NzTextStyles>()`; (3) atlatma: `Theme.of(context).extensions[NizamioColors]` | 0 (`app.dart`'taki `extensions: [c]` adlandırılmış argümandır). O2/W11 sonrası ham 2, ikisi de izinli `context_ext.dart`; izinler sonrası 0. |
| **U6** sayfa kabuğu | `Scaffold(…)`, `CupertinoPageScaffold(…)` (tear-off/takma ad dahil) — yalnız `lib/features/**/presentation/**` içinde yasak | `lib/core/ui/**` (`NzPage` kurar), `lib/app/**` | `features/x/presentation/pages/p.dart`: `NzPage(title: …, body: …)` | (1) `features/x/presentation/pages/p.dart`: `Scaffold(body: …)`; (2) `features/x/presentation/widgets/w.dart`: `const CupertinoPageScaffold(child: …)`; (3) atlatma: `m.Scaffold(…)` ve `typedef S = Scaffold;` → `S()` | 0 (bugün `presentation/` dizini yok) |
| **G3** sunumda servis kurma | `lib/features/**/presentation/**` içinde, **çözümlenmiş** sınıf adı `Service` ya da `Repository` ile biten bir yapıcı çağrısı ya da yapıcı tear-off'u. Tip çözümlemelidir (analyzer element'i): takma ad, `typedef`, adlı/fabrika yapıcı ve önekli import çözülür; çağrı yerindeki ad değil hedef sınıfın adı karşılaştırılır | `presentation` dışı her yer (`<f>_module.dart`, `lib/app/**`, application/data) — bağımlılık sunumda yalnız Riverpod portundan okunur (`ref.watch(identityServiceProvider)`) | `features/x/presentation/controllers/c.dart`: `final s = ref.watch(identityServiceProvider);` | (1) `features/x/presentation/pages/p.dart`: `IdentityService(repository: …)`; (2) atlatma: `typedef Svc = IdentityService;` → `Svc(…)`; (3) atlatma: `import '…/identity_repository.dart' as r;` → `r.IdentityRepository(dio)` ve `final f = IdentityRepository.new;` | 0 (bugün `presentation/` dizini yok) |

Mevcut kuralların (B*, D*, S*, A*, G1, G2, U1) davranışı değişmez. Ölçüm yöntemi (O1,
`2524a14`): `lib/` altında üretilmemiş dosyalarda desen araması + üretilmiş dosyaların ayrı
sayımı; W01'in aracı aynı sayıları vermelidir (izinler kaldırıldığında U2 = 64).

## Ek B — Kapsama ve test varlığı ölçümü (O1, `2524a14`)

`flutter test test/ --coverage` (245 test, hepsi geçer); üretilmiş dosyalar hariç satır
kapsaması:

| Dizin | Kapsanan / toplam satır | % | Eşik | Durum |
|---|---|---|---|---|
| `lib/core/**` (widgets hariç) | 599 / 649 | 92,30 | 80 | geçer |
| `lib/features/*/application/**` | 37 / 39 | 94,87 | 80 | geçer |
| `lib/features/*/data/**` | 17 / 17 | 100 | 80 | geçer |
| `lib/features/*/presentation/**` | — (dizin yok) | — | 60 | dosya yokken geçer |
| `lib/core/ui/widgets/**` | — (dizin yok) | — | 70 | dosya yokken geçer |
| `lib/app/**` (eşiksiz, bilgi) | 90 / 135 | 66,67 | — | — |

lcov'da görünmeyen üretilmemiş dosyalar: `lib/core/errors/error_text.dart` (eşikli dizinde;
karar 11 gereği kapıyı kırar), `lib/features/identity/identity.dart` (açık yüz, yalnız yönerge),
`lib/main_dev.dart`, `lib/main_prod.dart` (eşiksiz). **Karar:** eşik düşürülmez ve geçiş notu
gerekmez; `error_text.dart` için test **O1/W03** görevidir
(`test/core/errors/error_text_test.dart`).

Q2 bugünkü kodda **2 eksik** verir (yol haritasında yalnız `IdentityService` yazıyordu):

1. `lib/features/identity/application/identity_service.dart` → doğrudan testi yok.
2. `lib/features/identity/data/identity_repository.dart` → testi
   `test/features/identity/identity_repository_test.dart`'ta, aynı göreli yolda değil.

İkisi de **O1/W03** görevidir (servis testi yazılır; depo testi
`test/features/identity/data/` altına taşınır). W03 birleştikten sonra Q2 = 0.

## Sonuçlar

- Ekran kodu ham renk/metin stili/`MediaQuery.of`/tema uzantısı/`Scaffold`/servis kurulumu
  kullanamaz; tasarım değişikliği token + kit içinde kalır (A8).
- Kapsama, test varlığı ve kayıt denetimi CI'da zorunludur; yeni service/repository/
  controller/kit bileşeni testsiz giremez, yeni feature modülü bileşime eklenmeden CI kırılır.
- Golden referanslar yalnız Linux'tan gelir; görsel fark incelenmeden referans değişmez.
- Bedel: kurallar sözdizimsel + tip çözümlemeli iki araçta yaşar; her yeni atlatma yolu
  negatif matrise eklenir.

## Reddedilen seçenekler

- **Base view sınıf hiyerarşisi** (`abstract class BaseView<VM>`): Riverpod'un tipli
  sağlayıcılarıyla çatışır, testi zorlaştırır.
- **Widgetbook / harici katalog paketi:** yeni bağımlılık ve ikinci derleme hedefi; uygulama
  içi dev rotası yeterli.
- **Codecov vb. harici kapsama servisi:** dış servise kod/ölçüm gönderimi; lcov ayrıştırma
  küçük ve yereldir.
- **Çok platformlu golden referansı:** yazı tipi/raster farkı yüzünden kararsız; tek platform
  (Linux, CI ile aynı) seçildi.
- **Eşik altı dizin için eşiği düşürmek:** reddedildi; gerektiğinde tarihli geçiş notu ya da
  test görevi (bugün gerekmedi).
