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
- Kırpma: dokunuştan önceki 300 ms'lik boşta örnekten eşik çıkarılır (UI ve raster ayrı, p90 x 1,5 + 0,2 ms) ve pencerenin sonundaki
  eşik altı kare serisi atılır; sınırı: kalan küme kısa kalabilir (S3 P2d'de 3 tekrar toplam 13 kare) ve etkin kare sayısı
  koşumdan koşuma değişir, bu yüzden p90 bu durumda anlamsızdır. Kırpmasız sabit pencere sonuçları JSON'da `untrimmed`
  alanındadır (P2d koşumlarının ikincisinden itibaren); birincil sütunlar kırpılmış kümedir, kıyas bozulmadı. Kırpma sonrası
  küme boşsa test artık başarısız olur.
- Hedef: p90 UI ve raster < 16,7 ms; ilk kare < 32 ms.
- Her noktada ölçüm düzeneği (P0 commit'i) o noktanın koduna bindirildi; uygulama kodu değiştirilmedi.

## Cihaz / mod

| Senaryo | Ölçülen yer | Mod | Not |
|---|---|---|---|
| S1, S2 (tablet) | macOS masaüstü, pencere 1376×1032 mantıksal (dpr 2), vekil | profile | gerçek iPad yok; M-serisi Mac iPad'den hızlıdır, mutlak değil |
| S3, S4 (telefon) | iPhone 17 Pro Max simülatörü 440×956 (dpr 3) | **debug+simülatör** | yalnız önce/sonra kıyası; debug JIT'li, ilk kare mutlak değil |
| Gerçek iPhone (S3, S4) | yapılamadı | profile | önceki turda derleme imzalama hatasıyla durdu; bu turda yeniden denenmedi |
| iPad simülatörü | denenmedi | — | önceki turda çıktı üretmemişti |

## Önce / sonra

Hücre: `p90 UI / p90 raster / >16,7 ms UI kare / ilk kare` (ms). Taban = örnek mod kaldırıldıktan sonraki dal tabanı
(`Merge arayuz/gorevler-ve-bilesenler: tablet çizelgesi yeniden tasarımı…`). "—" = bu noktada o senaryo ölçülmedi.
S1 Taban ve P2b ikişer koşumdur; tabloda ilk koşum, ikincisi aşağıda. Önceki turdaki Taban sütunu eski kodda
(örnek mod varken) ölçüldüğünden geçersizdi; bu tablo yerine geçer.

| Senaryo | Taban | P1b | P1c | P1a | P1d | P2e | P2a | P2b | P2d (son) |
|---|---|---|---|---|---|---|---|---|---|
| S1 tablet Liste→Zaman çizelgesi | 0.4 / 5.0 / 3 / 73.2 | 0.4 / 5.2 / 3 / 73.7 | 0.4 / 5.5 / 3 / 58.9 | 83.3† / 3.8 / 3 / 82.5 | 0.4 / 5.5 / 3 / 90.3 | — | 0.6 / 5.7 / 3 / 36.8 | 0.6 / 5.9 / 3 / 36.0 | 0.43 / 2.6 / 1 / 9.4 |
| S2 tablet Zaman çizelgesi→Liste | 0.7 / 5.0 / 0 / 10.4 | 0.7 / 5.2 / 2 / 27.0 | 0.6 / 6.0 / 2 / 27.8 | 0.6 / 5.5 / 2 / 24.9 | 0.6 / 5.3 / 1 / 17.6 | — | 0.7 / 5.4 / 2 / 21.4 | 0.7 / 5.3 / 1 / 18.4 | 0.41 / 1.4 / 0 / 3.9 |
| S3 telefon Liste→Zaman çizelgesi | 4.1 / 3.5 / 6 / 78.1 | — | 1.7 / 4.5 / 6 / 85.5 | 1.2 / 4.2 / 6 / 71.3 | 1.4 / 4.3 / 6 / 67.9 | 38.7† / 3.6 / 6 / 43.1 | — | 1.2 / 3.7 / 6 / 48.5 | 49.4† / 4.6 / 6 / 37.0 |
| S4 telefon Özet→Alt görev | 2.2 / 4.8 / 2 / 27.2 | — | 25.0† / 5.6 / 3 / 23.9 | 1.9 / 4.2 / 1 / 20.6 | 10.0† / 4.5 / 1 / 16.9 | 19.7† / 6.0 / 3 / 24.5 | — | 1.5 / 4.4 / 1 / 19.6 | 1.76 / 4.4 / 2 / 21.0 |

İki koşum (tekrar başına ilk kare, ms): S1 Taban 90,1 / 73,2 / 58,5 ve 71,9 / 78,5 / 57,6 (medyan 72,6; koşum farkı <%2);
S1 P2b 36,1 / 41,8 / 31,4 ve 41,4 / 47,8 / 41,4 (medyan 41,4; ilk koşum 36,0, ikinci 41,4: fark %15, <%20 → üçüncü koşum gerekmedi).
P2d (son), S1 ve S2 üçer koşum (ilk iki koşumun ilk kare medyanı farkı >%20 → üçüncü koşum): S1 11,9 / 6,5 / 9,4 (medyan 9,4), S2 3,9 / 3,1 / 5,0 (medyan 3,9).
Hücredeki p90 ve >16,7 değerleri de koşum medyanıdır (S1 >16,7 UI: 2 / 0 / 1; S2: 0 / 0 / 0). S3, S4 tek koşum (3 tekrar): ilk kare 36,5 / 37,0 / 54,0 ve 16,8 / 21,0 / 27,9.
S3 P2d kırpılmış küme yalnız 13 kare (†); kırpmasız pencerede (302 kare) p90 UI 1,14, p90 raster 4,36, >16,7 UI 6. S4 kırpmasız: 153 → 318 kare, p90 UI 1,53.
S2 (gürültü payı için ek koşum): Taban 7,5 / 14,9 / 10,4 ve 13,0 / 23,4 / 27,7 (medyan 13,9); P2b 28,8 / 15,0 / 18,4 ve 32,4 / 19,1 / 25,0 (medyan 22,1).

P2d, açılışın iki karesi (S1, 9 tekrar = 3 koşum x 3): ilk kare (iskelet) UI+raster medyan 7,8 ms (5,9–13,4); ikinci kare (Gantt gövdesi) UI+raster medyan 19,0 ms,
yalnız UI 12,4 ms (9,4–31,3; 9 tekrarın 3'ünde >16,7: 17,6 / 29,5 / 31,3). Dolu çizelgeye ulaşma = ilk iki karenin UI+raster toplamı (zaman damgası farkı değil, vsync boşluğu hariç):
medyan 24,9 ms (20,2–48,7). En ağır kare: S1 UI 31,3 ms (ikinci kare), raster 53,0 ms (tek kare, bir tekrarda); tekrar başına en ağır raster kare medyanı 19,7. S2 ikinci kare UI 0,65 (toplam 6,0), dolu görünüme 9,7 ms.
S3 ilk iki kare debug simülatörde UI 32–49 ve 46–53 ms (kırpılmış kümede 2 + 2 + 9 kare).

Taban ve son nokta (P2d; S1/S2'de ilk kare medyanı koşumu), ayrıntı:

| Senaryo | Nokta | kare | UI p50/p90/p99 | raster p50/p90/p99 | >16,7 raster | en uzun UI |
|---|---|---|---|---|---|---|
| S1 | Taban | 539 | 0.19 / 0.40 / 7.23 | 2.80 / 5.00 / 7.95 | 0 | 89.5 |
| S1 | P2d | 597 | 0.14 / 0.42 / 7.15 | 1.71 / 2.30 / 5.37 | 1 | 29.5 |
| S2 | Taban | 509 | 0.22 / 0.65 / 3.93 | 1.97 / 5.03 / 7.16 | 0 | 13.8 |
| S2 | P2d | 332 | 0.15 / 0.41 / 2.31 | 1.14 / 1.44 / 4.38 | 0 | 3.4 |
| S3 | Taban | 98 | 1.06 / 4.13 / 82.61 | 2.44 / 3.51 / 13.01 | 0 | 82.6 |
| S3 | P2d | 13† | 3.86 / 49.42 / 52.79 | 3.13 / 4.59 / 5.07 | 0 | 52.8 |
| S4 | Taban | 125 | 1.21 / 2.21 / 22.52 | 3.21 / 4.76 / 6.60 | 0 | 24.2 |
| S4 | P2d | 153 | 1.19 / 1.76 / 16.92 | 3.14 / 4.35 / 5.32 | 0 | 24.5 |

## Bulgu

- Hedef (p90 UI ve raster < 16,7 ms, ilk kare < 32 ms), P2d son noktada: S1 karşılandı (p90 UI 0,43, raster 2,6, ilk kare medyan 9,4; koşumlar 6,5–11,9); S2 karşılandı (0,41 / 1,4 / 3,9); S4 karşılandı (1,76 / 4,4 / 21,0); S3 debug simülatörde yalnız ilk kare karşılanmadı (37,0 > 32); p90 UI kırpılmış 13 karede anlamsız, kırpmasızda 1,14 ve raster 4,6 hedefte.
- P2d'nin etkisi (S1): ilk kare 72,6 (Taban) / 41,4 (P2b) → 9,4 ms; ilk kare artık iskelet (UI+raster 5,9–13,4). Önceki kazancın büyük kısmı P2a'dandı; P2d ilk kareyi iskelete indirdi, en ağır UI kare ikinci kareye kaydı (31,3 ms).
- ">16,7 ms UI" sayısı düşmedi (S1: Taban 3 / P2b 3 → P2d 2 / 0 / 1 koşum başına, medyan 1): Gantt gövdesi ikinci karede kurulur, ikinci karenin UI süresi medyan 12,4 ms ve 9 tekrarın 3'ünde 17,6–31,3 ms. Maliyet bölündü ama silinmedi; dolu çizelgeye ulaşma (ilk iki kare toplamı) medyan 24,9 ms (20,2–48,7), P2b'nin tek karesi 36–41 ms'ydi.
- İlk kare ölçütü tek başına yanıltıcı: iskelet 9 ms görünür, kullanıcının gördüğü dolu çizelge medyan 25 ms (en kötü 49) sonra gelir; medyan 32 ms altında, kötü tekrarlar üstünde.
- Raster: p90 hiçbir senaryoda 4,6 ms'yi aşmadı; S1'de tek karede 24–53 ms raster görüldü (koşum başına en çok 1).
- S2: ilk kare Taban 13,9 / P2b 22,1 → 3,9 ms (koşumlar 3,1–5,0), >16,7 UI 0; hedefte ve Taban'dan iyi.
- S3 (debug sim): ilk kare Taban 78,1 / P2b 48,5 → 37,0 (36,5 / 37,0 / 54,0); iki ağır kare (UI 32–49 ve 46–53 ms) debug JIT'e bağlı olabilir. S4: 27,2 / 19,6 → 21,0 ms, gürültü bandında (16,8–27,9).
- P2d, Offstage ile rotayı canlı tutma olarak değil, "Gantt gövdesi açılışın ikinci karesinde kuruluyor (ilk kare iskelet)" olarak uygulandı; Offstage seçeneği router yapısını değiştirdiği için uygulanmadı.

## Kırmızılar

- Gerçek iPhone (`00008110-000C5D6426C0A01E`, kablosuz): ölçülemedi; önceki turda tek deneme `flutter drive --profile` derleme aşamasında imzalama hatasıyla durdu (`Could not find the built application bundle at build/ios/iphoneos/Runner.app`; Xcode imza ayarı gerekli); 3 girişimden sonra test başlamadı; bu turda yeniden denenmedi. S3/S4 mutlak değerleri yalnız debug simülatör.
- iPad (gerçek ve simülatör) ölçülmedi; tablet sayıları macOS profile vekili (M-serisi Mac), mutlak değil.
- S3 ve S4 debug simülatör (JIT); S3 P2d kırpılmış kümesi 13 kare, p90 kıyas dışı.
- FrameTiming build/layout/paint ayrımı vermez; S1'in en pahalı karesinin aşaması `traceAction` zaman çizelgesi eklenmediği için yazılamadı.
- Düzenek düzeltmesi (bu turda, ölçüm testinde): P0 fikstürü `created_at`, `created_by_account_id`, `created_by_full_name` alanlarını içermiyordu (`WorkItem` ayrıştırılamıyor, "Bir sorun oluştu"); anahtar yalnız simge olduğundan Liste/Zaman çizelgesi anahtarı metinle değil anlamsal etiketle bulunur; telefonda çizelge tam ekran açıldığı için listeye dönüş sistem geri hareketiyle yapılır; anlamsal ağaç yeniden açıldıktan sonra kare beklenir.
- macOS'ta `enterText` alana işlemediği için giriş alanları denetleyiciye doğrudan yazılarak doldurulur (yalnız kurulum).
