# F57 — Görevleri sunucuya bağlama: Codex nihai kapı ve Fable değerlendirmeleri

- Tarih: 2026-11-01 · Araç: `codex exec -m gpt-6.1-sol -s read-only` (codex-cli 0.165.0); değerlendirici Fable 5.1 (high), salt okunur.
- Kapsam: `24da5a1..82df2f3` (taban `cb9e6bd` = görev okuma bağlama işinin anlık görüntüsü; F57 P1a, P1a-d, P2, P3, D1, P1b, D2, D3, D4). Pin `v0.6.0-api`.
- Ölçütler: yönetim deposu `program/fazlar/F57-mobil-gorev-baglama.md`; akış sözleşmesi backend `docs/api/istemci-akislari.md` (`v0.6.0-api`).
- Ham çıktılar: yönetim deposu `program/kapanislar/F57-kanit/` (`codex-kapi-1…4*.md`, `fable-p2.md`, `fable-p3.md`, `uygulama.md`, test listeleri).

## Hüküm zinciri

| Tur | Aralık | Hüküm | Kapanan |
|---|---|---|---|
| Fable P1a | `24da5a1..008059f` | KOŞULLU | B1 ayrıntı kaybı, B3 ana sayfa yönetici uçları, B4 sessiz kesilme, B5 bayat departman, B7 gecikme (P1a-d); B2 tarih (P1b) |
| Fable P2 | `008059f..8bc4805` | KOŞULLU | K1 katalog hatasında yönetici uçlarına düşüş, K2, N2, N4, N8 (D1) |
| Fable P3 | `8bc4805..10e159d` | KOŞULLU | B1 üyede `listMembers`, B2 bağımlı tarih, B3 indirme belleği, B4 `.`/`..` (D2) |
| Codex 1 | `24da5a1..10e159d` | KOŞULLU | 6 orta: yetkisiz oluşturma girişi, düzenleme öncesi taze okuma, 403 sonrası rol, 401 sonrası FormData tekrarı, kapsamın kalemden sabitlenmesi, oluşturma 409/403 (D2) |
| Codex 2 | `10e159d..1649309` | KOŞULLU | indirme geçici dosya ad alanı, taşıma temizliği (D3) |
| Codex 3 | `1649309..492e93f` | KOŞULLU | kopyalama yedeği atomikliği, `.tmp` harf eşdeğerliği (D4) |
| **Codex 4** | `492e93f..82df2f3` | **UYGUN** | — |

## Doğrulama
`flutter analyze --fatal-infos` temiz; sınır denetimi temiz; tam `flutter test` +2072 −36 — 36 kırmızı faz öncesi tabandan (ad ad aynı; `tablet_measurements` 21, koordinatörlükler 13, örnek katalog sayısı 1, hızlı işlem 1), yeni kırmızı yok. `make gen-check`: taban router metin kayması dışında temiz. CI koşturulmadı (kota kuralı; yerel kanıt).

## Bilerek bırakılanlar
P4 ekranları (zaman çizelgesi rol Gantt, koordinatörlükler, arşiv; koordinatörlük "Görev ata" ve sohbet "Göreve dönüştür" yetkisizde sessiz; arşiv indirmesi belleğe alır), N3 bayat departman düzeltmesinde tek seferlik çift yükleme, taban 36 kırmızı test ve gen-check router kayması.
