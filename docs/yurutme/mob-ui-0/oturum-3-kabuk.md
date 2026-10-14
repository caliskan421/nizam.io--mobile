# O3 — A3: durum kalıbı + sayfa kabuğu + feedback kiti + katalog

Kritik yol bu oturumdur: O4'teki her bileşen ve ekran buradaki API'yi kullanır.

## Açılış istemi (Opus oturumuna yapıştır)

```
MOB-UI-0 O3 oturumunu koordinatör olarak yürüt.
Oku: nizam.io--mobile/docs/yurutme/mob-ui-0/koordinator.md → oturum-3-kabuk.md → ilerleme.md
→ yol-haritasi-ui-temeli.md (A3, A4 ilkeler, §5) → adr-0003-ui-temeli.md → main'deki lib/core/ui/**.
Önce "Adım 1 — API imzaları"nı kendin yaz ve main'e birleştir; sonra W21 ve W22'yi paralel başlat.
Ürün sahibine soru sorma.
```

## Adım 1 — Koordinatör: API imzaları (sıralı)

İki uygulayıcının paralel çalışabilmesi için ortak yüzey önce sabitlenir. Koordinatör
`docs/architecture/ui-api-a3.md` yazar (kod değil, imza belgesi) ve küçük PR ile birleştirir:

- `NzLoader`, `NzSkeleton`, `NzEmptyState`, `NzErrorState`, `NzBanner`, `NzToast` (servis
  biçimi dahil): yapıcılar, isimli yapıcılar, parametre adları/tipleri.
- `NzPage`, `NzContentWidth`, `NzAsyncView<T>`, `ref.listenErrors`, `ref.listenSuccess`
  imzaları.
- Katalog kayıt sözleşmesi: her kit grubu `lib/app/dev/catalog/<grup>_catalog.dart` içinde
  `List<CatalogEntry> get <grup>CatalogEntries` verir; `catalog_page.dart` bunları birleştirir
  (O4'te paralel gruplar tek dosyaya yazmasın diye).

KESİN: imzalar yol haritası A3/A4 ilkelerine uyar (varyant = isimli yapıcı + enum, `style:`
kaçış kapısı yok, yalnız geri çağrı). İç uygulama yazılmaz.

## Dalga 2 — 2 paralel uygulayıcı

### W21 — Feedback kiti + katalog altyapısı

```
Görev: docs/architecture/ui-api-a3.md'deki feedback bileşenleri (NzLoader, NzSkeleton,
NzEmptyState, NzErrorState, NzBanner, NzToast) + katalog altyapısı (lib/app/dev/catalog_page.dart,
CatalogEntry, feedback_catalog.dart, dev flavor rotası).

Sahip olduğun: lib/core/ui/widgets/feedback/**, lib/app/dev/**, dev rotası için
lib/app/router.dart'ta yalnız katalog rota satırları, i18n/ui/feedback.tr.json,
test/core/ui/widgets/feedback/**, test/app/dev/**.

KESİN:
- İmzalar ui-api-a3.md ile birebir. Değiştirmen gerekirse değiştirme; SAPMA olarak raporla.
- NzErrorState metni yalnız errorText(ApiError); ApiError.retryAfter varsa geri sayım.
  Otomatik yeniden deneme yok — yalnız onRetry geri çağrısı.
- Katalog yalnız dev flavor'da erişilebilir; prod derlemesinde rota yok (test ile kanıt).
- Her bileşen: const yapıcı, dokunma alanı ≥ 48 (etkileşimliyse), Semantics, metin ölçeği
  2.0'da taşma yok; golden: açık/koyu × compact/expanded × metin 1.0/2.0 (W12'nin matris
  yardımcısıyla) + davranış testi.
- Ham renk/TextStyle/sayı boşluk yok (U1–U3); değerler context.colors/text/NzGap.

SERBEST: iskelet animasyonu, toast kuyruğu davranışı, katalog sayfası düzeni, boş durum
görsel içeriği (nötr, token'la).
```

### W22 — Sayfa kabuğu + durum görünümü + yan etki uzantıları

```
Görev: ui-api-a3.md'deki NzPage, NzContentWidth, NzAsyncView<T>, ref_ext.dart
(listenErrors, listenSuccess). Feedback bileşenlerini ui-api-a3.md imzalarına göre kullan;
W21 paralel yazıyor — yerelde derleme için imzaya uyan geçici sahte dosya OLUŞTURMA;
bunun yerine W21 birleşene kadar yalnız kendi dosyalarını ve testlerini yaz, testlerde
feedback bileşenlerini tipine göre bul (find.byType), birleştirme sonrası koordinatör
kapıları koşar.

Sahip olduğun: lib/core/ui/page/**, lib/core/ui/state/**, lib/core/ui/extensions/ref_ext.dart,
test/core/ui/page/**, test/core/ui/state/**, test/core/ui/extensions/ref_ext_test.dart.

KESİN:
- NzPage: Scaffold + SafeArea + context.layout.pagePadding + NzContentWidth + çevrimdışı
  şerit (connectivityStateProvider → NzBanner) + metin ölçeği üst sınırı (W12 yardımcısı).
  U6: features presentation'da Scaffold yasağının tek meşru karşılığı budur.
- NzAsyncView: yükleniyor / hata (NzErrorState + onRetry) / boş / veri; yenilemede eski
  veri gösterilir (skipLoadingOnRefresh).
- listenErrors: oturum bitti sınıfı hatalar (client.session_ended vb. — ClientErrorCode'dan
  tam liste) ekrana gösterilmez; faz makinesi yönlendirir. Liste koddan, elle dize değil.
- Yan etki build içinde değil ref.listen ile.

SERBEST: yükleme örtüsü davranışı, şerit animasyonu, iç widget bölümü.
```

Not (koordinatör): W22 derlemesi W21'e bağlıdır. W22'yi W21 ile aynı anda başlat; W22
raporu geldiğinde W21 birleşmemişse W22 dalını W21 dalı üzerine `rebase` et ve kapıları o
zaman koş. Bu, imza belgesinin doğruluğunun da testidir: kırılma varsa imza belgesi
düzeltilir, ilerleme.md'ye yazılır.

Denetimde özellikle bak: `listenErrors` oturum bitti listesinin eksiksizliği; çevrimdışı
şeridin `PrivacyMask` ile uyumu; `NzAsyncView`'in hata durumunda `ApiError` dışı istisnaya
davranışı.

## Birleştirme sırası

W21 → W22.

## Oturum çıkış ölçütü

`main`'de: feedback kiti + katalog (dev), `NzPage`, `NzAsyncView`, `ref.listenErrors/Success`;
goldenlar Linux referanslı; `ilerleme.md` O3 kaydı + imza belgesinden sapma varsa not.
