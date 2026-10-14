# O2 — Temel katman: A1 Tema · A2 Layout · A3b Bağlantı · A6 Tercihler · §4 Sayfalama

## Açılış istemi (Opus oturumuna yapıştır)

```
MOB-UI-0 O2 oturumunu koordinatör olarak yürüt.
Oku: nizam.io--mobile/docs/yurutme/mob-ui-0/koordinator.md → oturum-2-temel.md → ilerleme.md (O1 kaydı)
→ yol-haritasi-ui-temeli.md (A1, A2, A3b, A6, §4) → adr-0003-ui-temeli.md.
O1 çıkış ölçütü main'de sağlanmadıysa yeni iş başlatma, önce onu kapat.
5 uygulayıcıyı tek dalga olarak paralel başlat; birleştirme sırasına uy. Ürün sahibine soru sorma.
```

## Hazırlık (koordinatör)

- `ilerleme.md` "Sıkılaştırılan kurallar"ı her uygulayıcının KESİN listesine ekle.
- W15 için backend etiketindeki sayfalama biçimini kendin doğrula
  (`git -C nizam.io--backend show <api-pin backendTag>:docs/api/openapi.yaml`): cursor mı,
  offset/total mı, ikisi mi? Bulduğunu W15 istemine **somut alan adlarıyla** yaz.

## Dalga 1 — 5 paralel uygulayıcı

### W11 — A1 Tema

```
Görev: yol haritası A1'in tamamı: AppTheme.light()/dark(), NzTextStyles (ThemeExtension),
bileşen temaları, context_ext.dart (colors, text, l10n, theme; layout getter'ı W12 ekler),
ThemeData'nın app.dart'tan taşınması, U2 app.dart geçiş istisnasının tool/boundaries.dart'tan
silinmesi.

Sahip olduğun: lib/core/ui/theme/**, lib/core/ui/extensions/context_ext.dart, lib/app/app.dart
(yalnız tema satırları), tool/boundaries.dart (yalnız app.dart istisnasını silmek),
test/core/ui/theme/**, test/core/ui/extensions/**, i18n/ui/theme.tr.json (gerekirse).

KESİN:
- ColorScheme tohumdan değil rollerden (ColorScheme.fromSeed yasak) — yol haritası A1 eşlemesi.
- Değerler yalnız tokens.gen.dart'tan; token'da olmayan (gölge, süre, opaklık, ikon boyutu)
  app_theme.dart içinde tek yerde `// TOKEN-BEKLİYOR` ile. tokens.json'a sen eklemezsin.
- Theme.of(context).extension<…>() yalnız context_ext.dart'ta (U5).
- Testler: her rol → ColorScheme eşleme birim testi; lerp testi; token sayfası golden'ı
  (açık/koyu) — referans PNG commit'lenmez.
- Tema modu davranışı (ThemeModeController, runApp öncesi yükleme) değişmez.

SERBEST: metin rollerinin Material TextTheme'e eşleme ayrıntısı, bileşen teması değerlerinin
token içinden seçimi, dosya bölümü.
```

Denetimde özellikle bak: `app.dart`'ta tema dışı satıra dokunulmuş mu; istisna gerçekten
silinmiş ve `make boundaries` yeşil mi.

### W12 — A2 Layout

```
Görev: yol haritası A2: WindowClass + eşikler, NzLayout (pagePadding, contentMaxWidth,
columns, pick), AdaptiveValue, AdaptiveBuilder, metin ölçeği üst sınırının uygulanacağı
yardımcı (kabuk O3'te kullanır).

Sahip olduğun: lib/core/ui/layout/**, test/core/ui/layout/**.

KESİN:
- Eşikler compact < 600, medium 600–839, expanded ≥ 840; genişlikten, yönden değil.
- NzLayout.of yalnız MediaQuery.sizeOf dinler (klavye/inset değişiminde yeniden çizilmez —
  bunu kanıtlayan test). AdaptiveBuilder LayoutBuilder tabanlı (üst kısıt).
- Eksik sınıf bir küçüğüne düşer (pick(compact: 1, expanded: 3) medium'da 1).
- Test matrisi 360×800, 412×915, 700×1000, 1024×1366; bu matris diğer uygulayıcıların
  kullanacağı tek yardımcıda (test/support/ içinde yeni dosya — sahip sensin).
- context_ext.dart'a DOKUNMA; `layout` getter'ı W11 birleştikten sonra koordinatör
  isteğiyle eklersin (birleştirme adımı).
- pagePadding değerleri token'dan; token yoksa TOKEN-BEKLİYOR kalıbı kendi dosyanda.

SERBEST: NzLayout'un alanları (yol haritasındakilere ek), API biçimi, yardımcı adlandırma.
```

### W13 — A3b Bağlantı durumu

```
Görev: yol haritası A3b: ConnectivityMonitor (lib/core/network/), port + durum
(çevrimiçi/çevrimdışı/bilinmiyor), iki girdi: connectivity_plus olayı (ipucu) + son istek
sonucu (ApiError ağ kodu → çevrimdışı, başarılı yanıt → çevrimiçi);
connectivityStateProvider (Riverpod port, varsayılanı UnimplementedError); bileşim köküne kayıt.

Sahip olduğun: lib/core/network/**, lib/app/di/dependencies.dart (yalnız bu kayıt satırları),
lib/core/providers.dart (yalnız bu port), dio araya giricisi gerekiyorsa lib/core/http/ içinde
yalnız yeni dosya + tek kayıt satırı, test/core/network/**.

KESİN:
- Çevrimiçine dönüşte otomatik yeniden deneme YOK; izleyici yalnız durum yayar.
- connectivity_plus yalnız lib/core/network/ içinde import edilir; arayüz olayı tek başına
  "çevrimiçi" demez (yalnız ipucu: çevrimdışı → bilinmiyor/çevrimdışı; çevrimiçi kanıtı
  sunucu yanıtıdır).
- İstek sonucu girdisi belirteç/URL/gövde taşımaz, log'a yazmaz.
- Q3 testi yeni portu kapsar (W03'ün testi koddan topluyorsa kendiliğinden — doğrula).
- Platform kanalı testte sahte bağdaştırıcıyla; gerçek ağ yok.

SERBEST: durum geçiş kuralları ayrıntısı (yukarıdakileri bozmadan), debounce, sınıf yapısı,
araya girici mi depo dinleyicisi mi.
```

Denetimde özellikle bak: oturum yenileme ve faz makinesiyle etkileşim — izleyicinin bir
istek tetikleyip tetiklemediği; `dependencies.dart`'ta başlatma sırası (ADR-0001 startup).

### W14 — A6 Tercihler

```
Görev: yol haritası A6: AppPreferences içinde tipli _Pref<T> tanımı (dışarı açılmaz);
mevcut tema tercihi buna taşınır; yeni tercih: dil (yalnız tr, altyapı) — anahtar + get/set
+ controller (ValueNotifier) + Riverpod _listen sağlayıcısı (ThemeModeController emsali);
runApp öncesi yükleme.

Sahip olduğun: lib/core/preferences/**, lib/app/di/dependencies.dart (yalnız tercih
kayıtları), lib/app/bootstrap.dart (yalnız ön yükleme), lib/core/providers.dart (yalnız
tercih portları), test/core/preferences/**.

KESİN:
- S5/S7 korunur: ham depo yalnız AppPreferences ve app/di; _Pref dışarı açılmaz; tipi
  silinmiş değer verilmez.
- Mevcut tema anahtarı ve kaydedilmiş değer uyumu bozulmaz (eski kayıtlı değer okunur —
  test).
- Gizli/kişisel veri yok; "son seçili kapsam" bu oturumda EKLENMEZ (oturuma bağlıdır, A7'de
  karar).
- Okuma hatası varsayılana düşer (test).

SERBEST: _Pref API'si, kodlayıcı biçimi, controller ayrıntısı.
```

### W15 — §4 Sayfalama modeli + veri kalıbı belgesi

```
Görev: (1) lib/core/domain/page_slice.dart — backend sayfalama biçimine birebir uyan saf
Dart değişmez model (koordinatörün verdiği alanlar: <KOORDİNATÖR DOLDURUR>). (2) Domain enum
"bilinmeyen değer → unknown" yardımcısı (tek yerde). (3) Yol haritası §4'ü uygulayıcı
gözüyle kısa bir rehbere çevir: docs/architecture/veri-kalibi.md (IdentityRepository emsaliyle,
yeni feature'ın repository → domain eşlemesini adım adım).

Sahip olduğun: lib/core/domain/** (yeni), test/core/domain/**, docs/architecture/veri-kalibi.md.

KESİN:
- core/domain saf Dart (S4): Flutter, dio, üretilmiş DTO import'u yok.
- Alan adları ve anlamları backend etiketindeki openapi.yaml ile birebir; uydurma alan yok.
- Rehber yol haritası §4 ile çelişmez; çelişki görürsen SAPMA olarak raporla, rehberi
  yol haritasına göre yaz.

SERBEST: model API'si (map, append vb.), rehber üslubu ve uzunluğu (kısa tercih edilir).
```

## Birleştirme sırası

W11 → W12 (main'i alır, `context_ext.dart`'a `layout` getter'ını ekler — koordinatör bu
tek görevi `SendMessage` ile verir, sahipliği bu satır için açar) → W15 → W14 → W13
(`dependencies.dart` / `providers.dart` çakışmaları bu sırada koordinatörce çözülür).

## Oturum çıkış ölçütü

`main`'de: `AppTheme` + `NzTextStyles` + `context.colors/text/layout/l10n`, `ColorScheme.fromSeed`
yok, U2 istisnası yok; `NzLayout` + matris yardımcısı; `connectivityStateProvider`; tipli
tercihler + dil; `PageSlice` + rehber. Golden referansları Linux'ta üretildi ve gözden
geçirildi. Q1/Q2/Q3 yeşil. `ilerleme.md` O2 kaydı.
