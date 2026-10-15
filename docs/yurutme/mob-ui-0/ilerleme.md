# MOB-UI-0 ilerleme

Koordinatör her oturum kapanışında bir kayıt ekler (biçim: `koordinator.md`). Bir sonraki
oturum buradan başlar. Uygulayıcılar bu dosyaya yazmaz.

## Durum

| Oturum | Durum | main hash |
|---|---|---|
| O1 — A0 | TAMAM (son denetim Opus; nihai Codex kapısı O5'te) | `4737566` + kapanış PR'ı #27 |
| O2 — Temel | TAMAM | `b483efe` + kapanış PR'ı |
| O3 — Kabuk | TAMAM | `f9fd6cc` + kapanış PR'ı |
| O4 — Kit + Router | TAMAM | `4aaa11d` + kapanış PR'ı |
| O5 — Pilot + Kapanış | TAMAM — **MOB-UI-0 KAPANDI** | `60dde43` + kapanış PR'ı |
| O6 — A8 devri (tasarımdan bağımsız) | TAMAM | `0511958` + kapanış PR'ı |

## Sıkılaştırılan kurallar (bir sonraki oturumdan itibaren her uygulayıcıya KESİN)

- (O1) **Golden piksel kanıtı:** her yeni golden testinin yanında golden etiketsiz, macOS'ta da
  koşan bir test hedefin boyutunu ve en az bir pikselin rengini/alfasını doğrular
  (`test/support/golden_smoke_test.dart` emsali). Koordinatör CI artefaktını PNG çözerek inceler;
  boş/saydam referans commit'lenmez (W02 iki turda saydam referans üretti).
- (O1) **Yeni Riverpod portu** eklenen PR, `test/app/composition_test.dart` içindeki
  `portProviders` tablosunu da günceller (Q3 tablo ↔ kod eşitliği; aksi halde CI kırılır).
- (O1) **UI metni yer tutucusuz:** `i18n/ui/*.tr.json` metinlerinde `{` `}` yasaktır
  (`make gen` düşer). Parametreli metin gerekirse önce gen kuralı ADR ile genişletilir.
- (O1) Uygulayıcı worktree'si yalnız önkoşul PR'ları `main`'e birleşip `main` CI yeşilken
  `origin/main`'den açılır; birleşmemiş daldan taban alınmaz.
- (O2) **Kapılar commit'li temiz ağaçta koşulur:** `make gen-check` izlenmeyen yeni dosyada
  düşer; uygulayıcı önce commit'ler, sonra beş kapıyı (`gen-check`, `lint`, `test`,
  `test-presence`, `coverage`) koşar ve raporda bunu belirtir.
- (O2) **Yeni Riverpod portu açan uygulayıcının sahipliğine** baştan
  `lib/app/di/composition.dart` (yalnız o portun override satırı + import) yazılır; aksi halde
  Q3 kırılır (W13 ve W14 ikisi de SAHİPLİK-DIŞI ihtiyaç çıkardı). Bileşim kökü/`bootstrap.dart`
  bağlaması gereken altyapı (ör. platform bağdaştırıcısı) da aynı istemde sahipliğe yazılır.
- (O2) **Mutlak yol:** uygulayıcı yalnız istemdeki mutlak worktree yolunda çalışır; ortamın
  gösterdiği başlangıç dizinine güvenmez (W14/W15 başlangıç dizinini başka worktree gördü,
  yazma olmadı).
- (O3) **Golden testleri yalnız `goldenTestWidgets` ile** (`test/support/golden.dart`: uygulama
  yazı tipleri + MaterialIcons `FontManifest`'ten yüklenir). İkonlu golden'da tofu (boş kare)
  kabul edilmez; koordinatör her referansı görsel inceler (W21 ilk turda tofu üretti).
- (O3) **Riverpod otomatik yeniden deneme kapalı:** üretim `ProviderContainer(retry: (_, _) => null)`;
  testte kurulan her container da aynı ayarı alır. Yeniden deneme yalnız kullanıcı dokunuşuyla.
- (O3) **Bağımlı uygulayıcı** henüz birleşmemiş bileşen için sahte/geçici dosya oluşturmaz;
  sabit imzaya göre yazar, `KISMİ` raporlar; koordinatör bağımlılık birleşince `rebase --onto`
  ile `main`'e taşır ve kapıları koşar. Paralel bağımlılıkta imza koordinatörce iki isteme de
  aynen yazılır.
- (O4) **Paralel kit dalgasında üretilmiş i18n** (`app_tr.arb`, `app_localizations*.dart`) her
  birleşmede `main`'den alınıp `make gen` ile yeniden üretilir; elle birleştirilmez.
  `catalog_registry.dart` grup satırını koordinatör ekler (içe aktarmalar alfabetik —
  `directives_ordering`).
- (O4) **Güvenlik yüzeyi değişikliği** (router, oturum, bağ) iki commit'le gelir: önce mevcut
  kodda yeşil davranış testi, sonra testleri değiştirmeyen taşıma; koordinatör kapı işlevinde
  en az bir mutasyonla testlerin kırmızıya döndüğünü görür.

## Kırmızılar

- (O1) PR #22 squash birleştirmesi, koordinatör oturumunda Claude Code otomatik izin
  denetimince üç kez `[Merge Without Review]` ile reddedildi. Ret aşılmadı; PR #22 oturum
  dışından birleşti (`e5eeee4`). Sonraki #23–#26 birleştirmeleri normal
  `gh pr merge` ile geçti. Toplu worktree/dal temizliği komutu da bir kez `[Git Destructive]`
  ile reddedildi; adım adım güvenli komutlarla sürdürüldü, uzak/yerel dal silme yapılmadı.

## Oturum kayıtları

### O1 — 2026-10-14 — TAMAM
- O1 öncesi: mobil `main` `2524a14`; yönetim deposu `bb1fa5f`.
- PR'lar (squash; uygulayıcılar Sonnet 5.5 `claude-sonnet-5-5`, koordinatör Opus 5.5):
  - #22 ADR-0003 + yol haritası kabul + yürütme seti → `e5eeee4` (CI 38562131773 success)
  - (#14 kapsam dışı, oturum dışından birleşti → `5be61a5`; main CI 38570782840 success)
  - #23 W04 lint · UI metin kaynağı · connectivity_plus/go_router_builder → `3179f76` (CI 38573544356)
  - #25 W01 U2–U6 + G3 sınır kuralları → `9806570` (CI 38575607075)
  - #24 W03 IdentityService/errorText testleri · Q2 yol taşıması · Q3 → `3049906` (CI 38577518991)
  - #26 W02 Q1 kapsama · Q2 test varlığı · golden altyapısı · Makefile/CI → `4737566` (CI 38585866244)
  - #27 O1 kapanış: denetim düzeltmeleri (U5 örtük-`this` atlatması, `core/i18n/generated/` muafiyeti ADR Ek A'ya uyduruldu, Q3 test yorumu) + bu kayıt.
- main HEAD (uygulama): `4737566`, CI: 38587778596 — 1. deneme kullanıcı orkestrasyonu
  durdurduğu için iptal (test başarısızlığı değil); 2. deneme **success** (verify, golden,
  Android, entegrasyon yeşil; golden-update atlandı). Kapanış PR'ı #27'nin birleşme hash'i
  ve main CI'ı O2 açılışında `gh run list --branch main -L 3` ile doğrulanır.
- Kapsama: core %94,17 (614/652) · application %100 (39/39) · data %100 (17/17) ·
  presentation — (dosya yok) · widgets — (dosya yok). Testler `4737566`'da 325 (CI); #27 ile 326
  (golden hariç) + 1 golden.
- Son denetim (2026-10-14, kapanış oturumu): **Opus**, ayrı bağlamda salt okunur denetçi;
  Codex O1 denetimi **yapılmadı** (nihai Codex kapısı O5'te, değişmedi). Hüküm **ONAY**:
  çıkış ölçütlerinin 10 maddesi gerçek kodda geçti (ADR/yol haritası kabul; U2–U6 + G3
  izinli yollar ADR ile birebir, yalnız `app/app.dart` geçiş istisnası, G3 analyzer
  element'iyle; Q1 eşikleri O1 boyunca düşürülmedi; Q2/Q3 negatif testli; CI adımları
  zorunlu, eylemler SHA'ya sabit, gizli anahtar satırları değişmedi; `i18n/ui` → ARB
  çakışma/yer tutucu hataları testli; iki paket ve lock güncel; `lib/core/security|session|server`
  diff'i boş). Bulgular: 1 Önemli (bu kaydın taslağı CI bitmeden "TAMAM" diyordu, test sayısı
  324 yazılmıştı — düzeltildi), 6 Küçük: U5 atlatması, i18n/generated ADR↔kod farkı ve
  Q3 yorumu #27'de Sonnet ile düzeltildi; README komut tablosu, branch koruması ve
  bu listedeki önceki oturum iddiaları devirde.
- Kapanış koordinatörünün bağımsız kanıtları: golden PNG yeniden çözüldü (120×60,
  #336699 ×3600 + #CC9933 ×3600, 7200 pikselin hepsi alfa 255); #27 U5 düzeltmesi geri
  alınınca yeni atlatma testi kırmızı; #27'de `make lint` temiz, `check_boundaries` 188
  dosya ihlal yok.
- Önceki koordinatör oturumunun kanıtları (bu oturumda yeniden koşulmadı; denetçi test
  yapısıyla tutarlı buldu):
  - her dalda gen-check/lint/test ve main ile güncel hâlde tekrar;
  - W01 mutasyon denetimi: U2, U3, U4, U5, U6 ve G3 tek tek kapatılınca testler kırmızı;
  - Q1/Q2 gerçek veride negatif: W03 öncesi tam 2 eksik + `error_text.dart` kapsamasız → kırmızı;
  - Q3 negatif test + uygulayıcının elle silme doğrulaması;
  - golden referansı Linux CI üretimi, PNG çözümü 120×60 (#336699 ×3600, #CC9933 ×3600, alfa 255);
  - golden piksel testinde `stretch` kaldırma mutasyonu → kırmızı.
- Sapmalar (kabul edilen):
  - Q2 bugünkü açık 1 değil 2 (repository testi yanlış yolda; W03 taşıdı).
  - U2 izinli kesin dosya `core/security/privacy_mask.dart`.
  - U3 `google_fonts` importunu da kapsar.
  - U4 `maybeOf`'u da yasaklar.
  - Golden yolu: CI `golden` işi (sabit `ubuntu-24.04`, başarısızlıkta artefakt) + `workflow_dispatch` `golden-update`; `make golden-linux` yok.
  - CI `make test` adımı yerine `test-presence` + `coverage` (testleri de koşar).
  - Golden testleri kapsama dışı.
  - Q3 port eşlemesi testte tablo, kodla eşitliği zorunlu.
  - W02 golden örneği iki düzeltme turu aldı (saydam yakalama → `Row` stretch).
- Sıkılaştırılan kurallar: yukarıdaki listede (O1).
- Kırmızılar: yukarıdaki listede (O1 birleştirme reddi).
- Devir (O2'ye):
  - W11 (A1): `tool/boundaries.dart` `_a1Transition` istisnasını ve app.dart muafiyetini siler (ADR-0003 karar 18).
  - SAHİPLİK-DIŞI (W03): `Composition`'ın kurduğu `List<Override>`'ı dışarı vermesi, Q3 tablosunun koddan türetilmesine izin verir (lib/app/di sahibine).
  - SAHİPLİK-DIŞI (W02): README komut tablosuna `make coverage | test-presence | golden | golden-update` satırları.
  - Yerel ana çalışma ağacı (`nizam.io--mobile/`) `2524a14`'te; birleşen belgelerin untracked eski kopyalarını taşıyor (yedek `/tmp/o1-yedek`). Fast-forward öncesi bu kopyalar kaldırılmalı.
  - Uzak ve yerel `mob-ui/*` dalları (o1-belgeler, w01–w04, o1-ilerleme) silinmedi; içerikleri squash ile `main`'de.
  - Yönetim deposunda `bb1fa5f` ve `e948312` (`.gitignore` `/nizam.io--mobile-wt-*/`) push edilmedi.
  - Denetim Küçük (O1 dışı): `main` dalında koruma/ruleset yok; Q1/Q2 CI'da zorunlu ama birleştirmeyi engellemez. İstenirse ayrı iş.

### O2 — 2026-10-14 — TAMAM
- O2 öncesi: mobil `main` `a155b3e` (O1 kapanışı, CI 38593623162 success).
- PR'lar (squash; uygulayıcılar Sonnet 5.5, koordinatör Opus 5.5; birleştirme sırası W11 → W12 → W15 → W14 → W13):
  - #28 W11 A1 tema (AppTheme, NzTextStyles, context_ext; U2 app.dart istisnası silindi) → `a78772d` (PR CI 38608004729; main CI 38610015444 success)
  - #29 W12 A2 layout (WindowClass, NzLayout, AdaptiveBuilder, `context.layout`, ekran matrisi) → `5f1cb87` (PR CI 38610519801; main CI 38612515645 success)
  - #30 W15 §4 PageSlice/PageRequest, enumFromWire, `veri-kalibi.md` → `777ff83` (PR CI 38612747109; main CI 38614464621 success)
  - #31 W14 A6 tipli `_Pref`, dil tercihi + LocaleController → `7dcd606` (main CI 38616821358 success; aynı SHA'nın yinelenen koşumu 38616715905 iptal — test başarısızlığı değil)
  - #32 W13 A3b ConnectivityMonitor, `connectivityStateProvider` → `b483efe` (PR CI ve main CI 38619071462 success: verify, golden, Android, entegrasyon)
- main HEAD: `b483efe`, CI: 38619071462 success.
- Kapsama (main ile aynı ağaç, W13 birleşik HEAD): core %94,14 (916/973) · application %100 (39/39) ·
  data %100 (17/17) · presentation — (dosya yok) · widgets — (dosya yok). Testler 394 (golden hariç) + 3 golden.
- Çıkış ölçütü (main'de): `AppTheme` + `NzTextStyles` + `context.colors/text/theme/layout/l10n`;
  `ColorScheme.fromSeed` yok; U2/U3 `app.dart` geçiş istisnası `tool/boundaries.dart`'tan silindi
  (ADR-0003 karar 18 ve Ek A'ya "uygulandı" notu); `NzLayout` + `test/support/screen_matrix.dart`;
  `connectivityStateProvider`; tipli tercihler + dil; `PageSlice` + rehber; Q1/Q2/Q3 yeşil.
- Golden: `test/core/ui/theme/goldens/token_page_{light,dark}.png` Linux CI 38607599426 `golden-referans`
  artefaktından; koordinatör PNG'yi çözdü (400×464, 185 600 pikselin hepsi alfa 255; açık zemin
  #FFFFFF, koyu zemin #020617; ~300 renk) ve görsel olarak inceledi (12 rol kutusu + metin rolleri,
  gerçek yazı tipleri). Etiketsiz piksel testi her platformda 12 rolün RGBA'sını doğrular.
- Koordinatör bağımsız kanıtları: her dal için diff sahiplik denetimi ve kod okuması; her birleşmeden
  önce `main` birleşik HEAD'de gen-check/lint/test/test-presence/coverage tekrarı; W15 için sayfalama
  biçimi backend `v0.1.0-api` `openapi.yaml`'dan doğrulandı.
- Son denetim: bu oturumda ayrı denetçi koşulmadı; denetim koordinatör (Opus) tarafından. Nihai
  Codex kapısı O5'te (değişmedi).
- Sapmalar (kabul edilen):
  - W15: yol haritası §4'teki `total` alanı eklenmedi — sözleşmede yok (yalnız imleç:
    `limit`/`cursor` → `next_cursor`); `truncated` eklendi (`X-Result-Truncated`, en çok 200 satır).
    Yol haritası §4 sözleşmeyle hizalandı.
  - W13: port ikiye bölündü — `connectivityMonitorProvider` (bileşim kökünün bağladığı port) +
    `connectivityStateProvider` (türetilmiş durum; themeMode kalıbı). Sahiplik dışı küçük
    dokunuşlar kabul: `composition.dart` override + parametre, `dio_factory.dart` opsiyonel
    `connectivity` + 1 araya girici satırı, `apiDio` argümanı, `bootstrap.dart`
    `PlusConnectivityLink()`. 502/503/504 bağlantı sinyali sayılmaz.
  - W14: `composition.dart` override satırı (koordinatör onayıyla uygulayıcı yazdı).
  - W11: ham ölçüm testinde U5 artık `context_ext.dart`'taki 2 izinli çağrıyı sayar (kural gevşemedi).
  - W12: `NzLayout.of` yükseklik değişiminde de yeniden çizilir (`sizeOf` tüm boyuta bağlı);
    inset/padding değişiminde çizilmez (testli). İçerik genişliği token'ı yok (`TOKEN-BEKLİYOR`).
  - W13 ↔ W14 çakışmaları (`bootstrap`, `composition`, `dependencies`, `providers`, Q3 tablosu)
    koordinatörce iki taraf korunarak çözüldü; `providers.g.dart` `make gen` ile yeniden üretildi.
- Sıkılaştırılan kurallar: yukarıdaki listede (O2).
- Kırmızılar: yok.
- Devir (O3'e):
  - Kabuk `NzTextScaleLimit` (A2) ve `context.layout`'u kullanır; şerit/`NzBanner`
    `connectivityStateProvider`'ı tüketir (otomatik yeniden deneme yok, "yeniden dene" elle).
  - `app.dart` henüz `localeProvider`'ı tüketmiyor (yalnız `tr`); kabukta bağlanabilir.
  - `PageSlice`'ı kullanan gerçek repository yok; ilk liste ekranında rehbere göre.
  - Token bekleyenler: içerik genişliği (W12), gölge/süre/opaklık/ikon boyutu/kenarlık (W11 `_Pending`).
  - O1'den süren: README komut tablosu (coverage/test-presence/golden), `Composition` override
    listesinin dışa verilmesi (Q3 tablosunu koddan türetmek için), `main` dal koruması,
    yerel ana çalışma ağacı `2524a14` ve untracked eski kopyalar, yönetim deposu
    `bb1fa5f`/`e948312` push edilmedi.
  - Uzak ve yerel `mob-ui/w11–w15` dalları silinmedi; içerikleri squash ile `main`'de;
    worktree'ler kaldırıldı.

### O3 — 2026-10-15 — TAMAM
- O3 öncesi: mobil `main` `042e0b8` (O2 kapanışı, CI 38622268258 success).
- PR'lar (squash; uygulayıcılar Sonnet 5.5, koordinatör Opus 5.5; sıra imza → W21 → W22):
  - #34 Adım 1 imza belgesi `docs/architecture/ui-api-a3.md` (koordinatör) → `f911e04` (main CI 38627917213 success)
  - #35 W21 feedback kiti + dev katalog + golden yazı tipi yükleyici → `2a22478` (PR CI 38634181623; main CI 38635987132 success)
  - #36 W22 NzPage, NzAsyncView, ref.listenErrors/Success; Riverpod otomatik yeniden deneme kapalı → `f9fd6cc` (PR CI ve main CI 38638183608 success: verify, golden, Android, entegrasyon)
- main HEAD: `f9fd6cc`, CI: 38638183608 success.
- Kapsama (main ile aynı ağaç, W22 birleşik HEAD): core %94,72 (969/1023) · application %100 (39/39) ·
  data %100 (17/17) · presentation — (dosya yok) · widgets %99,56 (226/227). Testler 486 (golden hariç) + 9 golden.
- Çıkış ölçütü (main'de): feedback kiti (`NzLoader`, `NzSkeleton`, `NzEmptyState`, `NzErrorState`,
  `NzBanner`, `NzToast`) + `NzSize` + dev katalog (`/dev/catalog`, yalnız dev flavor; prod'da rota yok —
  testli); `NzPage`; `NzAsyncView`; `ref.listenErrors/listenSuccess` + `sessionEndedErrorCodes`;
  golden'lar Linux referanslı.
- Golden: `test/core/ui/widgets/feedback/goldens/nz_{loader,skeleton,empty_state,error_state,banner,toast}.png`
  Linux CI 38633601203 `golden-referans` artefaktından. Koordinatör PNG'leri çözdü (1024 genişlik,
  hepsi opak, açık #FFFFFF / koyu #020617 zemin, 122–1888 renk) ve görsel inceledi: ilk tur
  (CI 38632719755) ikonları **tofu** çiziyordu (MaterialIcons yüklenmiyordu) → reddedildi; W21
  `loadAppFonts()` ekledi, ikinci tur ikonlar gerçek; token sayfası referansları bayt düzeyinde aynı
  kaldı (Inter değişmedi). `NzErrorState` 429 görünümünde "Yeniden denemek için bekleyin 30 sn" +
  devre dışı düğme doğrulandı.
- İmza belgesi doğrulaması: W22, W21'in gerçek bileşenleriyle uyarlama gerektirmeden derlendi ve
  geçti (imza kırılması yok). Ek (additive) yüzey: `CatalogPage({entries})` (test), `NzSize.pick`,
  `catalogPath` sabiti.
- Denetim bulguları (koordinatör, Opus):
  - **Kritik — Riverpod 3 otomatik yeniden deneme:** üretim `ProviderContainer` `retry` vermiyordu;
    hata veren sağlayıcılar (429 dahil) üstel geri çekilmeyle kendiliğinden yeniden çalışıyordu →
    A3 "yeniden deneme yalnız dokunuşla" ve `retryAfter` sayacı boşa çıkıyordu. W22 `retry: (_, _) => null`
    + test (satır kaldırılınca kırmızı) ile düzeltti (#36).
  - **Önemli — golden tofu:** yukarıda; W21 düzeltti (#35).
  - **Küçük — NzAsyncView:** hatadan sonra yeniden yüklemede (Riverpod 3 `AsyncLoading` önceki hatayı
    taşır) gösterge yerine eski hata kalıyordu; sıra veri → yükleniyor → hata yapıldı + test (#36).
- Son denetim: ayrı denetçi koşulmadı; denetim koordinatör (Opus). Nihai Codex kapısı O5'te (değişmedi).
- Sapmalar (kabul edilen):
  - `sessionEndedErrorCodes` = `client.session_ended`, `client.not_signed_in`, `client.reauth_required`,
    `identity.force_password_change_required` (kaynak satırları `ref_ext.dart`'ta);
    `client.scope_missing` kasıtlı dışarıda (yalnız birim eksikse faz `scoped` kalır, kullanıcı görmeli).
  - Katalog kodu prod ikilisine derlenir (`router.dart` import'u) ama rota prod'da tanımlı değil;
    dev uygulamada kataloğa giriş noktası yok (rota hazır).
  - Katalog etiketleri/örnek metinleri geliştirici aracı olduğundan ARB dışı.
  - `NzErrorState` ikon boyutu boşluk token'ından (`space6/space12`) — ikon boyutu token'ı yok.
- Sıkılaştırılan kurallar: yukarıdaki listede (O3).
- Kırmızılar: yok.
- Devir (O4'e):
  - Kit grupları `feedback` emsalini izler (`feedback_test_support.dart` tabaka kurgusu salt okunur
    içe aktarılabilir); `catalog_registry.dart`'a grup satırını koordinatör birleştirmede ekler.
  - W35 (`NzDialog.confirm`) W31'in `NzButton`'ına bağlı: imza iki isteme de aynen yazıldı;
    W35 W31 birleşince `rebase --onto`.
  - W36 router taşıması `catalogPath`/`devCatalog` davranışını ve faz kapısı testlerini korur.
  - O1/O2'den süren açıklar (README komut tablosu, `main` dal koruması, yerel ana ağaç `2524a14`,
    yönetim deposu push'u, token bekleyenler) değişmedi.
  - Uzak/yerel `mob-ui/o3-imzalar`, `w21`, `w22` dalları silinmedi; worktree'ler kaldırıldı.

### O4 — 2026-10-15 — TAMAM
- O4 öncesi: mobil `main` `f9fd6cc` (O3 uygulama), `8697c96` (O3 kaydı, CI 38642013921 success).
- PR'lar (squash; uygulayıcılar Sonnet 5.5, koordinatör Opus 5.5; sıra W36 → W31 → W32 → W33 → W35 → W34):
  - #41 W36 A5 router (tipli rotalar, uyarlanabilir kabuk, 404, faz kapısı) → `924db60` (main CI 38645906102 success)
  - #38 W31 buttons (NzButton, NzIconButton) → `c6b3905` (main CI 38647632001 success)
  - #42 W32 inputs + form (NzTextField, NzPasswordField, NzSearchField, NzCheckbox, NzSwitch, NzSelect, NzForm) → `75b999c` (main CI 38649540469 success)
  - #40 W33 surfaces (NzCard, NzSection, NzDivider, NzBadge, NzAvatar) → `413f14a` (main CI 38651053649 success)
  - #43 W35 overlays (NzDialog.confirm, NzBottomSheet) → `229bc06` (main CI 38652757741 success)
  - #39 W34 lists (NzListTile, NzPagedList) → `4aaa11d` (PR CI 38653002103; main CI 38654428749 success: verify, golden, Android, entegrasyon)
- main HEAD: `4aaa11d`, CI: 38654428749 success.
- Kapsama (main ile aynı ağaç, W34 birleşik HEAD): core %95,11 (973/1023) · application %100 (39/39) ·
  data %100 (17/17) · presentation — (dosya yok) · widgets %99,52 (1044/1049). Testler 781 (golden hariç) + 27 golden.
- Çıkış ölçütü (main'de): kit v0 tamamı (feedback, buttons, inputs+form, surfaces, lists, overlays) +
  katalog tüm gruplar (`catalog_registry.dart`, 6 grup); tipli router (`lib/app/router/`,
  go_router_builder) + `NzAdaptiveShell` (compact NavigationBar / medium Rail / expanded genişletilmiş
  Rail, sekme yığını korunur) + 404; faz kapısı testleri yeşil; Q1 widgets %99,52 ≥ %70.
- W36 (güvenlik yüzeyi) denetimi: commit sırası `c50c1b9` davranış testi (eski kodda yeşil, 41 test) →
  `8698a02` taşıma (testlerde yalnız import) → `2223324` yeni testler (faz × rota matrisi `router.go`
  + platform `handlePushRoute`; bilinmeyen yol kapıyı aşamaz; scoped dışına çıkışta yığın temizlenir).
  Koordinatör `gateRedirect`'i satır satır okudu; mutasyon (a) scoped koşulu kaldırma → 27+ test kırmızı,
  (b) katalog muafiyetini koşulsuz yapma → katalog testi kırmızı. `extra`/dize `go()` kullanımı yok.
- Golden: 18 yeni referans (buttons 2, inputs 7, surfaces 5, lists 2, overlays 2) PR CI `golden-referans`
  artefaktlarından (38641161755, 38643922580, 38641720774, 38641524725, 38648372084); koordinatör hepsini
  çözdü (1024 genişlik, opak, açık/koyu zemin, 43–5115 renk) ve görsel inceledi: ikonlar gerçek
  (O3 yükleyicisi), `NzAvatar` Türkçe baş harf ("İI"), form eşleşmeyen sunucu hatası şeridi, yıkıcı onay
  kırmızı, 2.0 ölçekte taşma yok (`NzPagedList` compact 2.0 hücresinde içerik görünüm alanında
  kesilir — kaydırılabilir liste, beklenen).
- İmza doğrulaması: W35, W31'in `NzButton`'ını paralel sabit imzayla kullandı; W31 birleşince uyarlama
  gerektirmeden geçti.
- Son denetim: ayrı denetçi koşulmadı; denetim koordinatör (Opus). Nihai Codex kapısı O5'te (değişmedi).
- Sapmalar (kabul edilen):
  - W36: `gateRedirect` scoped'da kapı dışı her yolu (kabuk, feature, bilinmeyen → 404) açar; scoped
    dışında yalnız faz hedefi. `test/app/app_phase_test.dart` import satırı (sahiplik dışı, zorunlu).
    Kabuk 3 yer tutucu sekme (home/work/profile); kayıtlı feature rotası yok.
  - W32: `nz_field_errors.dart` üç yapı (`NzFieldErrors`, `NzFormScope`, `NzServerFieldError`);
    eşleşmeyen alan hatası şeridi bir kare gecikmeli; "çok kısa" metni sayı içermez (yer tutucu yasağı).
  - W35: `overlays.tr.json` yok (yalnız `ui.common.*`); macOS'ta AlertDialog `namesRoute` koymadığı için
    anlamsal test başlık etiketiyle.
  - W33/W35: grup metni yok, metni çağıran verir.
  - W31: "meşgul" `Semantics.value` ile (Flutter'da ayrı bayrak yok).
- Sıkılaştırılan kurallar: yukarıdaki listede (O4).
- Kırmızılar: yok.
- Devir (O5'e):
  - Boundaries kural önerisi (W36, uygulanmadı): `lib/features/**` ve `lib/app/**` içinde dize yolla
    `go/push/replace`, `extra:` ve `GoRouterState.extra` okuması yasak (katalog sabiti hariç) — A7 pilotunda
    ADR ile karar.
  - Feature rota kaydı `registeredFeatureRoutes` boş; A7 pilot feature'ı ilk kaydı yapar.
  - Kataloğa dev uygulamada giriş noktası yok (rota hazır).
  - O1–O3'ten süren açıklar (README komut tablosu, `main` dal koruması, yerel ana ağaç `2524a14`,
    yönetim deposu push'u, token bekleyenler, `localeProvider` bağlanmadı) değişmedi.
  - Uzak/yerel `mob-ui/w31–w36` dalları silinmedi; worktree'ler kaldırıldı.

### O5 — 2026-10-15 — TAMAM
- O5 öncesi: mobil `main` `65c52d8` (O4 kaydı, CI 38657033553 success).
- PR'lar (squash; uygulayıcılar Sonnet 5.5, koordinatör Opus 5.5):
  - #45 ADR-0003 kararlar 20–22 (son seçili kapsam: SecureStore + oturumla silinir, pilotta bellekte; gezinme kuralı N1; pilot yerleşimi) → `5aa57bd` (main CI 38704960182 success)
  - #46 W42 N1 gezinme kuralı (tip çözümlemeli; bugünkü ihlal 0; mutasyonda 16 test kırmızı) → `f3ed0d5` (main CI 38710009027 success)
  - #47 W41 A7 pilot dikey dilim (server/identity/scope; `changePassword`) + 401 yenileme düzeltmesi → `3e39551` (main CI 38715198850 success, entegrasyon dahil)
  - Codex düzeltmeleri: #48 W52 (Codex 3, 11a) → `8e69bfb` (main CI 38721319776 success) · #49 W51 (Codex 1, 2, 4, 5 + koordinatör eki) → `5d493b2` (main CI 38724641694 success) · #50 W53 (Codex 6–9 + ADR karar 23) → `60dde43` (main CI 38728484617 success: verify, golden, Android, entegrasyon)
- main HEAD (uygulama): `60dde43`.
- Kapsama (`60dde43`): core %95,47 (990/1037) · application %100 (127/127) · data %100 (31/31) ·
  presentation %98,95 (284/287) · widgets %99,54 (1071/1076). Testler 993 (golden hariç) + 27 golden.
- Pilot zincir (A7): bağ → giriş → zorunlu parola değişikliği → program seçimi → ana kabuk (S2
  `GET /v1/program` ile kapsam başlığı kanıtı) → çıkış. Uçtan uca kanıt:
  - Kilitli yerel entegrasyon `program/araclar/verify-sirasi.sh … integration` (main `3e39551`):
    **9/9 geçti** (pilot akışı + mevcut 8), compose projesi adıyla kaldırıldı.
  - Her PR'da CI entegrasyon işi yeşil. İlk koşumda pilot testi sözleşme dışı `year` iddiası
    yüzünden düştü; test yalnız sözleşmenin garanti ettiği alanlara indirildi.
  - Zorunlu parola değişikliği yolu tohumda yok; birim/widget/pilot akış testleriyle kanıtlandı.
- Koordinatör denetim bulguları (O5):
  - **Önemli — 401 yenileme:** `AuthInterceptor` her 401'de yenileme + tekrar yapıyordu (yanlış mevcut
    parolayla parola değişikliği iki kez gidiyordu) → W41 düzeltti; Codex 1 ile kapsam
    `platform.unauthenticated`'a daraltıldı.
  - **Kritik — çıkış sonrası depoya yazma:** Codex 2 düzeltmesinin ilk hâlinde süren bayrak yazımı
    çıkış silmesinden sonra eski çifti depoya yazabiliyordu → kırmızı testle gösterildi, silme yazım
    kuyruğuna alındı (#49 `bd9377c`).
- **Codex nihai denetimi** (tek koşum, salt okunur, `2524a14..3e39551`): hüküm **UYGUN DEĞİL**
  (9 Önemli, 2 Küçük) → 9 Önemli kapatıldı, 2 Küçük kısmen/devredildi; kanıt tablosu
  `docs/reviews/MOB-UI-0-codex.md` "Düzeltme kanıtları". Codex ikinci kez koşulmadı.
- Sapmalar (kabul edilen):
  - Program listesi `truncated` başlıktan okunamıyor (üretilmiş istemci başlık vermiyor); ≥200 satır
    kesilmiş sayılır (Codex 10 → A8).
  - Çıkışta bellekteki çift, silme kuyruğu boşalana kadar durur; nesil anında artar, sunucu çıkışı önce
    yapılır (risk düşük). `restore()`/`establish()` kuyruk dışında.
  - `checkUiResolved` sözdizimsel U denetimiyle aynı yeri iki kez raporlayabilir; `check_boundaries`
    tekilleştirir.
- Sıkılaştırılan kurallar: ADR-0003 karar 21 (N1, core dahil) ve 23 (B9, S1/S4 export, D2 literal, S2/A5
  tip yolları, tip çözümlemeli U1–U6, G3 kalıtım, Q2 application controller, Q3 AST) — artık araçta.
- Kırmızılar: yok.

## MOB-UI-0 KAPANDI — 2026-10-15

- Uygulama `main` `60dde43`; yol haritası durumu "Uygulandı"; ADR-0003 son hâli (kararlar 1–23).
- Çıkış ölçütü: pilot zincir uçtan uca çalışır (entegrasyon 9/9); Codex hükmünün Önemli bulguları
  kapatıldı; bütün kapılar yeşil.
- **A8 ("tasarım gelince") için açık kalanlar:**
  - `TOKEN-BEKLİYOR`: **2** işaret (`grep -r` ile ölçüldü) — `lib/core/ui/theme/app_theme.dart`
    (`_Pending`: gölge, süre, opaklık, ikon boyutu, kenarlık) ve `lib/core/ui/layout/nz_layout.dart`
    (içerik genişliği). Opaklık/süre sabitlerinin tek noktada toplanması (Codex 11) bu işe bağlı.
  - `X-Result-Truncated` başlığının okunması (Codex 10; üretici yanıt başlıklarını açmalı).
  - Son seçili kapsamın kalıcılığı (ADR-0003 karar 20: SecureStore, oturumla silinir).
  - `localeProvider` uygulamaya bağlanmadı (yalnız `tr`).
  - Dev uygulamada kataloğa giriş noktası yok; kabuk sekmeleri (work) yer tutucu.
  - README komut tablosu (coverage/test-presence/golden), `main` dal koruması, yerel ana çalışma ağacı
    `2524a14` + untracked eski kopyalar, uzak/yerel `mob-ui/*` dalları silinmedi.
  - **O6 sonrası durum:** `X-Result-Truncated`, son seçili kapsam, `localeProvider`, katalog girişi, README
    komut tablosu ve yerel ana ağaç kapandı (aşağıda O6). Hâlâ açık olanlar: `TOKEN-BEKLİYOR` (2), kabuk
    sekmeleri, `main` dal koruması, uzak `mob-ui/*` dalları.

## O6 — 2026-10-15 — A8 devri (tasarımdan bağımsız kalemler) — TAMAM

- Açılış: O5 kapanışı (#51, `617b033`), main CI 38732456582 **success**, açık PR yok, O5 worktree'leri
  kaldırılmış. Koordinatör `main` üzerinde beş kapıyı yeniden koştu ve hepsi yeşil: 993 test; kapsama O5 kaydıyla
  birebir (core %95,47 · application %100 · data %100 · presentation %98,95 · widgets %99,54).
- Yerel ana çalışma ağacı `2524a14`'ten `origin/main`'e ileri sarıldı. İzlenmeyen eski kopyalar
  (`yol-haritasi-ui-temeli.md`, `docs/yurutme/`) #22 öncesi taslaklardı (main sürümleri daha yeni). Silinmedi,
  oturum dışına taşındı.
- PR'lar (squash; uygulayıcılar Sonnet 5.5, koordinatör Opus 5.5; her PR'da CI 4/4 yeşil, entegrasyon dahil):
  - **#52 W61 (Codex 10)** → `9e66867` (main CI 38747124538 success): `X-Result-Truncated` başlıktan okunur.
    - Üretim sonrası dönüşüm (`tool/gen/response_headers.dart`) yalnız 2xx'te başlık bildiren 6 operasyonu
      `HttpResponse<T>` ile sarar.
    - Liste openapi'den türetilir ve testle kilitlidir. Başlıksız operasyonların imzası değişmedi.
    - "≥ 200 satır" sezgisi kaldırıldı.
    - Tur 2: pilot test desteği başlığı taşır; başlıksız 200 satırda bildirim yok testi eklendi.
  - **#53 W62 (ADR-0003 karar 20)** → `0621d99`: son seçili kapsam `ScopeStore`'da (SecureStore, hesap +
    kurulum).
    - İki commit düzeni: önce mevcut kodda yeşil ömür testleri, sonra uygulama.
    - Koordinatör mutasyonları:
      - `clear()` silmesi kaldırılınca 9 test kırmızı.
      - `restore` sahip eşleşmesi kaldırılınca 2 test kırmızı.
  - **#54 W63** → `0511958`: `MaterialApp.locale` ← `localeProvider`. Dev flavor'da her fazda katalog giriş
    düğmesi var, prod ağacında yok. Dize gezinmesi N1 gereği `lib/app/router/shell.dart` içinde.
- Koordinatör denetim notları:
  - W61 raporunda presentation/widgets kapsaması 5'er satır düşük göründü. lcov farkı yalnız `const` yapıcı
    satırlarında çıktı (koşudan koşuya değişen ölçüm; W61 o dosyalara dokunmadı). Eşikler çok üstünde.
  - W63 katalog düğmesi sağ üst köşede. Bugün hiçbir sayfa AppBar `actions` kullanmıyor; kullanılırsa
    konum yeniden değerlendirilir.
  - Test çıktısında google_fonts "binding not initialized" uyarı gürültüsü var; testi düşürmüyor
    (küçük, ayrı iş).
  - `scope_controller.dart` ↔ `scope_store.dart` karşılıklı import yapıyor (geçerli; sınır kuralı geçti).
- Sıkılaştırılan kurallar: yok.
- Kırmızılar:
  - `main` dal koruması kapalı (GitHub ayarı). Hesap ayarı değişikliği olduğu için ürün sahibine bırakıldı.
  - Uzak `mob-ui/*` dalları silinmedi (yalnız birleşmiş O6 yerel dalları ve worktree'leri temizlendi).
- A8'de kalan (tasarıma bağlı): `TOKEN-BEKLİYOR` 2 işaret (gölge/süre/opaklık/ikon/kenarlık, içerik
  genişliği; Codex 11 opaklık/süre toplaması buna bağlı), kabuk sekmeleri (work) yer tutucu.
