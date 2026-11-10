# Mobil API v0.15 geçişi

Durum: Yerel kabul tamam — 2026-11-10. Koordinatör: ana ajan; uygulama/test yazımı: Terra medium; bağımsız kısa inceleme: Sol; test koşumu/kanıt: Luna. Süreç ve kapanış bu mobil depoda tutulur (ürün sahibi talimatı). Sonuç: 2378 test ve kapsama kapıları yeşil; Sol BULGU YOK. Linux golden/CI/gerçek backend doğrulaması bekliyor. Ayrıntı: [kapanış](kapanis.md).

## Kapsam ve taban

API pini v0.15.0-api olur. Mevcut feature-first, controller/Riverpod + get_it mimarisi korunur. Backend ve yönetim deposu değiştirilmez. Ana mobil çalışma ağacındaki kaydedilmemiş çalışmalar kapsam dışı ve dokunulmazdır. Ayrı worktree, mevcut kullanıcı arayüzü dalının kaydedilmiş ucunu içerir; bu tasarım dalını main'e birleştirme kararı bu işte otomatik verilmez.

Teslim zinciri: mevcut kullanıcı/tablo PR #59 → arayüz PR #60 → bu geçişin ayrı PR'ı. Bu geçiş arayüz dalını taban alır; onun main'e birleşmesini zorlamaz. Son head commit [skip ci] taşır ve mobil CI tetiklenmez.

## Fazlar ve kabul

| Faz | İş | Kabul | Durum |
|---|---|---|---|
| M015-0 | Pin, üretim, hata metinleri, Gantt HttpResponse, fixture uyumu | Etiketten üretim tekrarlanabilir; taban/yükseltme kırmızısı ayrılır; sınır/lint kapıları korunur | Yerel geçti |
| M015-1 | Tarih talebi anahtarı/sürümü; Gantt kesilme bilgisi; ölü repository temizliği | Aynı belirsiz işlemde aynı gövde+anahtar+sürüm; 200/201 başarı; çakışmada taze okuma ve kullanıcı kararı; oturum/kapsam sızıntısı yok | Yerel geçti |
| M015-2 | Kullanıcı listesi/sayaç/profil ve hesap kapatma-açma | Sunucu filtre/sıra; boş sayfa+dolu imleç devam eder; sorgu değişiminde eski cevap atılır; sayaçlar doğru kapsamda; readUser; kilit/kapalı ayrımı; self/last_admin/403/404 ve changed:false | Yerel geçti |
| M015-3 | Koordinatörlük ayrıntısı ve iki adımlı oluşturma/bağlama | readProgramDepartment; adım başına anahtar; mevcut/silinmiş departmanda açık kullanıcı onayı; kısmi başarıdan kalan adıma devam; küresel kayıt sessiz değiştirilmez | Birleşti; yerel geçti |
| M015-4 | Dönem kısa adı/renk ve tutarlı seçim UI'sı | Sidebar kartı, dönem listesi, ilgili başlıklar; oluştur/düzenle/temizle; null-yok-değer ayrımı; erişilebilir açık/koyu renk; bilinmeyen/boş güvenli yedek | Birleşti; yerel geçti |
| M015-5 | Kart/rozet veri kaynağı ve dönem geçişi denetimi | Kart→uç→kapsam tablosu; aynı bilgi için gereksiz istek yok; pano ve görev sayacı semantiği karıştırılmaz; eski dönem/hesap verisi görünmez; hata sıfır sayılmaz | Yerel geçti |
| M015-Q | Bağımsız inceleme, düzeltme, doğrulama, kapanış | Sol bulguları kapalı; Luna komut/exit/sonuç kanıtı; bütün yeşil yerel kapılar veya açık sınırlama; temiz commit'li görev dalı | Yerel kabul; dış ortam kapıları bekliyor |

## Varsayılan ürün kararları

- Dönem seçicisinde ad/kısa ad/renk bulunur; her dönem için ayrı sayaç isteği eklenmez. Program listesi bu sayaçları taşımıyor.
- Hesabı kapatma silme değildir: oturumlar iptal, erişim kapalı; görev/geçmiş kalır. Açma eski rol/üyeliklerden gelen erişimi geri verir. UI bunu açıklar; sunucu yetkisi esastır.
- E-posta yalnız yetkili yönetici kullanıcı yüzünde gösterilir. Başarısız giriş kilidi ve yönetici kapatması ayrı gösterilir.
- Kullanıcı filtresi tek departman seçer; API çoklu departman ve üyeliksiz/atanmamış filtresi desteklemediğinden bu seçenekler sunulmaz. Arama ad/e-posta içindir; eski yerel departman adı araması kaldırılır. Departman seçeneklerinde eksik listeden türetilmiş kesin kişi sayısı gösterilmez. Bu görünür ürün farkları teslimde belirtilir.
- Silinmiş departman otomatik geri yüklenmez; mevcut kaydı bağlama ve geri yükleme açık onay ister. Oluşturma formunun tür/açıklaması mevcut kaydı sessiz ezmez.
- Dönem kısa adı ve rengi temizlenebilir. Üretilmiş kod elle değiştirilmez; üç hâlli PATCH için mevcut üretici/altyapıda en küçük tipli çözüm kullanılır, katman sınırı delinmez.
- Kart verisi zaten tek özet cevabından geliyorsa yeni sayaç isteği eklenmez. Görev listesi sayaçları gerekirse countProgramWorkItems ile aynı filtrede beslenir; yalnız saymak için bütün sayfalar çekilmez. Tam katalog zaten işlev için gerekliyse fazladan çağrı eklenmez.
- Pano bölümlerini bağımsız yüklemek ancak mevcut yapıda küçük, güvenli ayrıştırma ile mümkünse yapılır; büyük pano yeniden tasarımı yapılmaz. Yapılmayan iyileştirme somut gerekçeyle kapanışta kayıtlı kalır.
- Sonuç: temel özet, bekleyen işler ve okunmamış sohbetler bağımsız yüklendi. Aynı programdaki etiket yenilemesi hata verirse son bilinen ad/renk kalabilir; yükleme ve program kimliği değişiminde eski etiket gizlenir. Bu etiket eylem yetkisi sağlamaz.
- Süre uzatma UI'sı, yeni dönem toplu-sayaç backend ucu, backend değişikliği ve mimari yeniden yazım yok.

## Çalışma ve doğrulama

Terra kodu ve davranış testlerini yazar; Luna testleri çalıştırır ve raporlar. Aynı ağaçta test koşarken düzenleme/commit yapılmaz. Terra üretim/format/analyze çalıştırabilir; test koşumu Luna'ya aittir. Her faz küçük diff olarak koordinatörce kaydedilir; ana ağaca ve başka çalışmalara dokunulmaz. git add -A, git add ., git commit -a ve stash yasaktır.

Hedefli repository/controller/HTTP sözleşme testleri; test/tool ve test/core/generated; gen-check (temiz commit sonrası); make lint ve test-presence; son birleşik ağaçta coverage bir kez. Tam verify yalnız yönetim deposunun verify-sirasi.sh aracıyla. Mobil CI tetiklenmez (KR-27). Golden macOS üzerinde atlanır; bu gerçek açıkça yazılır, Linux kanıtı uydurulmaz. Kırmızı test silinerek/atlanarak veya eşik azaltılarak yeşile çevrilmez. Taban kırmızılar ayrı tanılanır, bu kapsamla ilişkili olanlar düzeltilir.

## Kayıtlar

- ilerleme.md: faz ilerlemesi, uygulayıcı devirleri ve devam notları.
- kanit.md: taban/hedef komutları, çıkış durumu, kısa sonuç ve sınırlar (Luna).
- inceleme.md: Sol'un dosya/satır dayanaklı bulguları ve düzeltme durumu.
- kapanis.md: son kabul, kalan sınırlamalar ve teslim dalı (koordinatör).
