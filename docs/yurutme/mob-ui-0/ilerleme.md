# MOB-UI-0 ilerleme

Koordinatör her oturum kapanışında bir kayıt ekler (biçim: `koordinator.md`). Bir sonraki
oturum buradan başlar. Uygulayıcılar bu dosyaya yazmaz.

## Durum

| Oturum | Durum | main hash |
|---|---|---|
| O1 — A0 | TAMAM (son denetim Opus; nihai Codex kapısı O5'te) | `4737566` + kapanış PR'ı #27 |
| O2 — Temel | TAMAM | `b483efe` + kapanış PR'ı |
| O3 — Kabuk | Bekliyor | — |
| O4 — Kit + Router | Bekliyor | — |
| O5 — Pilot + Kapanış | Bekliyor | — |

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
