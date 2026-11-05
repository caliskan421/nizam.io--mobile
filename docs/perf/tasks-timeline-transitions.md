# Görevler ↔ Zaman çizelgesi geçiş ölçümü

Komutlar ve düzenek: [`README.md`](README.md). Fikstür: 160 görev, 6 departman, sunucu sözleşmesi biçiminde
(`v0.7.0-api`), tarihler bugüne göre ±60 gün; örnek mod yok.

## Yöntem

- Gerçek `NizamioApp` + gerçek bileşim kökü + `Flavor.dev` + sahte HTTP; gerçek giriş akışı, sunucu programı seçili.
- Her senaryoda 1 ısınma turu (sayılmaz) + 3 ölçülü tekrar; tekrarlar arası başlangıç durumuna dönülür.
- Ölçüm penceresi: geçişi tetikleyen dokunuştan sonra sabit 1,8 sn (`pumpAndSettle` yok); ham `FrameTiming`
  `SchedulerBinding.addTimingsCallback` ile. Anlamsal ağaç pencerede kapalı, dokunuş işaretçi izi katmanı olmadan gönderilir.
- UI = `buildDuration` (build+layout+paint+semantics tek UI kare süresi; aşamalara ayrılmaz), raster = `rasterDuration`.
  "İlk kare" = dokunuştan sonraki ilk karenin UI+raster toplamı (3 tekrarın medyanı).
- Pencerenin sonundaki boşta kareler atılır; kalan kare sayısı koşumdan koşuma değişir (S1 Taban 122–539, P1a 3). Bu yüzden
  **p90 yalnız kare sayısı yüksekken (≥50) karşılaştırılır** (†: <50 kare, p90 tek ağır kareden ibaret, kıyas dışı).
  Asıl göstergeler: **>16,7 ms UI kare sayısı** (3 tekrar toplamı; S1'de 3 = tekrar başına bir) ve **ilk kare**.
- Hedef: p90 UI ve raster < 16,7 ms; ilk kare < 32 ms.
- Her noktada ölçüm düzeneği (P0 commit'i) o noktanın koduna bindirildi; uygulama kodu değiştirilmedi.

## Cihaz / mod

| Senaryo | Ölçülen yer | Mod | Not |
|---|---|---|---|
| S1, S2 (tablet) | macOS masaüstü, pencere 1376×1032 mantıksal (dpr 2), vekil | profile | gerçek iPad yok; M-serisi Mac iPad'den hızlıdır, mutlak değil |
| S3, S4 (telefon) | iPhone 17 Pro Max simülatörü 440×956 (dpr 3) | **debug+simülatör** | yalnız önce/sonra kıyası; debug JIT'li, ilk kare mutlak değil |
| Gerçek iPhone (S3, S4) | yapılamadı | profile | Taban'da denenmedi; son noktada derleme imzalama hatasıyla durdu (aşağıda) |
| iPad simülatörü | denenmedi | — | önceki turda çıktı üretmemişti |

## Önce / sonra

Hücre: `p90 UI / p90 raster / >16,7 ms UI kare / ilk kare` (ms). Taban = örnek mod kaldırıldıktan sonraki dal tabanı
(`Merge arayuz/gorevler-ve-bilesenler: tablet çizelgesi yeniden tasarımı…`). "—" = bu noktada o senaryo ölçülmedi.
S1 Taban ve P2b ikişer koşumdur; tabloda ilk koşum, ikincisi aşağıda. Önceki turdaki Taban sütunu eski kodda
(örnek mod varken) ölçüldüğünden geçersizdi; bu tablo yerine geçer.

| Senaryo | Taban | P1b | P1c | P1a | P1d | P2e | P2a | P2b |
|---|---|---|---|---|---|---|---|---|
| S1 tablet Liste→Zaman çizelgesi | 0.4 / 5.0 / 3 / 73.2 | 0.4 / 5.2 / 3 / 73.7 | 0.4 / 5.5 / 3 / 58.9 | 83.3† / 3.8 / 3 / 82.5 | 0.4 / 5.5 / 3 / 90.3 | — | 0.6 / 5.7 / 3 / 36.8 | 0.6 / 5.9 / 3 / 36.0 |
| S2 tablet Zaman çizelgesi→Liste | 0.7 / 5.0 / 0 / 10.4 | 0.7 / 5.2 / 2 / 27.0 | 0.6 / 6.0 / 2 / 27.8 | 0.6 / 5.5 / 2 / 24.9 | 0.6 / 5.3 / 1 / 17.6 | — | 0.7 / 5.4 / 2 / 21.4 | 0.7 / 5.3 / 1 / 18.4 |
| S3 telefon Liste→Zaman çizelgesi | 4.1 / 3.5 / 6 / 78.1 | — | 1.7 / 4.5 / 6 / 85.5 | 1.2 / 4.2 / 6 / 71.3 | 1.4 / 4.3 / 6 / 67.9 | 38.7† / 3.6 / 6 / 43.1 | — | 1.2 / 3.7 / 6 / 48.5 |
| S4 telefon Özet→Alt görev | 2.2 / 4.8 / 2 / 27.2 | — | 25.0† / 5.6 / 3 / 23.9 | 1.9 / 4.2 / 1 / 20.6 | 10.0† / 4.5 / 1 / 16.9 | 19.7† / 6.0 / 3 / 24.5 | — | 1.5 / 4.4 / 1 / 19.6 |

İki koşum (tekrar başına ilk kare, ms): S1 Taban 90,1 / 73,2 / 58,5 ve 71,9 / 78,5 / 57,6 (medyan 72,6; koşum farkı <%2);
S1 P2b 36,1 / 41,8 / 31,4 ve 41,4 / 47,8 / 41,4 (medyan 41,4; ilk koşum 36,0, ikinci 41,4: fark %15, <%20 → üçüncü koşum gerekmedi).
S2 (gürültü payı için ek koşum): Taban 7,5 / 14,9 / 10,4 ve 13,0 / 23,4 / 27,7 (medyan 13,9); P2b 28,8 / 15,0 / 18,4 ve 32,4 / 19,1 / 25,0 (medyan 22,1).

Taban ve son nokta (P2b), ayrıntı:

| Senaryo | Nokta | kare | UI p50/p90/p99 | raster p50/p90/p99 | >16,7 raster | en uzun UI |
|---|---|---|---|---|---|---|
| S1 | Taban | 539 | 0.19 / 0.40 / 7.23 | 2.80 / 5.00 / 7.95 | 0 | 89.5 |
| S1 | P2b | 316 | 0.27 / 0.56 / 8.25 | 2.66 / 5.88 / 12.19 | 3 | 36.1 |
| S2 | Taban | 509 | 0.22 / 0.65 / 3.93 | 1.97 / 5.03 / 7.16 | 0 | 13.8 |
| S2 | P2b | 588 | 0.22 / 0.73 / 3.05 | 2.14 / 5.35 / 8.55 | 0 | 26.3 |
| S3 | Taban | 98 | 1.06 / 4.13 / 82.61 | 2.44 / 3.51 / 13.01 | 0 | 82.6 |
| S3 | P2b | 134 | 0.48 / 1.18 / 48.66 | 2.76 / 3.74 / 4.98 | 0 | 48.7 |
| S4 | Taban | 125 | 1.21 / 2.21 / 22.52 | 3.21 / 4.76 / 6.60 | 0 | 24.2 |
| S4 | P2b | 97 | 1.18 / 1.51 / 21.10 | 3.31 / 4.42 / 5.95 | 0 | 21.1 |

## Bulgu

- S1 (tablet açılış): ilk kare 73 → 36–41 ms (medyan 72,6 → 41,4), tamamı P2a'dan (gantt gövdesi sanallaştırma): P1d 90 → P2a 37. P2b ek kazanç getirmedi (36,0 / 41,4; gürültü içinde). En uzun UI kare 90 → 36–44 ms; raster hep ≤ 6 ms p50'de, tek karede 10–19 ms.
- S1 hedefi (ilk kare < 32) karşılanmadı: medyan 41,4; tek tekrar 31,4 ms ile altında. Maliyet hâlâ tek UI karesinde (tekrar başına bir >16,7 ms kare; aşama ayrımı yok, bkz. Kırmızılar). Raster p90 hiçbir senaryo/noktada 16,7 ms'e yaklaşmadı (3,5–6,0 ms); tablette ara sıra tek raster karesi 10–36 ms (P2a S1: 36,4).
- P1b (gantt sol sütun camı), P1a (opaklık animasyonu) ve P1d (sekmeye dönüş tazelemesi) tabletin ilk karesini ölçülebilir azaltmadı (73,7 / 82,5 / 90,3; Taban koşumları 58–90 arası dalgalanıyor). P1c (giriş hareketi) 73 → 59 gösterdi ama koşum içi yayılım (58,9–65,9) ve Taban aralığı (58,5–90,1) ile örtüştüğünden kazanç sayılmaz.
- S2 (geri dönüş): hedefte (p90 UI 0,7, raster 5,3; ilk kare medyan 22 ms < 32) ama Taban'a göre iyileşme yok: Taban ilk karesi 13,9 → P2b 22,1 ms (aralıklar 7,5–27,7 ve 15,0–32,4 örtüşüyor; hafif kötüleşme eğilimi var, tek tekrar 32,4 ms ile eşiği aştı). >16,7 ms UI kare sayısı 0–2 → 1–3.
- S3 (telefon açılış, debug sim): ilk kare 78 → 48 ms. En büyük düşüş P2e'de (P1d 68 → P2e 43); P2b'de 48 (aynı gürültü bandında). Hedef (< 32) debug'da karşılanmadı; p90 UI 4,1 → 1,2 ms, raster < 4 ms. Sim debug koşumları ±15 ms oynuyor (P1c: 73–94).
- S4 (ayrıntı sekmesi): hedefte, ilk kare 27 → 20 ms (P1a'dan beri 17–21); p90 UI 2,2 → 1,5. İyileşme Taban koşumunun yayılımına (19,7–29,0) yakın; gürültü payı ≈ 5 ms.
- P2d kararı: S1 son noktada ilk kare 36–41 ms (≥ 32) ve tekrar başına bir >16,7 ms UI kare → ölçüt sağlanmadı, P2d GEREKLİ sayılır (rotayı Offstage ile canlı tutmak ilk karedeki kurulum maliyetini açılıştan çıkarır).

## Kırmızılar

- Gerçek iPhone (`00008110-000C5D6426C0A01E`, kablosuz): son noktada tek deneme `flutter drive --profile` derleme aşamasında imzalama hatasıyla durdu (`Could not find the built application bundle at build/ios/iphoneos/Runner.app`; Xcode imza ayarı gerekli); 3 girişimden sonra test başlamadı. Taban'da denenmedi. S3/S4 mutlak değerleri yalnız debug simülatör.
- iPad (gerçek ve simülatör) ölçülmedi; tablet sayıları macOS profile vekili, mutlak değil.
- FrameTiming build/layout/paint ayrımı vermez; S1'in en pahalı karesinin aşaması `traceAction` zaman çizelgesi eklenmediği için yazılamadı.
- Düzenek düzeltmesi (bu turda, ölçüm testinde): P0 fikstürü `created_at`, `created_by_account_id`, `created_by_full_name` alanlarını içermiyordu (`WorkItem` ayrıştırılamıyor, "Bir sorun oluştu"); anahtar yalnız simge olduğundan Liste/Zaman çizelgesi anahtarı metinle değil anlamsal etiketle bulunur; telefonda çizelge tam ekran açıldığı için listeye dönüş sistem geri hareketiyle yapılır; anlamsal ağaç yeniden açıldıktan sonra kare beklenir.
- macOS'ta `enterText` alana işlemediği için giriş alanları denetleyiciye doğrudan yazılarak doldurulur (yalnız kurulum).
