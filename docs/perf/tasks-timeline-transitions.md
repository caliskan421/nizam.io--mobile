# Görevler ↔ Zaman çizelgesi geçiş ölçümü

Komutlar ve düzenek: [`README.md`](README.md). Fikstür: 160 görev, 6 departman, sunucu sözleşmesi biçiminde
(`v0.7.0-api`), tarihler bugüne göre ±60 gün; örnek mod yok.

## Yöntem

- Gerçek `NizamioApp` + gerçek bileşim kökü + `Flavor.dev` + sahte HTTP; gerçek giriş akışı, sunucu programı seçili.
- Her senaryoda 1 ısınma turu (sayılmaz) + 3 ölçülü tekrar; tekrarlar arası başlangıç durumuna dönülür.
- Ölçüm penceresi: geçişi tetikleyen dokunuştan sonra sabit 1,8 sn (`pumpAndSettle` yok); ham `FrameTiming`
  `SchedulerBinding.addTimingsCallback` ile. Anlamsal ağaç pencerede kapalı, dokunuş işaretçi izi katmanı olmadan gönderilir.
- Yüzdelikler 3 tekrarın birleşik karelerinden (en yakın sıra). UI = `buildDuration` (build+layout+paint+semantics tek
  UI kare süresi), raster = `rasterDuration`. "İlk kare" = dokunuştan sonraki ilk karenin UI+raster toplamı (tekrar medyanı;
  üçünün tek tek değeri ayrıca JSON'da).
- Pencerede kare sayısı geçiş süresini değil animasyon karelerini sayar; çoğu kare ucuzdur (UI p50 ≈ 0,1 ms), bu yüzden
  p50/p90/p99 tek başına ağır kareyi göstermez: **>16,7 ms kare sayısı, en uzun kare ve ilk kare** asıl göstergelerdir.
- Hedef: p90 UI ve raster < 16,7 ms; ilk kare < 32 ms.

## Cihaz / mod

| Senaryo | Ölçülen yer | Mod | Not |
|---|---|---|---|
| S1, S2 (tablet) | macOS masaüstü, pencere 1376×1032 mantıksal (dpr 2), vekil | profile | gerçek iPad yok; M-serisi Mac iPad'den hızlıdır, mutlak değil |
| S3, S4 (telefon) | iPhone 17 Pro Max simülatörü 440×956 (dpr 3) | **debug+simülatör** | gerçek iPhone (kablosuz) 590 sn'de bağlanmadı; yalnız önce/sonra kıyası için |
| iPad simülatörü (S1, S2) | yapılamadı | debug | 590 sn'de çıktı üretmedi (uygulama sürücüye bağlanmadı); macOS vekiliyle yetinildi |

## Taban (taban: örnek mod kaldırıldıktan sonraki Görevler/Zaman çizelgesi, 160 görev)

Süreler ms. UI/raster p50 / p90 / p99. "Uzun" = en uzun kare (UI; raster ayrıca parantezde).

| Senaryo | Kare | UI p50/p90/p99 | Raster p50/p90/p99 | >16,7 ms UI / raster | En uzun UI (raster) | İlk kare (UI+raster) |
|---|---|---|---|---|---|---|
| S1 tablet Liste→Zaman çizelgesi (macOS, profile) | 628 | 0,11 / 0,15 / 0,42 | 1,46 / 1,60 / 1,94 | 3 / 0 | 52,85 (4,16) | 53,1 (tekrarlar 50,8 / 54,1 / 53,1) |
| S2 tablet Zaman çizelgesi→Liste (macOS, profile) | 648 | 0,13 / 0,29 / 0,53 | 1,01 / 1,26 / 3,23 | 0 / 0 | 4,10 (4,15) | 4,8 (tekrarlar 4,8 / 5,0 / 4,2) |
| S3 telefon Liste→Zaman çizelgesi (sim, debug) | 300 | 0,27 / 2,94 / 37,25 | 2,83 / 3,88 / 5,68 | 6 / 0 | 69,30 (6,55) | 47,5 (tekrarlar 74,7 / 47,5 / 36,5) |
| S4 telefon ayrıntı sekmesi Özet→Alt görev (sim, debug) | 318 | 0,28 / 2,18 / 5,11 | 3,19 / 4,08 / 6,59 | 1 / 0 | 17,79 (9,52) | 18,1 (tekrarlar 12,5 / 18,1 / 23,7) |

Sonraki paketler bu tabloya "Taban"ın yanına sütun ekler (aynı satır sırası, aynı komut).

## Bulgu

- S1: p90 hedefi tutuyor ama ilk kare 51–54 ms (hedef 32): maliyet tek UI karesinde (build/layout), raster ≤ 4 ms.
  Gantt gövdesi geçişin ilk karesinde kuruluyor (macOS profile'da bile hedefin üstünde; iPad'de daha kötü beklenir).
- S2 (geri dönüş) hedefte: en uzun kare 4,1 ms.
- S3 (debug simülatör): geçişin ilk 2–3 karesi 37–115 ms UI; raster hiçbir senaryoda 16,7 ms'i geçmedi, darboğaz UI.
- Gantt bağımlılık bağları liste ucundan gelmez (arayüz Gantt ucunu kullanmıyor); fikstürde bağ yok, durum/öncelik/gecikme çeşitli.

## Kırmızılar

- Gerçek iPhone (kablosuz) ve iPad bu turda ölçülemedi; S3/S4 debug+simülatör, S1/S2 macOS vekili. Profile + gerçek cihaz turu açık.
- macOS'ta `enterText` alana işlemediği için giriş alanları denetleyiciye doğrudan yazılarak doldurulur (yalnız kurulum).
