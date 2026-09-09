# AGENTS.md — nizam.io--mobile

Her ajan önce `CLAUDE.md`'yi, sonra yönetim deposundaki `../project-control/START-HERE.md`'yi okur.

Bu depoya özgü:

1. Bugün itibarıyla bu depoda uygulama kodu yoktur; yalnız bu dört yönetişim dosyası
   vardır. Faz 3'te mobil istemci kodu hiç yazılmadı — mobilin Faz 3 kapsamı yalnız
   backend'deki açık sistem bilgi/keşif ucu ve sözleşme testleriydi (D-0057). Aktif bir
   Faz 4 iş paketi kartı olmadan hiçbir kod, iskelet veya bağımlılık dosyası eklenmez.
2. Teknoloji/framework seçimi henüz yapılmamıştır — bu depoda bir framework varsayılıp
   ona göre dosya, dizin veya komut üretilmez.
3. Discovery/instance doğrulama zinciri (ADR-0006, ADR-0007) fail-closed'dır: sunucu
   adresine veya QR/davet girdisine imza ve instance kimliği doğrulaması tamamlanmadan
   güvenilmez; bu ilke tasarımın her adımında korunur.
4. Sözleşme kaynağı `../project-control/contracts/`'tır (özellikle C4 discovery); bu
   depoda sözleşmenin yerel kopyası tutulmaz veya tek taraflı değiştirilmez.
5. Mobil `NEW`'dir — eski Teknofest ürününde karşılığı yoktur; Teknofest kodu
   kopyalanmaz ve davranış kanıtı olarak dahi kullanılmaz.
