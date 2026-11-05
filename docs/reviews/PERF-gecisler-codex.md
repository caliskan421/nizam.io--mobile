# PERF geçişler — Codex hükmü

## Hüküm

**DÜZELTMEYLE GEÇER** — P2a’nın sanallaştırması ve P1c’nin render katmanına taşıdığı hareket mantığı yerinde. Ancak P2e’de sessiz ofset düzeltmesinden sonra okuyucu penceresi bayat kalabilir; P1d hareketin iptalini tamamlanma sayıyor; P2b’nin kapsam temizliği açık değil. P2d sonrasındaki performans da ölçülmemiş. İnceleme salt okunur yapıldı; dosya yazılmadı, ağa çıkılmadı, test/CI çalıştırılmadı. `git diff --check` temiz.

## Bulgular

| # | önem | eksen | dosya:satır | bulgu | öneri |
|---|---|---|---|---|---|
| 1 | orta | Teknik mantık | `lib/features/timeline/presentation/chart/timeline_chart.dart:410` | **P2e:** Yeni yerleşim kurulurken pencere eski ofsetten hesaplanıyor. İçerik/genişlik küçülünce ScrollPosition ofseti bildirim vermeden düzeltebilir; görünür çubukların okuyucu düğümleri sonraki kaydırmaya kadar eksik kalabilir. P2a bu durumu ayrıca ele alıyor. | Güncelleme sonrasında, yerleşim bitince `mounted` korumalı pencere eşitlemesi yap; içerik daralması senaryosunu doğrula. |
| 2 | orta | Teknik mantık / uyum | `lib/features/timeline/presentation/gantt/gantt_layout_provider.dart:14` | **P2b:** Tek girişli önbellek sınırsız büyümüyor; fakat program/oturum sınırında açıkça temizlenmiyor. Yalnız katalog `.value` izleniyor; kaynak önceki değeri yükleme/hata sırasında koruyabildiğinden eski yerleşim de tutulabiliyor. | Önbellek ömrünü kapsam/oturum nesline bağla; aynı kapsamda yenileme ile kapsam değişimini ayır. Program değişimi ve çıkış için davranış testi ekle. |
| 3 | orta | Teknik mantık | `lib/core/ui/motion/page_content_entrance.dart:132` | **P1d:** `_onMotionStatus`, `dismissed` durumunda da tazeleme çağırıyor. Beklenen üst hareket yeniden `forward(from: 0)` ile başlatılırsa önceki hareket tamamlanmadan `onRevisit` çalışabilir. | Tamamlanmayı `AnimationStatus.completed` ile sınırla; yeniden başlatma/iptal davranışını açıklaştır. |
| 4 | yüksek | Teknik mantık / ölçüm | `docs/perf/tasks-timeline-transitions.md:68` | **P2d:** Belge Offstage ile canlı tutmayı tarif ediyor; uygulama gövdeyi sonraki kareye erteliyor. Tablo P2b’de bitiyor. Boş ilk karenin ucuzlaması, Gantt’ın görünür hâle gelmesinin hızlandığını kanıtlamaz. | P2d’yi yeniden ölç; ikinci kareyi, en ağır kareyi ve dolu çizelgeye ulaşma süresini raporla. Belgeyi uygulamayla eşitle. |
| 5 | orta | Ölçüm | `integration_test/perf_transitions_test.dart:348` | **P0/P3:** Boşta örnekten türetilen eşikle sondan kare silmek, düşük maliyetli gerçek geçiş karelerini de silebilir. Değişken örnek kümesi p90 kıyasını zayıflatıyor; ≥50 kare koşulu bunu tek başına çözmüyor. | Sabit pencerenin sonuçlarını da sakla; kırpılmış sonuçları ikincil gösterge yap. Boş ölçüm kümesini başarısız say. |
| 6 | düşük | Kullanım kolaylığı | `lib/features/timeline/presentation/gantt/gantt_painters.dart:204` | **P2a:** Önceki `AnimatedContainer` durum rengini de geçiriyordu; yeni ressam rengi anında değiştiriyor. Seçim halkasının animasyonu korunmuş. | Bu davranış farkını kabul kaydına ekle; gerekli değilse renk animasyonu için ek yapı kurma. |
| 7 | orta | Aşırı mühendislik / uyum | `test/core/ui/motion/page_content_entrance_test.dart:130` | **P1a/P1c:** Yeni doğrulama kesin boyanmış piksel konumunu sabitliyor. `CLAUDE.md` piksel/yerleşim testlerini taşma kontrolü dışında yasaklıyor; mevcut benzer testler istisna oluşturmuyor. | Yeni piksel iddialarını **KALDIR**; tekrar başlatma, azaltılmış hareket, tek çağrı ve dispose davranışlarını koru. |

## Eksen özeti

**Teknik mantık:** `barAt` satır başına tek çubuk varsayımıyla doğru; `Rect.contains` sağ/alt kenarı dışlıyor, yerel dokunma koordinatı yatay kaydırmayı zaten içeriyor. İki Viewport aynı dikey ofseti ve eşdeğer kaydırma sınırını kullanıyor; P1c eğri/süreyi koruyor, P2d’nin `mounted` kontrolü güvenli ve bayrak yalnız yeni State’te sıfırlanıyor.

**Kullanım kolaylığı:** P1a camlı yüzeyleri solmadan görünür kılıyor; P1b’de cam iOS esnemesinde sabit kalırken etiketler kayıyor. P2d her yeni kurulumda boş gövde karesi ekliyor; P2a/P2e’de uzak çubuklara okuyucuyla erişim kaydırmaya bağlı, gerçek VoiceOver/TalkBack akışı doğrulanmamış.

**Mevcut modüllere uyum:** Yeni kodda get_it/DTO sınır ihlali görmedim; Riverpod sunum önbelleği mevcut mimariyle uyumlu. Ortak giriş bileşeninin değişmesi Görevler dışındaki arşiv, sohbet ve çizelge çağıranlarını da etkiliyor; kapsam ömrü ikinci bulguyla kapatılmalı.

**Aşırı mühendislik:** P1a parametreleri, P1b Viewport düzeni, P1c render sarmalayıcıları, P1d bekleme, P2a ressam/isabet/halka yapıları ve P2e pencereleme **GEREKLİ**; tüketicisiz yeni parametre görmedim. P2b ömrünü ve P0/P3 ölçüm yorumunu **BASİTLEŞTİR**; P2c tembellik kontrolünü koru; P2d’yi nihai ölçümle gerekçelendir; yasak piksel iddialarını **KALDIR**.

## Ölçüm yöntemi

- macOS profile sonuçları tablet yerleşimindeki göreli maliyete işaret eder; iPad GPU’suna, kaydırmasına ve mutlak kare bütçesine genellenemez.
- Debug simülatör sayıları yalnız aynı ortamda yön gösterir; fiziksel telefon profile performansını veya hedefin karşılandığını kanıtlamaz.
- “İlk kare” UI+raster toplamıdır; dokunuştan ekranda sunuma kadar gecikme değildir. P2d için dolu çizelgenin görünme zamanı ayrıca gerekir.
- Belgede S1 iyileşmesi ve S2 kötüleşme eğilimi sayılarla uyumlu; P2b’nin ek kazancı kanıtlanmıyor. “Tamamı P2a’dan” ifadesi mevcut tekrar sayısına göre fazla kesin.
- Ölçüm sırasında semantics kapalı: P2e’nin ekran okuyucu açıkken maliyeti ölçülmüş değil. P2d sonrası veri ve bu çalışma için yeşil CI kanıtı olmadan nihai performans kabulü verilemez.