# Tasarım token'ları — kaynak, üretim, açık kararlar

Karar: [ADR-0003 karar 24](architecture/adr-0003-ui-temeli.md). Bu belge kaynak zincirini,
rol eşlemesinin gerekçesini ve tasarım kaynaklarındaki çelişkileri kaydeder (2026-10-28).

## Kaynak → doğrulama → üretim

1. **Değerler:** `docs/design/design sytem/tokens.json` (tasarım sisteminin kendi dosyası;
   `tokens.css` bundan üretilmiştir). Dizin adındaki boşluk ve "sytem" yazımı gerçek yoldur.
2. **Eşleme:** `design/mobile-tokens.json` — anlamsal rol → tasarım token adı; tasarımda
   karşılığı olmayan mobil değerler (4 pt yerleşim ızgarası, ikon 20/16, çizgi 1, odak 2).
   Renk değeri burada yazılmaz.
3. **Doğrulama:** `make gen` tasarım dosyasının `git hash-object` kimliğini `source.blob` ile
   karşılaştırır; farklıysa düşer. Tasarım güncellenince fark incelenir, blob güncellenir.
   Çözümleyici (`tool/gen/sources.dart` `resolveTokens`) bilinmeyen renk biçimini, tek temada
   tanımlı rengi, döngülü başvuruyu, eşlemede olmayan token'ı, em olmayan harf aralığını düşürür.
   CSS `#RRGGBBAA` → Flutter `0xAARRGGBB` (alfa başa taşınır); `rgba()` alfası ×255 yuvarlanır.
4. **Hareket:** süre ve eğriler tasarım sisteminin `components/bundle.css` `:root` özel
   özelliklerinden (`--m-dur-*`, `--m-ease-*`) okunur; dosya `design/mobile-tokens.json`
   `motion.source` (yol + blob) ile aynı yöntemle sabittir (değişirse `make gen` düşer). Basma
   ölçekleri (`.96` düğme, `.985` kart) eşlemede `motion.pressScale` (kaynak seçiciler yorumda).
5. **Çıktı:** `lib/core/theme/generated/tokens.gen.dart` — `NizamioColors`, `NizamioShadows`
   (ThemeExtension), `NizamioSpacing` (`spaceN` ızgara + `gutter`, `gapXs…gapXl`, `rowPad`,
   `cardPad`), `NizamioRadius`, `NizamioSize`, `NizamioBlur`, `NizamioMotion` (süre, `Cubic`,
   basma ölçeği), `NizamioTypography` (aile + 19 tasarım stili). Web `tokens/tokens.json`
   artık okunmaz.

## Rol eşlemesi

| Rol | Token | Not |
|---|---|---|
| background / surface / surfaceRaised / surfaceOverlay | bg-base / bg-surface / bg-raised / bg-overlay | Scaffold zemini / kart, sayfa, giriş dolgusu / form satırı / seçili parça |
| border / borderStrong / borderControl | border-subtle / border-strong / border-control | ayırıcı / menü kenarı / giriş ve hayalet düğme kenarı |
| text / textMuted / textFaint | ink / ink-muted / ink-faint | |
| primary / onPrimary | accent / accent-ink | **yalnız dolgu**; vurgulu yazı/ikon için `accentText` |
| accentText / focusRing | accent-text / focus-ring | |
| danger / onDanger | danger / on-danger | |
| warning / onWarning | gold / on-gold | README: "bekliyor, %80 uyarısı" |
| success | accent-text | README: "tamam accent-text" |
| info | ink-muted | **varsayım** — tasarımda bilgi rengi yok |
| scrim | scrim | |
| surfaceTop / edgeLight | surface-top / edge-light | kart degradesi üst durağı, üst iç ışık (`NzSurfaceFills`, `NzEdgeLightPainter`) |
| primaryTop / buttonTop / buttonBottom / buttonBorder | accent-top / btn-top / btn-bottom / btn-border | ana ve ikincil düğme degradeleri, ikincil kenar |
| inProgress / onInProgress | violet / on-violet | README "devam violet"; koyu temada küçük metin değil, işaret/çubuk |
| glassBar / glassFloat / glassMenu / glassEdge / glassInk / glassInkFaint | glass-* | üst çubuk, alt menü + asistan + menü dairesi, flyout (`NzGlass`) |
| navHighlight / scrimSoft | nav-highlight / scrim-soft | alt menü vurgusu, flyout örtüsü |
| roleAdmin / roleCoordinator / roleMember | role-admin / role-koord / role-uye | rol işaret noktası (görünüm rengi; yetki kuralı değil) |

Metin rolleri (`NzTextStyles`): displayLg `m-greet`, titleLg `m-h1`, titleMd `m-h1-detail`,
titleSm `m-sheet-title`, labelLg `m-card-title`, bodyLg `m-input`, bodyMd `m-body`, labelMd `m-tab`,
bodySm/caption `m-caption`, mono `m-code`, yeni: kicker `m-kicker`, monoSm `m-mono-sm`, numeral `m-kpi`.
Satır yüksekliği px → oran, `TextLeadingDistribution.even` (CSS yarı-aralık); harf aralığı em × boyut.

## Yazı tipleri

| Dosya | Kaynak | sha256 (ilk 12) |
|---|---|---|
| Poppins-SemiBold.ttf (4.004) | github.com/google/fonts `ofl/poppins` | d3bf1bdaf055 |
| GeistMono-Regular/Medium.ttf (1.802) | github.com/vercel/geist-font release v1.8.2 | 2c01278ad859 / 8879bed58337 |
| Inter-Regular/Medium/SemiBold.ttf (4.001) | mevcut (değişmedi) | — |

Ağırlıklar tasarımın 19 stilinden türetilir (test: `nz_text_styles_test`); Inter 700 ve JetBrains
Mono kaldırıldı. fontTools ile denetlendi: altı dosyada `İ ı Ş ş Ğ ğ Ç ç Ö ö Ü ü` mevcut, ad
tablosu aile/ağırlık dosya adıyla uyumlu; Geist Mono rakamları eş genişlikte (600). HTML'deki gömülü
web yazı tipleri alt kümeye bölünmüş olduğu için kullanılmadı.

## Kaynak karşılaştırması: çelişkiler

Prototip (`mobile.html`, 390×844, Chromium) hesaplanmış stilleriyle `tokens.json`/README karşılaştırıldı.

- Prototip `t-`/`rp-` sınıfları kullanır, tasarım sistemi `m-`; değerler çoğunlukla aynı token'lardan.
- KPI kartı iç boşluğu prototipte **14px**, token `m-card-pad` **16px**.
- Giriş başlığı "Giriş yap" 30/36 (`m-greet` ölçüsü) ve altında açıklama satırı var; README
  "sayfa başlığının altına açıklama yazma" der. Giriş alanı/düğmesi 52px; `m-tap` 44, `.m-btn` 44.
- Düğme metni 14/20 600 (`.m-btn`) hiçbir tasarım metin stiline karşılık gelmez → tema `bodyMd` +
  `labelLg` ağırlığı kullanır.
- Açık temada kart gölgesi (`0 1px 2px …05, 0 6px 20px …06`) prototipte var, `tokens.json`'da yok.
- `m-sh-knob` yalnız tek değer (açık tema karşılığı yok); iki modda aynı üretilir.
- Hareket eğrileri/süreleri yalnız `components/bundle.css`'te (`--m-ease-*`, `--m-dur-*`); `tokens.json`'da yok.
- `m-kpi` Poppins ile `tabular-nums` ister; Poppins'te `tnum` özelliği yok → rakamlar orantılı kalır.
  Poppins'te `→` glifi yok (yedeğe düşer).

## Ana sayfa (2026-10-28): çelişkilerin çözümü

| Konu | Çözüm |
|---|---|
| Kart dolgusu 14 / 16 | KPI ve koordinatörlük kartı `m-row-pad` (14; README "KPI kutucuğu iç yatay boşluğu"), görev/giriş kartı `m-card-pad` (16). `NzCard` `padding` alır; ekran token verir. |
| Düğme yüksekliği 52 / 44 | Görsel yükseklik prototip `--control-sm/md/lg` (36/44/52 → `NizamioSize.controlSm/Md/Lg`); dokunma alanı her boyutta ≥ 48 (`MaterialTapTargetSize.padded`, bölünmüş düğmede parça başına 48). |
| Açık tema kart gölgesi | Eşlemede `shadows.card` (prototip `--shadow-card`, iki katman); koyu temada boş (prototip hesaplanmış stili yalnız iç ışık). Üretici çok katmanlı/`none` gölgeyi okur; ad tasarım gölgesiyle çakışırsa düşer. |
| Hareket yalnız bundle.css | `motion.source` pini + üretim (yukarıda); `NzMotion.of` hareketi azaltta süreyi sıfırlar. |
| Kontrast: `ink-faint` / `bg-raised` 4.34 | Filtre rayındaki sayaç (raydaki tek `ink-faint` metin) `textMuted`'a alındı (her iki temada ≥ 4.5); test listesi değişmedi. |
| Kontrast: `gold` metin 4.25 (açık) | "Koordinatör atanmamış" prototipte gold metin; burada gold yalnız durum noktası, yazı `textMuted`. Bekleyen işler flyout'unda gold yalnız nokta. |
| Poppins `tnum` yok | KPI rakamı tek değer (hizalama gerekmez) Poppins `m-kpi`; sütun hizası gereken sayılar (yüzde · görev, geciken, sayaçlar) Geist Mono (`kicker`/`monoSm`). |
| `→` / ikonlar | Poppins'te `→` yok; ok ve bütün ikonlar mevcut ikon sistemi (Material Icons, yuvarlak/çizgi varyantları; 20/16 token). Prototipin 1.75 çizgili SVG ikonları birebir değildir (bilinen görsel fark). |
| Açık temada cam | Prototip alt menü/menü dairesini açık temada da koyu cam (`rgba(18,18,18,.74)`, sabit kodlu) çizer; tokens.json `glass-float` açık değeri (beyaz %78) uygulandı. |
| Metin büyütme | Üst çubuk ve alt menü sabit yükseklikli gezinme çubuklarıdır; içlerindeki metin en çok 1.3× büyür (tam metin okuyucu etiketinde). Sayfa içeriği 2.0×'e kadar büyür, kesilmeden sarılır (KPI açıklaması 3, koordinatörlük adı 2 satır). |
| Ekip toplamı | Prototip "18 kullanıcı" ile rol toplamı (2+15+3=20) çelişir; kullanıcı sayısı rol toplamından hesaplanır. |

Prototipin "son girilen modül" üçüncü alt menü öğesi yerine, modül ekranları gelene kadar Profil
(çıkış) sekmesi kalır; çekmecede de çıkış vardır. Diğer ekranlara özgü eksikler (sohbet balonu,
hap sekme başparmağı, zaman çizelgesi `gp-*` renkleri, klasör camı, alt sayfa form satırları,
`m-sh-knob`) bu çalışmada eşlenmedi.

## Açık kararlar (tasarım/ürün sahibi)

1. **Kontrast:** açık temada `border-control` zemin üzerinde 2.75, yüzeyde 2.98 (README "3:1 üstü"
   der); `gold` metin olarak 4.25 ve `on-gold`/`gold` 4.25 (< 4.5); `ink-faint`/`bg-raised` 4.34.
   Değerler değiştirilmedi; `test/core/ui/theme/contrast_test.dart` bunları sabitler.
2. **`info` rengi** tasarımda yok; nötr `ink-muted`'a bağlandı.
3. **Hareket token'ları** `tokens.json`'a alınmalı mı — şimdilik `bundle.css`'ten pinle üretilir.
4. **Kart görünümü:** uygulandı (ana sayfa, 2026-10-28): degrade + iç ışık + açık tema gölgesi
   `NzCard.outlined`'da; ikincil düğme kenarı `btn-border` (koyu zeminde 3:1 altı — dolgu
   degradesi ve etiket kontrolü tanıtır; tasarım kararı olarak açık).
5. **Marka:** "RoketPortal" adı/logosu tema çalışmasından ayrı; uygulama adı, kimlik ve simge değişmedi.
6. Golden referansları (`test/**/goldens/`, 27 dosya) eski temaya aittir; CI `golden` işi bu
   değişiklikle kırmızıya döner. Linux `golden-update` çıktısı görsel incelemeden sonra alınmalıdır.

## Doğrulama ve devir (2026-10-28)

- Yerel: `make verify` (sıra kilidiyle) EXIT=0 — 1.086 test, kapsama eşikleri tamam, sınır
  kuralları 0 ihlal; `make gen` iki kez koşuldu, çıktı aynı; API/hata metni üretilmiş dosyalarında
  fark yok; blob pini bozulunca üretim düşüyor. Golden'lar macOS'ta atlandı (Linux CI işi).
- Görsel: iOS simülatör (iPhone 17, 402×874 pt, 3x), dev flavor, `/dev/catalog` temel grubu
  açık/koyu, 360 genişlik, 1.0x; sunucu bağlama ekranı açık temada.
- Uzak CI çalıştırılmadı, push yapılmadı; Android derlemesi bu değişiklik için koşulmadı.

Sonraki oturum (bileşenler, sınırlı): `NzCard` degrade + iç ışık, `NzButton` ikincil degrade ve
basma ölçeği (.96), giriş etiketinin alan üstünde durması (prototip), alt menü/üst çubuk cam
yüzeyleri (`NizamioBlur`, `glass-*` rolleri `design/mobile-tokens.json`'a eklenerek). Komutlar:
`make gen`, `make lint`, `flutter test test/core/ui test/app/dev`, ağır koşum
`../program/araclar/verify-sirasi.sh "$PWD" verify`; Linux'ta `make golden-update` + görsel inceleme.
