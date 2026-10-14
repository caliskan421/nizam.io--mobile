# O4 — A4 kalan kit grupları ∥ A5 Router

En geniş paralel dalga: 6 uygulayıcı, birbirinden bağımsız dizinler.

## Açılış istemi (Opus oturumuna yapıştır)

```
MOB-UI-0 O4 oturumunu koordinatör olarak yürüt.
Oku: nizam.io--mobile/docs/yurutme/mob-ui-0/koordinator.md → oturum-4-kit-router.md → ilerleme.md
→ yol-haritasi-ui-temeli.md (A4, A5, §5) → adr-0003-ui-temeli.md → docs/architecture/ui-api-a3.md
→ main'deki lib/core/ui/widgets/feedback/** (kit emsali).
6 uygulayıcıyı tek dalga olarak paralel başlat. W36 (router) güvenlik yüzeyidir: denetimi sen derin yaparsın.
Ürün sahibine soru sorma.
```

## Hazırlık (koordinatör)

- `ilerleme.md` "Sıkılaştırılan kurallar" + O3'te `feedback` grubunda kabul edilen kalıplar
  (dosya düzeni, `_resolveStyle`, golden kurgusu) her kit uygulayıcısına "emsal: feedback
  grubu" olarak verilir. Kit tutarlılığı bu emsalden gelir; uygulayıcılar ayrı ayrı icat
  etmesin diye.
- Grup başına `i18n/ui/<grup>.tr.json` ve `lib/app/dev/catalog/<grup>_catalog.dart` sahipliği
  o gruba aittir; `catalog_page.dart`'a grubun tek kayıt satırını koordinatör birleştirmede
  ekler.

## Kit uygulayıcıları için ortak blok (W31–W35 istemlerinin başına eklenir)

```
Görev: yol haritası A4 envanterinde <GRUP> grubunun bileşenleri. Emsal: main'deki
lib/core/ui/widgets/feedback/** (yapı, golden, katalog girişi — aynı kalıbı izle).

Sahip olduğun: lib/core/ui/widgets/<grup>/**, lib/app/dev/catalog/<grup>_catalog.dart,
i18n/ui/<grup>.tr.json, test/core/ui/widgets/<grup>/**.

KESİN:
- Önek Nz, tek dosya tek bileşen, const yapıcı, iş mantığı yok, yalnız geri çağrı.
- Varyant = isimli yapıcı + enum; boyut NzSize; yuva leading/trailing/child.
  `style:` / rastgele renk/padding parametresi YOK. Görünüm farkı tek _resolveStyle'da.
- Dokunma alanı ≥ 48, Semantics etiketi, odak sırası, metin ölçeği 2.0'da taşma yok.
- Golden: açık/koyu × compact/expanded × metin 1.0/2.0; davranış testi (devre dışı / loading
  durumunda dokunma kapalı vb.). Referans PNG commit'lenmez.
- Katalogda her varyant × boyut.
- U1–U6 kuralları; değerler yalnız context.colors/text/NzGap/tema.

SERBEST: bileşen içi yapı, animasyonlar, nötr görsel seçimler, envanterde ima edilen ama
yazmayan küçük yardımcı bileşen (gerekçeli, aynı grupta).
```

### W31 — buttons
`NzButton` (primary/secondary/ghost/danger, `size`, `loading`, `icon`, `expand`), `NzIconButton`.
Ek KESİN: `loading` iken `onPressed` çağrılmaz ve Semantics "meşgul" bildirir.

### W32 — inputs + form
`NzTextField`, `NzPasswordField`, `NzSearchField`, `NzCheckbox`, `NzSwitch`, `NzSelect`, `NzForm`
+ doğrulayıcılar.
Ek KESİN: sunucu `ApiError.fields[]` → alan hatası eşlemesi **tek yardımcıda** ve `field`
adıyla; eşleşmeyen alan hatası form düzeyinde gösterilir, yutulmaz (test). `NzPasswordField`
değeri log'a, `toString`'e, Semantics değerine düşmez. Otomatik doldurma ipuçları
(`autofillHints`) doğru.

### W33 — surfaces
`NzCard`, `NzSection`, `NzDivider`, `NzBadge`, `NzAvatar`.
Ek KESİN: `NzAvatar` ağdan görsel çekmez (bu oturumda yalnız baş harf/ikon); ağ görseli
gerekiyorsa SAPMA olarak raporla.

### W34 — lists
`NzListTile`, `NzPagedList`.
Ek KESİN: `NzPagedList` `PageSlice` (core/domain) ile çalışır; sonraki sayfa isteği aynı
anda en çok bir tane; hata durumunda otomatik yeniden deneme yok (alt satırda "yeniden dene");
aşağı çek yenile ilk sayfayı yeniden yükler. Veri yükleme geri çağrıyla gelir; bileşen
servis/repository bilmez.

### W35 — overlays
`NzDialog.confirm`, `NzBottomSheet`.
Ek KESİN: yıkıcı onay varyantında birincil eylem `danger`; geri tuşu/dışarı dokunma =
iptal (onay değil).

### W36 — A5 Router

```
Görev: yol haritası A5: lib/app/router.dart → lib/app/router/ (router.dart faz kapısı,
routes.dart tipli rotalar, shell.dart NzAdaptiveShell + StatefulShellRoute.indexedStack),
go_router_builder ile tipli rotalar, feature rota kaydı sözleşmesi (List<RouteBase> get
<f>Routes), 404/bilinmeyen rota sayfası, geçişler tek yerde. Yer tutucu sayfalar NzPage ile.

Sahip olduğun: lib/app/router/** (router.dart taşınır), lib/app/app.dart (yalnız router
bağlama satırları), lib/app/dev/** içindeki katalog rotası satırı (taşıma), i18n/ui/router.tr.json,
test/app/router/**, ilgili *.g.dart (make gen çıktısı).

KESİN:
- Faz kapısı davranışı BİREBİR korunur: routeForPhase + redirect; her AppPhase için hedef
  rota ve yönlendirme taşımadan önce test ile sabitlenir (önce mevcut davranışı yakalayan
  test, sonra taşıma — ADR-0001'deki yöntem). Faz dışı rotaya derin bağlantı faz kapısını
  aşamaz (test).
- Rotalar nesne değil kimlik taşır; `extra` ile nesne taşıma ve dize yol ile go() yasak.
  (Mümkünse bunu boundaries'e öneri olarak raporla; kuralı sen yazmazsın.)
- Kabuk yalnız scoped fazında; gezinme kalıbı W12'nin WindowClass'ına göre
  (compact NavigationBar, medium NavigationRail, expanded genişletilmiş ray). Sekme yığını
  korunur (test).
- Katalog rotası yalnız dev flavor.
- Güvenlik akışı (bağ doğrulama, oturum, kapsam) router'a bağlı kalır; router hiçbir
  servisi doğrudan çağırmaz, yalnız faz/durum okur.

SERBEST: geçiş animasyonu, 404 sayfası içeriği, kabuk iç düzeni, sekme listesinin yer
tutucu içeriği.
```

Denetimde özellikle bak (koordinatör kodu satır satır okur): `redirect` mantığının diff'i;
derin bağlantı + faz testi; `refreshListenable` bağlanması; yeniden bağlanmada (sunucu
değişimi) yığının temizlenmesi.

## Birleştirme sırası

W36 (router; `app.dart`'a dokunur) → W31 → W32 → W33 → W35 → W34. Her kit birleşmesinde
koordinatör `catalog_page.dart`'a grubun kayıt satırını ekler. Goldenlar her birleşmeden
sonra değil, dalga sonunda tek Linux üretimiyle de alınabilir (SERBEST) — ama `main`'e
giren her PR'da CI yeşil olmalı (KESİN).

## Oturum çıkış ölçütü

`main`'de: kit v0 tamamı + katalog tüm gruplar; tipli router + uyarlanabilir kabuk + 404;
faz kapısı testleri yeşil; Q1 `widgets` ≥ eşik; `ilerleme.md` O4 kaydı.
