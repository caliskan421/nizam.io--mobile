# Bağımsız inceleme

## Plan turu — Sol

2026-11-10: Gerçek mobil kodu ve v0.15.0-api sözleşmesi salt okunur incelendi. Kaynak değişikliği/test koşumu yok.

1. Kullanıcı çoklu departman/atanmamış/departman adı araması sunucu filtresine eşdeğer değil. Koordinatör kararı: tek departman, ad/e-posta araması; desteklenmeyen filtre/sahte kesin sayılar kaldırılacak. Şirket geneli Tümü korunacak, program_id yalnız kapsamlı sorguda gönderilecek.
2. total rol dahil; role_counts rol hariç filtrelidir, roller örtüşür. Aynı yanıttan küresel ve filtreli toplam varsayılmayacak; test/etiket kabulüne eklendi.
3. Tarih talebinde anahtar yanında ilk gövde ve sürüm korunacak. Detay ve timeline girişinde bağlam değişimi/tekrar testleri gerekli.
4. Başarılı POST sonrası GET hatası yazmayı başarısız göstermemeli; tarih ve koordinatörlük akışına kabul eklendi.
5. Kısa ad/renk için dar tipli üç hâlli PATCH; yok/null/değer HTTP kanıtı; global null serileştirme değişikliği yok.
6. Kesilmiş katalog kesin sayaç değildir. Pano/görev sayacı semantiği kart-kaynaklari.md'de ayrıldı.
7. Çok adımlı restore/bağlama zincirinde gerçek oturum/kapsam denetimi sonraki HTTP adımından önce yapılmalı.

Kod turu: Bekliyor. Bu rapor uygulamanın kabul edildiği anlamına gelmez.

## M015-0/1 kod turu — Sol

15'ten fazla salt okunur kabuk çağrısıyla çalışma diff'i incelendi. İki P1 bulgu açık:

- D01: TaskDetailController._writeKeyed içindeki conflict_retry otomatik ikinci çağrısı ilk oturum/program/departman bağlamını doğrulamıyor. Eski işlem yeni hesabın taşıyıcısıyla gönderilebilir. İkinci HTTP'den önce mounted + gerçek bağlam denetimi ve deterministik tek POST testi gerekli.
- D02: TimelineController._valid yalnız epoch/mounted kullanıyor. SessionController.clear gerçek nesli artırıp depo silmesini beklerken provider bildirimi henüz gelmeyebilir. İşlem sahipliği gerçek session.generation + program/departman snapshot'ıyla doğrulanmalı; depo silmesi geciken yarış testi gerekli.

Diğer sonuçlar: form açılış sürümü ve conflict'te eski taslağı kapatma uygulanmış; başarı sonrası okuma hatası başarıyı koruyor; Gantt OR uygulanmış, çok koltuklu sıra testi eksik; ölü repository'lerin üretim tüketicisi kalmamış. Dosya tavanı büyütülmeden tarih akışı mixin'e ayrılmış. D01/D02 kapanmadan faz kabul edilmez.

## Faz kapanış okumaları

- D01/D02 kaynakta düzeltildi; Sol kapanış okumasında yeni P1 bulmadı. Yarış testleri birleşik hedefli grupta doğrulandı.
- M015-3: eski AsyncValue ayrıntısının yeni kapsamla birleşmesi P1'i sahiplik damgası ve loading/error süzmesiyle kapandı. Sol tekrar okudu; Luna GET=2 sınırını koruyan ayrıntı testlerini yeşil doğruladı.
- M015-4: Sol iki alanla sınırlı PATCH üretimini, DTO sınırını, bilinmeyen rengi, rozet sahipliğini ve token blob'unu okudu; açık engel bulmadı. Luna 58 hedefli testi doğruladı.

## Birleşik nihai tur — Sol

25'ten fazla salt okunur kabuk çağrısıyla tüm geçiş incelendi. D03 açık P1: HomeDashboardController._load katalog await'inden sonra gerçek sahipliği doğrulamadan yönetici raporu/ekip ekleri HTTP'sini başlatabiliyor. Kontrol yalnız build sonunda kalmamalı; sonraki HTTP'den önce generation+program/departman kontrolü ve mutlak sıfır çağrı testi gerekli.

P2 sunucu filtre/sayaçları, tekil profil, onay sonrası hesap eylemi sahipliği; P5 bağımsız bölüm ve retry; DTO/DI sınırları ile önceki fazlar için başka engel bulunmadı. D03 kapanmadan nihai kabul yok.

Birleşik hedefli koşum ayrıca iki mevcut profil akışı testini farklı nedenle kırmızı buldu: Flex dışında fallback yönü olmayan Gap render hatası ve ekrandışı Takvim dokunuşu. Aynı test adlarının tabanda kırmızı olması bu yeni nedeni taban sorunu saydırmaz; kaynak ve akış düzeltilerek yeniden doğrulanacak.

## Nihai sonuç

D03, HTTP öncesi gerçek sahiplik kontrolüyle kapandı. Sol f722e22 üzerinde son salt okunur okumada BULGU YOK verdi; allowance/eşik gevşetilmediğini ve kaldırılan iki presentation yardımcısının üretim tüketicisi olmadığını ayrıca doğruladı. Profil testleri telefon/tablette gerçek hesap bilgisi ve eylemleriyle geçti. Luna aynı işlevsel ağaçta tam verify EXIT=0 ve 2378 yeşil test doğruladı.

Aynı programdaki son bilinen etiketin yenileme hatasında kalabilmesi, Sol tarafından hesaplar arası P1/yayın engeli sayılmadı. Koordinatör mevcut davranışı korudu ve açıklama yorumunu düzelttirdi; yükleme ve program kimliği değişiminde etiket gizlenir.
