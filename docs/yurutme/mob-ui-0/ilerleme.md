# MOB-UI-0 ilerleme

Koordinatör her oturum kapanışında bir kayıt ekler (biçim: `koordinator.md`). Bir sonraki
oturum buradan başlar. Uygulayıcılar bu dosyaya yazmaz.

## Durum

| Oturum | Durum | main hash |
|---|---|---|
| O1 — A0 | TAMAM (son denetim Opus; nihai Codex kapısı O5'te) | `4737566` + kapanış PR'ı #27 |
| O2 — Temel | Bekliyor | — |
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
