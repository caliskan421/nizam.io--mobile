# O1 — A0: karar kaydı, kurallar, kapılar, ön hazırlık

## Açılış istemi (Opus oturumuna yapıştır)

```
MOB-UI-0 O1 oturumunu koordinatör olarak yürüt.
Oku: nizam.io--mobile/docs/yurutme/mob-ui-0/README.md → koordinator.md → oturum-1-a0.md → ilerleme.md
→ nizam.io--mobile/docs/architecture/yol-haritasi-ui-temeli.md (tamamı) → adr-0001, adr-0002.
oturum-1-a0.md'deki adımları sırayla uygula. Kod yazma; uygulayıcıları Sonnet alt ajan olarak başlat.
Ürün sahibine soru sorma. Kapanışta ilerleme.md'yi güncelle.
```

## Adım 1 — Koordinatör: belgeler (sıralı, uygulayıcı yok)

Tek PR (`mob-ui/o1-belgeler`), uygulayıcılardan **önce** birleşir. Bu PR, henüz commit'lenmemiş
`docs/architecture/yol-haritasi-ui-temeli.md` ve `docs/yurutme/mob-ui-0/**` dosyalarını da
taşır (uygulayıcı worktree'leri `origin/main`'den açılır; belgeler orada olmalı).

KESİN içerik:

1. **Yol haritası** Taslak → Kabul. Şu düzeltmeler belgeye işlenir:
   - A3 kapsamına A4 `feedback` grubu (`NzLoader`, `NzSkeleton`, `NzEmptyState`,
     `NzErrorState`, `NzBanner`, `NzToast`) ve katalog altyapısı alınır (A3 ↔ A4 döngüsü).
   - §3 başlığındaki "sıra bağlayıcı; her aşama ayrı PR" → "bağımlılık bağlayıcı; dalga
     planı `docs/yurutme/mob-ui-0/`".
   - U2 geçiş istisnası: `lib/app/app.dart` yalnız A1 birleşene kadar U2'den muaf; A1 PR'ı
     muafiyeti siler (W11 sorumluluğu).
   - UI metin kaynağı: `i18n/ui/<grup>.tr.json` (elle yazılır, grup başına ayrı dosya →
     paralel uygulayıcılar çakışmaz) → `make gen` → `app_tr.arb`. Anahtar öneki `ui.<grup>.`.
   - Golden referans yolu: yalnız Linux (W02'nin kurduğu araç).
2. **`docs/architecture/adr-0003-ui-temeli.md`** — yol haritası §6 "Açık kararlar"
   tablosunun tamamı varsayılanıyla kapanır; ek olarak: kit öneki `Nz`, pencere sınıfı
   eşikleri, durum kalıbı, base view yerine bileşim, UI metin kaynağı, golden yolu, dalga
   planı sapması. ADR-0001 biçimini izler.
3. **Kural tanımı tablosu** (ADR-0003 eki ya da ayrı bölüm) — W01'in uygulayacağı her kural
   (U2, U3, U4, U5, U6, G3) için: kimlik, yasak kalıp, izinli yollar, en az 1 pozitif + 2
   negatif örnek (atlatma denemesi dahil: takma ad, tear-off, `import as`). **Bugünkü kodda
   her kuralın kaç ihlal verdiğini kendin ölç** (grep/analiz) ve tabloya yaz; W01'in
   beklenen değeri budur.
4. **Kapsama ölçümü:** `flutter test --coverage` koş, yol haritası Q1 dizinlerinin bugünkü
   satır kapsamasını ölç, tabloya yaz. Eşik altı dizin varsa: eşik **düşürülmez**; ADR-0003'e
   tarihli geçiş notu ("<dizin> için kapı O<n>'de zorunlu olur") ya da W03'e test görevi —
   hangisi az iş ise. Kararını ADR'ye yaz.
5. Yönetim deposu kök `.gitignore`'a `/nizam.io--mobile-wt-*/` eklenir (yalnız o dosya, yol
   yoluna commit: `program(MOB-UI-0): mobil worktree dizinleri yok sayılır`).

SERBEST: ADR anlatımı, belge düzeni, tabloların biçimi.

## Adım 2 — Dalga 0: 4 paralel uygulayıcı

Adım 1 PR'ı `main`'e girdikten sonra dört worktree `origin/main`'den açılır, dört ajan tek
mesajda başlatılır.

### W01 — Sınır kuralları U2–U6, G3

```
Görev: ADR-0003'teki kural tanımı tablosundaki U2, U3, U4, U5, U6, G3 kurallarını
tool/boundaries.dart'a ekle; her kural için test/tool/boundaries_test.dart negatif matrisine
tablodaki örneklerin tamamını ve en az bir atlatma denemesini ekle.

Sahip olduğun: tool/boundaries.dart, tool/check_boundaries.dart, tool/api_surface.dart
(yalnız G3 tip çözümlemesi gerekirse), test/tool/boundaries_test.dart, test/tool/api_surface_test.dart.

KESİN:
- Kural kimlikleri, izinli yollar ve app.dart geçiş istisnası tablodakiyle birebir.
- Bugünkü kodda kural başına ihlal sayısı tablodaki beklenen değere eşit (istisna
  uygulandıktan sonra `make boundaries` yeşil). Sayı tutmazsa kuralı esnetme; DUR, raporla.
- G3 ad tabanlı değil tip çözümlemeli (analyzer element'i); `*Service`/`*Repository`
  yapıcı çağrısı `features/**/presentation/**` içinde yasak.
- Mevcut kuralların (B*, D*, S*, A*, G1, G2, U1) davranışı değişmez; mevcut testler aynen geçer.

SERBEST: kuralların kod içi düzeni, ortak ziyaretçi/yardımcı çıkarımı, hata mesajı metni.
```

Denetimde özellikle bak: atlatma testleri gerçekten kırmızı mı (kuralı geçici kapatıp
testin düştüğünü gör); U4 `MediaQuery.of` ile `maybeOf` ayrımı; U5 izinli tek dosya.

### W02 — Kapsama (Q1), test varlığı (Q2), golden altyapısı

```
Görev: (1) tool/check_coverage.dart — lcov.info ayrıştırır, yol haritası Q1 dizin eşiklerini
uygular, üretilmiş dosyaları hariç tutar. (2) tool/check_test_presence.dart — Q2 kuralı.
(3) Golden altyapısı: golden testleri etiketle ayrılır, referanslar yalnız Linux'ta üretilir
ve doğrulanır. (4) Makefile hedefleri + CI adımları.

Sahip olduğun: tool/check_coverage.dart, tool/check_test_presence.dart, bunların testleri
(test/tool/), Makefile, .github/workflows/ci.yml, dart_test.yaml (yeni), test/flutter_test_config.dart
(gerekirse, yeni), test/support/golden*.dart (yeni).

KESİN:
- Eşikler ADR-0003'teki değerler; ADR'de geçiş notu olan dizin o nota göre davranır, başka
  istisna yok. Yeni paket yok (lcov kendi ayrıştırıcımız).
- Her iki araç negatif testli (eşik altı → çıkış kodu ≠ 0; eksik test dosyası → ≠ 0).
- Golden: macOS'ta golden testleri koşmaz ya da atlanır (yerel `make test` yeşil kalır);
  CI Linux'ta koşar. Referans üretimi için iki yoldan biri: CI'da `workflow_dispatch`
  `golden-update` işi (artefakt olarak yükler) ya da `make golden-linux` (adı sabit,
  `nizamio-` önekli konteyner, işi bitince adıyla kaldırılır). Seçimini rapora yaz.
- CI sırası: mevcut adımlar değişmez; `make test` yerine/sonrasına kapsama + test varlığı
  adımları eklenir. Eylemler commit SHA'ya sabit (mevcut düzen).
- Makefile: `coverage`, `test-presence`, golden hedef(ler)i; `verify` bunları içerir.

SERBEST: araçların iç yapısı, çıktı biçimi, golden etiket adı, karşılaştırıcı toleransı
(gerekçeli).
```

Denetimde özellikle bak: üretilmiş dosya hariç tutma desenleri; Q2'nin bugünkü kodda
yalnız `IdentityService` testini eksik bulması (W03 birleşince yeşil); CI'ın gizli anahtar
kullanımı değişmemiş mi.

### W03 — Q3 kayıt denetimi + IdentityService testi

```
Görev: (1) test/features/identity/application/identity_service_test.dart (doğrudan testi
yok — yol haritası Q2 notu). (2) test/app/composition_test.dart'a Q3: bileşim kökü
kurulduktan sonra core + her feature'ın *Overrides listesindeki bütün Riverpod portları
okunur, hiçbiri UnimplementedError atmaz; port listesi elle değil koddan toplanır (yeni
feature eklenince testin kendiliğinden kapsaması için). (3) ADR-0003 kapsama notunda sana
test görevi verildiyse o dizinin testleri.

Sahip olduğun: test/features/identity/**, test/app/composition_test.dart, test/support/**
(yalnız ekleme), ADR-0003'te sana atanmış test yolları.

KESİN:
- Üretim kodunu (lib/**) değiştirmezsin. Test edilemeyen bir yer bulursan SAHİPLİK-DIŞI
  İHTİYAÇ olarak raporla.
- Q3 negatif kanıt: bir portun geçersiz kılınmadığı senaryoda testin düştüğünü gösteren
  test (ya da yorumla belgelenmiş elle doğrulama çıktısı raporda).
- Gerçek backend'e bağlanmazsın; mevcut test/support/harness.dart ve fake_backend.dart.

SERBEST: test kurgusu, yardımcılar, senaryo seçimi.
```

### W04 — Lint, UI metin kaynağı, paketler

```
Görev: (1) analysis_options.yaml'a yol haritası A0 lint listesi; çıkan uyarıları düzelt.
(2) tool/gen.dart'a UI metin kaynağı: i18n/ui/*.tr.json (grup başına dosya, anahtar öneki
ui.<grup>.) → app_tr.arb; boş i18n/ui/README.md kuralı açıklar; örnek olarak
i18n/ui/common.tr.json (ortak: yeniden dene, iptal, tamam, kapat vb. — az ve gerçekten ortak).
(3) pubspec.yaml'a connectivity_plus (bağımlılık) ve go_router_builder (dev) — ADR-0003
kararı; sürümler mevcut Flutter ile uyumlu en güncel kararlı.

Sahip olduğun: analysis_options.yaml, lint düzeltmesi için gereken lib/** ve test/** dosyaları
(yalnız lint kaynaklı değişiklik), tool/gen.dart, tool/gen/**, test/tool/gen_test.dart, i18n/ui/**,
pubspec.yaml, pubspec.lock, üretilmiş dosyalar (yalnız make gen çıktısı olarak).

KESİN:
- Lint düzeltmesi davranış değiştirmez; yalnız lint'in istediği değişiklik.
- Anahtar çakışması (ui.* ile client.*/sunucu kodu) make gen'de hata verir; testli.
- Paket ekleme dışında pubspec değişikliği yok; `flutter pub get` sonrası lock commit'lenir.
- make gen-check yeşil (üretilmiş dosyalar commit'li).

SERBEST: ARB anahtar adlandırma ayrıntısı (önek dışında), JSON şeması, gen içi yapı.
```

Denetimde özellikle bak: lint düzeltmeleri `lib/core/security`, `session`, `server`
altında davranış değiştirmiş mi (diff satır satır okunur).

## Birleştirme sırası

W04 (pubspec + gen; diğerlerinin tabanını değiştirir) → W01 → W03 → W02 (W02'nin kapıları
ancak W03'ün testi girince yeşil olur). Her birleşmeden sonra sıradaki dal `main`'i alır,
kapılar yeniden koşulur.

## Oturum çıkış ölçütü

- `main`'de: ADR-0003 kabul, yol haritası kabul, U2–U6/G3 aktif (yalnız app.dart muaf),
  Q1/Q2/Q3 CI'da zorunlu ve yeşil, golden yolu çalışıyor (en az bir örnek golden ile
  kanıtlanmış — W02'nin araç testi yeterli), `i18n/ui/` kaynağı çalışıyor, iki paket eklendi.
- `ilerleme.md` O1 kaydı.
