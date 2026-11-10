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
