# İlerleme

- Son kalite turu: CSV dışa aktarma fonksiyonunun üretim çağırıcısı olmadığı ve üyelik metni yardımcısının yalnız bu işlevce kullanıldığı doğrulandı; iki ölü presentation dosyası kaldırıldı. Ortak CSV yazıcısı ve davranış testi korundu; kullanıcıya sunulan bir dışa aktarma eylemi kaldırılmadı.

- 2026-11-10: Orkestrasyon açıldı. İzole worktree ve görev dalı hazır. Ana ağaçtaki kaydedilmemiş değişiklikler korunuyor. Önce Luna taban koşumunu alacak; aynı sırada Terra salt okunur keşif yapacak.
- M015-0/1 uygulandı; Luna ilk hedefli grupta 137 testi ve boyut kontrolünü yeşil doğruladı. Sol D01/D02 oturum/kapsam açıklarını buldu, Terra düzeltti, Sol kaynakta kapandığını doğruladı.
- Güvenlik yarış testleri ilk koşumunda disposed-ref kaynak hatası ve yeni timeline testinde etkinleştirilmemiş provider nedeniyle bekleme bulundu. Bu koşum yeşil kanıt değildir; faz kabulü açık. Checkpoint sonrasında Terra düzeltecek.
- Koordinatörlük ve dönem rozeti bağımsız worktree'lerde Terra medium uygulayıcılarına ayrılacak. Ana uygulayıcı önce açık kalite düzeltmeleri, ardından M015-2 ve M015-5'i yapacak. Her worktree ayrı yazma alanıdır; finalde birleşik ağaç Luna/Sol kapısından geçer.
- M015-0/1 kalite düzeltmesi: disposed Ref koruması ve yarış testlerinde etkin provider, zaman sınırı ve bekleyen işlemlerin temizliği eklendi; yeniden koşum bekliyor.
- M015-2: kullanıcı listesi sunucu süzgeci/sayaçları ve tekil profil okumasına taşındı; Tümü şirket geneli, departman seçimi tek ve programla birlikte gönderilir. Atanmamış seçeneği ve satır bazlı sahte sayılar kaldırıldı. Hesap açma/kapatma ve kilit ayrımı eklendi. Yeni davranış testleri yazıldı; bağımsız koşum ve inceleme bekliyor.
- M015-5: yönetici temel özeti, bekleyen işler ve okunmamış sohbetler bağımsız yüklenir; yardımcı bölüm hatası temel raporu düşürmez, tekrar yalnız bölümü yeniler. Kesik bekleyen listesi uyarı taşır; kapsam/oturum sahipliği kontrol edilir. Test koşumu ve nihai kaynak haritası denetimi bekliyor.
