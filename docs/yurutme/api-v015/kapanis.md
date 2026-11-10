# M015 yerel kabul ve oturum kapanışı

- Tarih: 2026-11-10; dal: ozellik/mobil-api-v015; taban: arayuz/kullanicilar-ve-tablolar-tasarim-uyumu.
- M015-0–5 uygulandı: pin/üretim, güvenli tarih talebi, kullanıcı dizini/hesap durumu, koordinatörlük kurtarması, dönem rozeti ve bağımsız pano bölümleri.
- Ürün farkı: kullanıcı filtresi tek departman; arama ad/e-posta. Atanmamış seçeneği API desteği olmadığı için kaldırıldı.
- Dönem başına ek sayaç isteği yok; sayısal pano özeti mevcut rapor yanıtından, yardımcı bölümler bağımsız yüklenir.
- Kesik katalog sayıları ≥ ile gösterilir. Pano/görev sayacı kapsamları karıştırılmaz (kart-kaynaklari.md).
- Uygulama ve test yazımı Terra medium; bağımsız inceleme Sol; test koşumu ve kanıt Luna; kabul/commit koordinatörde.
- Sol D01/D02/D03 ve eski kapsam ayrıntısı açıklarını kapattı; son hüküm f722e22 üzerinde BULGU YOK.
- Luna: temiz ağaçta gen-check EXIT=0; son sıra kilitli make verify EXIT=0; 2378 test geçti.
- Kapsama: core %96,15; application %87,70; data %97,92; presentation %61,94; core UI %97,17; kapsamasız dosya yok.
- Kanıt: kanit.md, kanit-M015-3.md, kanit-M015-4.md, inceleme.md. Ham çıktı yerel /tmp/nizamio-m015-luna/ altında, git'e alınmadı.
- Son işlevsel doğrulama f722e22; sonrasında yalnız belge ve gerçek davranışı açıklayan yorum güncellendi.
- Ana mobil ağacındaki kaydedilmemiş çalışmalar korundu; backend/yönetim deposuna yazılmadı.
- Teslim sırası: mevcut PR #59 → #60 → bu geçişin bağımlı taslak PR'ı; main'e birleşme yapılmadı.
- Dış kapılar: KR-27 nedeniyle CI tetiklenmedi; Linux golden Darwin üzerinde atlandı; gerçek backend entegrasyonu ve CI Android derlemesi doğrulanmadı.
- Sonraki adım: mevcut UI PR zinciriyle birlikte Linux/CI ve gerçek backend doğrulamasını tamamlamak.
