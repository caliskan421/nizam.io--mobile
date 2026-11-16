# Tablo çalışma alanı — uygulama ve doğrulama notu

Durum: uygulama ve yerel doğrulama tamamlandı (2026-11-16); kullanıcı kullanım geri bildirimi bekleniyor. Mobil depo işi; backend veya
program fazı açılmadı, API pini değiştirilmedi, push/CI tetiklenmedi.

Kullanıcı bütün tablo/liste/detay akışlarını pinli backend özellikleriyle tamamlamamızı,
telefon ve tableti ayrı kontrol etmemizi istedi. İlk geniş tasarım yerine kompakt düzen
istendi; başlığı üst çubuğa alan kompakt telefon/tablet görüntüleri açıkça onaylandı.
Başvuru görüntüleri: `/tmp/nizam-workspace-360.png`, `/tmp/nizam-workspace-1180.png`.

## Mekanizma

- Liste/oluşturma/paylaşım önceki çalışmadan gerçek uçlara bağlıdır. Varsayılan yalnız
  sahip; kişi yetkisi ve isteğe bağlı ekip yetkisi ayrı. Koordinatörlük içinden açılan
  oluşturma formu o konumla başlar. Kişiler kapalı koordinatörlük gruplarında sıralanır.
- Yeni `TableDetailController` ve workspace sayfaları eski salt okunur önizlemenin
  yerini alır. Repository domain komutlarını generated DTO'lara eşler; scalar JSON ve
  SSE/akışlı dosya imza uyarlamaları `core/http` içindedir.
- İçerik/şema: satır ekleme/silme/taşıma, tek hücre ve atomik batch, sütun ekleme/ad/
  genişlik/silme/taşıma/kayıpsız dönüşüm. Hücre CAS ve şema sürümü korunur.
- Tam ondalık sayı metni okumada ve yazmada double üzerinden geçmez. Null hücre ve
  yazılmış null hücrenin pozitif sürümü ayrılır. Referans etiketleri kimlik yerine kullanılır.
- Paylaşım verme/değiştirme/iptal, dinamik ekip erişimi, projeler, şablon işareti,
  yapı/tam kopya, taşıma/öneri/geri çekme, öneri onayı/reddi, satır/hücre yorumları,
  tablo eki yükleme/indirme/temizleme ve koşullu geri alma arayüzleri eklendi.
- Filtre/sıralama backend'e gönderilir. Yorum/proje/öneri listeleri sayfalıdır.
- SSE uyarıları snapshot ile karıştırılmaz; replay imleci changes.cursor'dan ilerler.
  Presence seçimi/kalp atışı/ayrılma, görünürlük ve oturum/kapsam çitleri vardır.
- Belirsiz yazım aynı komut/anahtarla sürer. Bekleyen detay yazımı ekran kapanınca
  keepAlive ile korunur; hesap/kapsam değişince atılır. Geç yanıtlar eski nesle uygulanmaz.
- Sütun/hücre çakışmalarında taslak korunur ve güncel veriye uygulama açık seçim ister.
  Bilinen erişim kaybında detay ve açık detay sheet içerikleri gizlenir.

## Web referansına uyarlama (2026-11-16)

Ürün sahibinin iki web ekranı referans alındı: hücre sınırları, tür simgeli başlıklar,
kişi avatarları, dosya/tablo bağlantısı etiketleri, tablo içinde yeni satır ve sütun altı
özetleri. Tümü/Açık/Tamamlanan seçimi ilk onay sütununa backend filtresi gönderir;
birden fazla onay sütununda diğer sütunlar genel filtre ekranından seçilebilir.
Özetler yalnız görüntülenen sayfayı kapsar; mevcut olmayan erişim/son düzenleme/
geri bağlantı verisi uydurulmaz. Görünür giden tablo bağlantıları ilgili tabloyu açar.

Tablo alanında doğrudan Material TextButton/Checkbox/tarih seçicisi kaldırıldı.
Düğmeler NzButton, seçimler NzCheckCircle, metin/sayı düzenleme NzFormRows.input,
tarih seçimi showNzDateSheet kullanır. Başlık/oluşturma gibi diğer alanlar proje genelinin
standart NzTextField bileşenindedir. Ortak tasarım kitinin iç düzenleme primitive'leri
ve malzeme yüzeyleri korunur; feature içinde Material varsayılan form görünümü yoktur.
Negatif/ondalık/üslü sayı girişi basamak filtresinden geçirilmez. Onay hücresine tek
simge dokunuşu sürüm kontrollü set_cells gönderir; genel geri alma mekanizması çalışır.

Telefon 360×640 ve tablet 1180×820 için koyu temalı tür/özet/sunucu filtresi ve hücre
formu görselleri üretildi; negatif ondalık ve tek dokunuşlu CAS davranışı sınandı.
Yerel görseller `/tmp/nizam-web-reference-{360,1180}.png` ve
`/tmp/nizam-web-reference-input-{360,1180}.png`. Ekran pencereleri kapatılmadan iki
debug oturumuna güncel kod aktarıldı. Son beş ekran uyarlamasında başlık
ConsumerWidget → ConsumerStatefulWidget değiştiği için hot reload eski Element
ağacında tip uyuşmazlığı verdi; iki oturum hot restart ile temizlendi.

## Etkileşimli ana referans

Ürün sahibi [Claude prototipini](https://claude.ai/artifact/W25DrXfL1htpcn8E5gL1Xf#play-aa2f98ddfa93)
ana referans olarak belirledi. Arc'taki açık oturumda aynı URL doğrulandı ve çalışan
Tablolar görünümü incelendi. Genel web okuması erişemedi, IAB oturum istiyor; ham HTML
kaynağı alınamadı. İncelenmeyen etkileşimler veya ham kaynak okunmuş gibi varsayılmaz.
Prototipte ve açık kullanıcı talebinde son başlık daima “+” ile yeni sütundur.
Canlı mobil grid'e bu başlık eklendi, ayrı üst düğme kaldırıldı. Sütunsuz tabloda da
“+” kullanılabilir. Telefon/tablet ekleme, sütunsuz tablo ve referans görünümü için
hedefli 7 test geçti. Diğer sütun işlemleri kendi başlıklarından açılır.

## Beş ekranın doğrudan uyarlaması (2026-11-16)

Ürün sahibi 03.18.27 / 03.18.47 / 03.19.00 / 03.42.30 / 03.42.41 adlı
beş görseli son tasarım kaynağı olarak verdi ve ek onay istemeden uygulamamızı istedi.
Önceki kompakt düzen bu kaynaklarla güncellendi.

- Ana detay: büyük başlık + konum, doğru sahip adı, bilinen kişiler/canlı katılımcılar,
  beyaz Paylaş, üç sayaçlı sekme, Sütunlar/Yeni satır araçları, son “+” başlığı,
  kare tamamlanma, lime avatarlar, dosya etiketleri, tarih aralığı/kolon özetleri.
- Yeni satır: altı çizgili başlık, seçim satırları, tarih ve toggle, eşit Vazgeç/Ekle.
  Form açılışı/iptali yazmaz. Ekle'de add_row → atomik set_cells → seçilmiş ek yükleme
  adımları bağımsız sabit anahtarla sürer; kısmi hata aynı satırdan devam eder.
  Hesap/kapsam çiti adımlar arasında yeniden kontrol edilir. Yeni satır konumu için
  add_row sırası ayrıca korunur; sonraki hücre/yükleme sırası konuma karıştırılmaz.
- Sütunlar: sürükle/sırala, gözle görünürlük, tür/ad, düzenleme ve sütun ekleme.
  Görünürlük oturum/kapsamla sınırlı yerel görünüm tercihidir; şemayı/veriyi silmez.
- Sütun detayı: geri + Bitti, altı çizgili ad, Tip, Yok/Artan/Azalan, sola/sağa taşı,
  silme. Türün altında genişlik işlemi korunur. Şema çakışması taslağı korur.
- Paylaşım: özel arama, avatar/rol/koordinatörlük satırları, Düzenler/Görür, kaldırma,
  birim yetkileri, bağlantı yolu kopyalama ve Kapat. Her yetki değişimi doğrulanmış
  komutla kaydolur. Tam ACL/program erişimi API boşlukları aşağıdaki gibi korunur.
- Yeni tabloya özel görsel parçalar `table_design.dart` içindedir; başlık düzenleme
  Cupertino düzenleme primitive'ini kullanır, Material alan görünümü yoktur. Ortak
  NzFormRows'a isteğe bağlı zemin rengi eklenmiş, varsayılanı değiştirilmemiştir.

Yerel kanıt: toplam 148 tablo/root-flow/boyut testi geçti. Yeni satırda kayıp cevap,
kısmi hata, kapsam değişimi; beş ekran ve görünürlük/yeniden adlandırma; eski CAS,
paginasyon, paylaşım ve API komut testleri birlikte sınandı. Koyu tema görselleri:
`/tmp/nizam-exact-{table,new-row,share,columns,column}-{390,1180}.png`.
CI/push tetiklenmedi. Canlı veride rol/satır değişikliği yapılmadı. Hot restart
sonrasında iPhone ve iPad üzerinde mevcut tablo açılışı gerçek API ile yeniden doğrulandı.

## Sözleşmenin sağlamadığı bilgi

Snapshot mevcut grant listesini ve okuyanın etkin editor/viewer rolünü döndürmüyor.
Sahiplik owner_id ile bilinir; içerik yazım yetkisini sunucu doğrular. Paylaşım sheet'i
mevcut erişim listesini uydurmaz; seçilecek kişilerin yetkisini günceller/iptal eder.
Bu iki bilginin tam gösterimi ayrı backend sözleşmesi genişletmesi gerektirir.

## Doğrulama

- `flutter test test/features/tables test/app/router/table_workspace_flow_test.dart
  test/app/router/table_workspace_conflict_test.dart test/app/router/table_workspace_reference_layout_test.dart
  test/app/router/tables_backend_flow_test.dart
  test/app/router/users_tables_flow_test.dart test/tool/file_size_test.dart`: 148 test geçti (son beş ekran ve yeni satır iş akışı dahil).
  Ardından eklenen atomik satır formu testi ve scrollbar düzeltmesi ilgili telefon/tablet
  dosyalarında ayrıca doğrulandı.
- API matrisi: 24 komut × iki alan; scalar/batch, kayıpsız ondalık, filtre/sıralama/kopya;
  presence, yorumlar, changes, SSE, dosyalar, projeler ve öneri kararları.
- Controller: belirsiz/bozuk yanıt aynı anahtarı korur; erişim kaybında içerik gizlenir;
  eski oturum cevabı atılır; replay bütün sayfaları tüketir; görünmezken presence bırakılır.
- Sayfalama: okuma bütçesine uyarlanma, sınırlı sayfa belleği, önceki/sonraki sayfa,
  başarısız filtrede konumun korunması, bayat imleçte ilk sayfaya dönüş, ilk sayfa dışında
  eklenen satıra odaklanma. Kullanıcı sorgusu canlı yenilemeyle yarışmaz.
- Telefon 360×640 ve tablet 1180×820: satır/hücre/sütun kaydı, CAS sürümleri,
  çakışmada taslak + karşılaştırma + açık üzerine yazma onayı ve taşma kontrolleri.
- Hedefli `flutter analyze --fatal-infos`: sorun yok. Hedefli mimari/API/hata yolu
  denetimi: 63 dosya / 0 ihlal. 600 satır kapısı ve `git diff --check` temiz.
- iPhone 17 Pro Max ve iPad Pro 13 debug oturumlarına hot restart uygulandı;
  gerçek yerel API ile mevcut tabloların detayı, boş durum ve işlem menüleri açıldı.
  Canlı kayıtlarda izin/değer değişikliği yapılmadı; yazımlar kontrollü test repository'siyle
  sınandı. CI/push çalıştırılmadı.
- Hata envanteri araçla yeniden üretildi. Backend boşlukları yukarıda açıkça kayıtlıdır;
  bu çalışma backend davranışını veya API pinini genişletmez.

Çalışma alanında çok sayıda ilgisiz paralel değişiklik vardır. Toplu stage/stash yok.
Tablo dosyaları dışında `NzIcons.undo` için tek semantik ikon satırı ve core tablo wire
yardımcıları bu işindir. Shared expansion bileşeni ve başka ikon değişiklikleri başka
çalışmadan geldi; sahipliği karıştırılmayacak. Son çalışma henüz commit edilmedi.

## 16 Kasım — standart bileşenler ve klasör görünümü

- `NzSelect`, Material dropdown yerine alt gezinmedeki `NzFlyoutMenu` ile açılır.
  Form doğrulaması/sunucu alan hatası, devre dışı seçimler, klavyeyle açılış ve
  erişilebilir etiket korunur. Menü açıkken kaldırılan/devre dışı kalan seçenek
  geç uygulanmaz. Başlık girdileri görev eklemedeki `NzTextField` bileşenidir.
- Sütunlar ve sütun ayrıntısındaki sabit yükseklik kaldırıldı. İç gruplar standart
  `surfaceRaised` rengini kullanır; büyük içerikte ortak sheet kaydırması devam eder.
- Tablolar başlığında dairesel görünüm/sıralama/işlem ikonları vardır. Eski proje,
  şablon ve filtre kaldırma metin düğmeleri kaldırıldı. Şablon şeridi tüm alanlarda
  üstte görünür; `NzPageBleed` ile panel kenarlarına kadar kayar ve ilk dolguyu
  kendisi taşır. Koordinatörlükten geri dönüş başlıkla aynı kompakt satırdadır.
- Projeler kullanıcıya klasör olarak sunulur. Arşiv klasör kartı `NzFolderCard`
  olarak core'a çıkarıldı; arşiv eski adlarını alias ile kullanır. Klasörler gerçek
  projects uçlarından imleçle sayfalanır. Klasöre girme, geri dönme ve Tümü görünümü
  erişim izinlerini değiştirmez. Klasör yönetimi ve öneriler ikon menüsünde korunur.
  Sıralama mevcut sayfada varsayılan/ad artan/ad azalan biçimindedir; API'nin
  sağlamadığı güncelleme zamanına göre sıralama uydurulmaz.
- Klasör sayfaları hesap/kapsam anahtarıyla ayrıdır; yazım revision'ında ve mevcut
  kaydırarak yenileme callback'inde geçersizleştirilir. Hata ve tekrar deneme görünürdür.
- Ortak düğme/ikon düğmesi, form satırı, menü ve tablo dokunmalarında ripple/pressed
  renk etkisi kaldırıldı; `NzPressable` küçülmesi kullanılır. `NzTap` aynı klavye
  ve dokunma davranışını ortaklaştırır.
- Telefon 390×844 ve tablet 1180×820: klasör sayfalama/hata kurtarma/filtre/sıralama,
  standart tür seçimi ve iptalde yazmama sınandı. Geniş koşum 227 test geçti
  (3 opt-in golden atlandı); son değişiklikler ayrıca hedefli yeniden sınandı.
  Görseller `/tmp/nizam-refine-library-{390,1180}.png` ve
  `/tmp/nizam-exact-column-type-{390,1180}.png` altında.
- İki debug oturumuna hot reload gönderildi; ilk reload sonrası loglarda hata yoktu.
  Telefonda gerçek koordinatörlük listesi, Görünüm menüsü ve backend klasör kartı
  açılarak doğrulandı. iPad o sırada başka rolün görev ekranındaydı; bu turdaki
  tablet tablo doğrulaması kontrollü widget akışıdır. Canlı tablo/izin yazımı yoktur.
- Son test derlemesini kesen eşzamanlı arşiv değişikliğinde yalnız bir uyum satırı
  düzeltildi: `NzDialog.confirm(danger: true)` yerine mevcut API'deki
  `tone: NzDialogTone.destructive`. Diğer arşiv düzenlemeleri bu işin değildir.

Bu turdaki ortak UI değişiklikleri: `NzSelect`, `NzButton`, `NzIconButton`,
`NzFormRows`, `NzMenuGroup`, `NzFlyoutMenu`, yeni `NzTap` ve `NzFolderCard`,
`NzPageBleed`. Önceki çalışma notundaki yalnız ikon/wire kapsamı bu tur için
geçerli değildir. Toplu stage/stash yapılmadı; CI/push çalıştırılmadı.

Son doğrulama: hedefli analiz temiz; 65 dosyalık mimari/API/hata kapısında 0 ihlal;
`git diff --check` temiz. Yenileme/sıralama ve seçici testleri 10 geçti (1 opt-in
golden atlandı); ortak form/menü/flyout ve arşiv klasör akışında 32 test geçti.
Son hot reload telefon ve iPad'de tamamlandı. Arşivin paralel eklenen `_delete`
metodunda analizörün gördüğü üç async-context bilgisi bu işte yeniden düzenlenmedi;
parametre uyum satırı dışındaki arşiv değişiklikleri ayrı çalışmanın kapsamındadır.

## 16 Kasım — koordinatör/üye yetki denetimi

Ürün sahibinin rol denetimi isteğiyle backend kodu/README/ADR-0033 ve mobil
karşılaştırıldı. Backend değişmedi; istemci pin v0.20.0-api kaldı.

Düzeltmeler:
- Üye menüsüne Tablolar eklendi; çekmece, tablet rayı ve telefon üçüncü yuvası
  aynı modül tanımından erişir. Tablonun sahibi olan üye sahiplik haklarını korur.
- Paylaşım seçenekleri ve liste controller'ının Riverpod bağımlılıkları açıklandı;
  kapsam içindeki katalog/oturum değişiklikleri doğru sağlayıcıya gider.
- Bilinmeyen ekip rolü koordinatörlük/hedef seçeneğine hak vermez. Klasör ve onay
  yönetimi, birleşik hesapta ham yönetici bayrağı yerine seçili EffectiveAccess
  görünümünü kullanır; Üye görünümü yönetim eylemlerini açmaz.
- Kişiselden koordinatörlüğe taşımanın doğrudan kipi, seçili görünümde hedefi
  yönetemeyen kişide devre dışıdır. Hedef seçimi üyeyi öneri yoluna yönlendirir;
  submit doğrulaması da doğrudan taşıma kuralını korur. Sunucu nihai yetkilidir.

Kanıt:
- İşe özel `nizamio_tables_role_audit_20261116` DB'sinde gerçek PostgreSQL ile
  14 entegrasyon senaryosu + 2 usecase birim testi geçti; fail/skip yok.
  ACL, özel tabloya yönetici/koordinatör bypass'ı olmaması, kişisel paylaşım ve
  üyelik, dinamik ekip viewer/editor, koordinatörlük/kişisel proje yetkileri,
  dosya/yorum yetki matrisi, kopya viewer sınırı, taşıma ve öneri yaşam döngüsü.
  Komutlar `go test -p=2 -parallel=1 -count=1 -timeout=8m -json` ile hedefli
  koşuldu; DB iş sonunda adıyla silindi. Ham çıktı `/tmp/nizam-tables-role-backend-*.jsonl`.
- Mobil tekrar koşumu 162 test geçti (tables, root akışları, rol menüsü, boyut).
  Son görünüm düzeltmesi sonrası 7 rol testi ayrıca geçti: saf üyelik/koordinatörlük
  kapsamı, birleşik hesapta seçili rol, koordinatör/üye × telefon/tablet liste,
  koordinatörlükte oluşturma ve klasör yönetimi görünürlüğü.
- iPad'de Üye görünümünde Tablolar ray düğmesi ve gerçek API'den açılan liste
  canlı olarak görüldü. Canlı ortamda tablo/izin değişikliği yapılmadı.
- Hedefli analiz ve 65 dosyalık mimari/API/hata kapısı temiz; git diff --check temiz.
  CI/push yok. Testler yerel kanıttır, tam yayın kabulü değildir.

Kalan sınırlar kullanıcıya açıkça aktarılır: API etkin editor/viewer rolünü ve
mevcut kişi grant listesini döndürmez; owner_id bilinir, non-owner yazma arayüzü
kesin rol süzmesi yapamaz ve sunucu 403 ile korur. Paylaşım paneli tam ACL envanteri
olarak sunulamaz. Program geneline paylaşım, gelen tablo bağlantıları, son düzenleyen
ve düzenleme zamanı bu sözleşmede yoktur. Kopyalanan rota erişim vermez; dış paylaşım
ve davet bağlantısı servisi değildir. Ana liste araması/sıralaması, görünüm ve sütun
saklama yereldir; kaydırma yenilemesi, tablo/klasör/paylaşım/işlem verileri gerçek API'dir.

## 16 Kasım — toplu ekip seçiminden kişi bazlı yetkilendirmeye geçiş

Ürün sahibinin kullanım kolaylığı isteği: koordinatörlük topluca seçilse bile
kişiler seçili görünmeli; tek tek izin değişimi ve çıkarma mümkün olmalı.

- Yeni tablo formunda Tüm ekip, o koordinatörlüğün görünür mevcut üyelerini seçili
  kişi listesine de taşır. Koordinatörlük dışındaki yönetici adayları otomatik
  eklenmez. Dinamik kipte ortak izin değişimi seçili üyelerin gösterimine yansır.
- Bir kişinin iznini değiştirme/kişiyi çıkarma, diğer seçimleri koruyarak kişi
  bazlı kipe geçirir; kayıtta farklı kişi grant'leri gönderilir, team_role açılmaz.
  Tüm ekip kipi korunursa dinamik paylaşım devam eder. Ayrıca elle seçilmiş ekip
  dışı geçerli adaylar, dinamik kipte de açık grant olarak kaydedilir.
- Mevcut dinamik paylaşım panelinde ekip üyeleri seçili ve yetki kontrolleriyle
  görünür. Kişisel değişimde önce uygulanacak tüm izinlerin önizlemesi açılır;
  iptal henüz yazım başlamadıysa sıfır istek gönderir. Önizleme, eski kişi izinlerinin
  tam listesinin okunamadığını ve listelenen izinlerin değişeceğini açıkça söyler.
- Onayda `TableTeamSharingJob`, açık grant'leri ve hedef kişi için gerekiyorsa
  revoke'u tamamlar, sonra dinamik ekip erişimini kapatır. Sonradan katılanlar
  otomatik eklenmez. Çok adımlı işlem atomik değildir; başarılmış adımlar korunur,
  belirsiz yanıt aynı adım/anahtarla sürer. Kapsam değişimi sonraki adımları keser.
  Controller'ın mevcut bekleyen işlem/yeniden dene/denemeyi bırak mekanizması kullanılır.
- Backend değişmedi. Tam mevcut grant listesi hâlâ sözleşmede yoktur; bu nedenle
  gösterim bilinen kişi izinleri ve görünür ekip üyeleridir. Farklı cihaz/sonraki
  oturum için eksiksiz kişisel izin envanteri iddiası yoktur. Dinamikten geçişte
  listelenen kişilerin izinlerini değiştirme açık ürün onayıyla yapılır; bilinmeyen
  eski kişisel izinler sessizce korunmuş gibi gösterilmez.

Kanıt: telefon 390×844 / tablet 1180×820 üzerinde toplu seçimin korunması, farklı
kişisel izin, kişi çıkarma, yönetici adayının otomatik seçilmemesi, mevcut dinamik
paylaşımda geçiş önizlemesi ve iptal; iş planında kayıp makbuz, kısmi hata ve kapsam
değişimi. Geniş tekrar koşumunda 164 test geçti. Hedefli analiz temiz; 66 dosyalık
mimari/API/hata kapısı 0 ihlal; boyut testi ve git diff --check temiz. Hata envanteri
araçla yenilendi. Canlı tablolar/izinler test amacıyla değiştirilmedi. CI/push yok.

## 16 Kasım — koordinatörlük seçimi ile kişi listesinin ayrılması

Kişi/yetki paneli seçili koordinatörlük satırının içinde açıldığı için altta kalan
koordinatörlük satırları Kişi ekle listesinin devamı gibi görünüyordu. Koordinatörlük
seçimi tek `NzSelect` satırına taşındı; diğer seçenekler yalnız standart flyout
menüsünde açılır. Seçili koordinatörlüğün erişim/kişi paneli seçiciden sonra bir kez
çizilir. Koordinatörlük değişiminde eski ekibe özel kişiler ayıklanır, iki ekipte de
geçerli kişi seçimleri korunur; dinamik kip ve ekip araması sıfırlanır.

Telefon/tablet akışları, konum değişiminde kişi süzme ve hedef kapsamda gerçek
create/grant çağrısı, eski oluşturma/rol akışları ve boyut testinde 32 test geçti.
Hedefli analiz ve git diff --check temiz. İki debug simülatöre hot reload gönderildi.

## 16 Kasım — bağlı hücre sheet'inden tabloya yönlendirme

Tablo bağlantısı hücresinin sheet'inde kayıtlı ve görünür hedefler standart menü
satırlarıyla açılır. Tekli/çoklu referansta her hedef ayrı eylemdir. Sheet kapanır,
kaynak hücre presence seçimi bırakılır ve ortak NzAppNav ile hedef tabloya gidilir;
bu eylem taslağı kaydetmez ve hücre yazımı göndermez. Hedefin güncel erişimini normal
workspace okuması tekrar denetler; erişim kaldırılmışsa hata görünümü gösterilir.

Navigasyon adları snapshot references.tables haritasından kimlikleriyle taşınır;
görünen hücre metni bölünmez, ham kimlik etiketi üretilmez. Null/redakte öğeler ve
adı çözülmeyen hedefler eylem oluşturmaz; kısmen redakte çoklu hücrede görünen hedefler
korunur. Bağlantı seçicisi, görev kataloğunu gereksiz yere beklemeden erişilebilir
tablo listesini kullanır. API/pin değişmedi.

Telefon/tablet tekli ve çoklu yönlendirme, adında ayırıcı bulunan tablo, gizli/çözümsüz
hedefin gösterilmemesi, yönlendirmede yazmama ve erişimin sonradan kaybı sınandı.
İki kapsam için API'den kimlik/ad haritası aktarımı ayrıca sınandı. Tekrar koşumunda
173 test geçti; hedefli analiz temiz; boyut ve git diff --check temiz. İki debug
simülatöre hot reload gönderildi. Canlı veride izin/hücre değişikliği yapılmadı.

## 16 Kasım — ortak arama alanı görünümü ve koordinatörlük başlığı

Tablo oluşturma, sütun/hücre düzenleme, paylaşım, yorum, sorgu ve klasör formları,
sayfa aramasının ortak yüzey/çerçeve/yazı/iç boşluk stilini kullanır. Tek satırda
hap biçimi, çok satırda yuvarlatılmış alan korunur. NzTextField için opt-in pill
seçeneği eklendi; diğer modüllerin varsayılan görünümü değişmedi. Arama alanları
NzSearchField kullanır. Sayı hücrelerinde işaretli/ondalıklı giriş ve mevcut
normalizasyon, doğrulama ve sunucu hataları korunur.

Koordinatörlük içindeki tablo listesinde genel Tablolar başlığı ve yinelenen alt
başlık kaldırıldı. Koordinatörlük adı/sayı ve arama, görünüm-sıralama, oluşturma
kontrolleri ortak başlıktadır. Birleştirilmiş filtre menüsünde klasör işlemleri,
yetkiye göre onay bekleyenler ve son açılanlar da bulunur. Üstteki menü aşağı
açılır; tablette geri eylemi gizlenen topbar yerine başlıkta kalır. Görünüm/sıralama
durumu başlık ve liste arasında kapsamla sınırlı provider üzerinden paylaşılır.
API ve pin değişmedi.

Telefon/tablet koordinatör ve üye akışları; menüden sıralama, klasör yönetimi yetkisi
ve aynı koordinatörlükte oluşturma dahil 208 test geçti, 2 opt-in golden atlandı.
Hedefli analiz temiz; mimari taramada 69 dosyada 0 ihlal; boyut testi ve diff kontrolü
geçti. iPhone/iPad hot reload başarılı. Canlı simülatörde başka modülün açık formuna
müdahale edilmedi; tablo görünümleri widget/taşma akışlarında kontrol edildi.

### Durum segmentinin kaldırılması

Tablo detayından Tümü/Açık/Tamamlanan segmenti ve ona özel filtre kodu kaldırıldı;
satır sayısı, sütunlar ve yeni satır eylemleri tek satırda kaldı. Demo görünümüne de
aynı değişiklik uygulandı. Hedefli analiz ve diff kontrolü temiz. Telefon/tablet
akış testlerinin derlenmesi, eşzamanlı görev modülü değişikliklerindeki eksik
AppLocalizations getter'ları nedeniyle engellendi (uiTasksPreviousDue vb.);
bu koşum test sonucu üretmedi ve simülatör yenilemesi yapılmadı.

## 16 Kasım — sabit kart önizlemesi ve şablon hizası

Tablo kartları başlık + üç satırlık sabit önizleme, tablo adı, satır/sütun bilgisi
ve bilinen kişi avatarlarıyla düzenlendi. Boş/az satırlı kartlar aynı önizleme
alanını korur. Kart adında kompakt bodyLg/600 kullanılır. Hızlı başlangıç şeridi
NzPaneScope.sideInset ile tablo listesiyle aynı noktadan başlar; kenara kadar
kaydırılma korunur. Gerçek tablolar için kendi program/departman kapsamında üç
satırlık salt okunur workspace çağrısı yapılır; presence/SSE açılmaz. Sayfalı
sonuç sayısı 3+ gibi gösterilir; sunucuda olmayan toplam/son düzenleme zamanı veya
tam erişen kişi listesi uydurulmaz. Önizleme hatası kartı açmayı engellemez.

Liste/rol/klasör/oluşturma ve boyut akışlarında 30; önizleme kapsam/okuma testinde
1; telefon/tablet 0/1/3 satır taşma ve tarih karşılaştırma testlerinde 6 test geçti.
Hedefli analiz, 71 dosyalık mimari kontrol ve diff kontrolü temiz. iPhone/iPad'e
hot reload gönderildi. Önceki iade isteği için bekleyen tarih talebinin yeni bitişi,
iade formunda mevcut bitişe ek olarak gösterilir; tamamlanmış talepler gösterilmez.

## 16 Kasım — hücre doğrulama ve sabit kayıt yerleşimi

Telefon ve e-posta hücrelerinde biçim uyarısı ve kaydetme engeli eklendi. Telefon
7–15 rakam, en başta isteğe bağlı + ve dengeli parantez/boşluk/tire kabul eder;
e-posta yerel bölüm ve alan adı biçimini denetler. Kenar boşlukları yazmadan önce
kırpılır. Boş hücreler isteğe bağlı kalır. Ortak taslak denetimi yeni satır ve hücre/
satır düzenlemede sayıların tam ondalık ve tarihlerin gerçek takvim günü olmasını
da doğrular. Sunucu doğrulaması ve CAS/idempotency korunur; backend/pin değişmedi.

Tamamlandı hücresi ortak NzCheckCircle kullanır; gridin tek dokunma kapısı ve
checkbox semantiği korunur. Normal yazma sırasında geçici pending bandı gridin
üstüne eklenmez; belirsiz sonuç/hata kurtarması görünür kalır. Geri al düğmesi üst
araç çubuğuna taşındı; ilk başarılı hücre yazımı gridin üstünde satır açmaz.

Telefon/tablet hatalı iletişim hücresinin yazılmaması, düzeltince tek atomik hücre
kaydı, yavaş yazma boyunca ve sonrasında gridin konumunu koruması, mevcut satır/
sütun/çatışma/rol akışları ve boyut denetimi: 25 test geçti. Mimari taramada 72
dosyada 0 ihlal; hedefli analiz ve diff kontrolü temiz. İki simülatöre hot reload
gönderildi. Kart boyutunun önceki değişimi nedeniyle test açılış yardımcısı kart
başlığını alt navigasyonun üstüne kaydırarak açar.

## 16 Kasım — bağlı deneme tabloları ve satır sayısı

Operasyon kapsamındaki iki geliştirme tablosu yalnız API üzerinden güncellendi:
Fuar alanı vardiya planı 30 satır/13 sütun; Vardiya devir kontrol listesi 20 satır/
5 sütun. Var olan satır kimlikleri, sahiplik, erişimler ve ekler korunur; yeni
satırlar eklendi, adlar ve deneme içerikleri görev noktası/saat, görevli sayısı,
örnek iletişim ve devir kontrol adımlarıyla değiştirildi. İki yönde tablo referansı
var. 422 ile reddedilen ilk atomik batch'te attachment hücresine set_cells
uygulanmadı; tekrar koşum ekleri dışarıda bıraktı ve iki snapshot tekrar okundu.
Önceki deneme snapshot'ları yerelde /tmp/nizam-table-sample-original.json'dadır.

Kartlar satır sayısı için 100 satırlık ilk sayfayı okur, yalnız 3 satır çizer;
100 üstündeki sonuç + ile açıkça sınırlanır. Bu iki kart artık 30/20 gösterir.
Detay sayfasında satır sayısı tek satır tutulur. Önizleme kapsam/önbellek, kart
telefon/tablet taşması ve hücre kaydında yerleşimin sabitliği: 6 test geçti.
Hedefli analiz ve diff kontrolü temiz. Hot reload eski provider sonucunu koruduğu
için iki debug simülatörde hot restart yapıldı; her iki restart tamamlandı.

## 16 Kasım — kompakt detay başlığı ve satır numarası kaydırması

Tablo adı standart detail appbar'a taşındı. Appbar'daki paylaşım standart SVG ikon
eylemi oldu; kişi avatarları gövdedeki kimlik satırına taşındı. Oluşturan kişi üstte,
koordinatörlük hemen altında; gövdede ikinci büyük tablo başlığı yok. Bağlı tablo,
meta bilgi ve satır/işlem alanındaki dikey boşluklar daraltıldı. Tablet paneLead 8.

Sütunları tablette sezgisel olarak daraltıp yatay kaydırmayı kaldıran ölçekleme
kaldırıldı. Saklanan sütun genişlikleri korunur; # başlığı ve satır numaraları bütün
hücrelerle aynı yatay scroll viewport'undadır. Telefon/tablet regresyonu numara
üzerinden sürükleyip numara/başlık/veri hücresinin aynı miktarda kaydığını ve satır
editörünün yanlışlıkla açılmadığını denetler. Başlık/paylaşım/kolon/satır akışları,
yavaş yazmada konum ve validasyonla birlikte 16 test geçti. Analiz, 72 dosyalık
mimari tarama ve diff kontrolü temiz. İki simülatöre hot reload gönderildi.

## 16 Kasım — appbar'da paylaşım profil grubu

Paylaş SVG düğmesi yerine en fazla üç kişinin dairesel profil grubu kullanılır.
Grubun tamamı standart küçülme tepkili ve en az 48 yüksekliğinde tek paylaşım
butonudur; aynı workspaceSharing ekranını açar. Ekran okuyucu etiketi Paylaş,
açıklaması kişi/yetki düzenlemedir. Gövdedeki avatar tekrarı kaldırıldı.

Sahip, bilinen doğrudan paylaşımlar, dinamik ekip rolünde görünen ekip üyeleri ve
presence kişileri hesap kimliğine göre birleştirilir. Renkler mevcut rol tonlarıdır;
ad çözülemezse anonim profil glyph'i paylaşım eylemini erişilebilir tutar. Backend
ACL listeleme eksikliği nedeniyle bilinmeyen doğrudan grant'ler uydurulmaz.
Telefon/tablet grup üzerinden paylaşım açma ve ekip yetkisi değiştirme dahil 12
test geçti; hedefli analiz/diff kontrolü temiz. İki simülatöre hot reload gönderildi.

## 16 Kasım — sütun sürükleme proxy hatası

Sütunlar sheet'indeki özel reorder proxy, satırı kök overlay'e taşırken sheet'in
Material altyapısını kaybediyordu; satır içindeki NzTap/InkWell bu nedenle
No Material widget found hatası veriyordu. Proxy'ye şeffaf Material host eklendi;
görünüm, yüzey rengi, köşe ve sıralama komutu korunur, elevation/splash eklenmez.

Yeni telefon/tablet gerçek gesture testi sürükleme devam ederken hatayı yakalar:
düzeltme öncesi iki cihazda No Material ile başarısız, sonrasında temiz. Drop tek
move komutu gönderir; sıra backend makbuzu/snapshot ile güncellenir ve sheet yeniden
açılabilir. Mevcut sütun ekranı/iptal/gizleme akışlarıyla 4 test geçti. Hedefli
analiz ve diff kontrolü temiz; iki simülatöre hot reload gönderildi.

## 16 Kasım — bağlı tablodan önceki tabloya geri dönüş

Aynı türde başka kayıt açılışı splitMove içinde tabanı değiştiriyordu; bağlı tablo
kaynağın yerine geçiyor ve Geri listeye dönüyordu. Açık tablo içinden gezinme için
openLinkedTable niyeti eklendi: kaynak rotası kalır, hedef trail'e kimliğiyle eklenir.
Başlık/hücre bağlantıları aynı niyeti kullanır. Liste seçimi openTable ile taban
seçmeye devam eder. Daha önceki hedefe bağlantı döngü üretmez, mevcut izi kısaltır.
Başka modülden açılmış tablo zinciri o modülün kaynağını da korur.

Başlıktaki bağlantı etiketleri de display metnini ayırmak yerine backend'in görünür
tablo kimlik/ad haritasından alınır; adında ayırıcı olan hedef doğru açılır.
Düzeltme öncesi geri testi dört telefon/tablet tekli/çoklu akışta kaynak yerine
listeye dönerek başarısızdı. Sonrasında hücre ve başlık geçişi, iç içe zincir,
appbar/sistem geri, döngü, çapraz modül izi ve diğer router testleri: 46 test geçti.
Hedefli analiz, boyut testi ve diff kontrolü temiz. İki simülatöre hot reload gönderildi.

## 16 Kasım — yüklenirken bilinen başlık ve platform göstergesi

Tablo detayının appbar'ı snapshot gelene kadar liste kataloğunda zaten bilinen tablo
adını kullanır; snapshot'taki güncel ad geldiğinde yetkili adla yenilenir. Rotalar
hâlâ yalnız kimlik taşır. Katalogda adı olmayan doğrudan bağlantıda normal Tablo
bekleme etiketi korunur; başka hesap/kapsamdan ad taşınmaz.

Ortak NzLoader iOS/macOS'ta CupertinoActivityIndicator, diğer platformlarda mevcut
Material göstergesi kullanır. Boyut, tema rengi ve erişilebilir yükleniyor etiketi
korunur. Tablolar modülündeki doğrudan CPI kullanımları bu ortak bileşene taşındı.
Telefon/tablet geciktirilmiş snapshot'ta başlığın önce görünmesi ve güncel adla
yenilenmesi, Android/iOS gösterge seçimi ve mevcut link/hücre/sütun akışlarında
21 test geçti; 1 opt-in golden atlandı. Hedefli analiz, boyut ve diff kontrolü temiz.
İki simülatöre hot reload gönderildi.

## 16 Kasım — kademeli ilk yükleme ve sabit geri dönüş

Detay ilk istekte 20 satır ister ve yanıtı hemen gösterir. Devam imleci varsa ilk
sayfa arka planda tek, tutarlı 100 satırlık snapshot ile genişletilir; farklı
sequence değerlerinden sayfalar birleştirilmez. Daha büyük tablolar mevcut imleçli
sayfalama ile ilerler. Backend okuma bütçesi daha küçük sayfa gerektiriyorsa küçük
sayfa korunur. Ağ hatasında gösterilen satırlar kalır, yeniden deneme sunulur;
erişim reddinde veri kapatılır. Sorgu/yazma/kapsam değişikliği sırasında geciken
arka plan yanıtı yeni durumu ezemez. Yükleme sürerken ilk satırlar düzenlenebilir.

Table pane'e geri dönüşte bütün appbar ve içeriği sağa taşıyan pop geçişi kapatıldı;
diğer sayfaların geçişleri korundu. Telefon/tablet kademeli görünürlük, geçiş
sırasında appbar konumu, sorgu/yazma yarışları, hata/erişim/bütçe, sayfalama ve
controller kontrollerinde 26 test geçti. Hedefli analiz temiz, 73 dosyalık mimari
kontrolde sıfır ihlal, dosya boyutu ve diff kontrolü temiz. Backend sözleşmesi
ve uçlar değişmedi. İki simülatöre hot reload gönderildi.

## 16 Kasım — sütun tipi, yorum okuması ve kayıt sırasında sabit eylem

Sütun başlığından açılan detayda Tip satırı ortak NzFormRows pill radiusunu
kullanır; tür değişikliği doğrudan satırdan açılır, genişlik eylemi ayrıca korunur.
Appbar seçenek ikonu diğer detay sayfalarındaki dikey NzIcons.more oldu.
Yeni satır eylemi yazma/yeniden okuma kilidi sırasında yerini ve opaklığını korur;
çift yazmayı engelleyen devre dışı durumu sürer.

Yorum okumasında üretilmiş TableComment.author alanının başka bir Author enum'una
bağlandığı görüldü. Sözleşmenin nullable {id,name} nesnesi core/http/table_wire.dart
üzerindeki dar uyarlamayla okunur; üretilmiş dosyalar ve backend değişmedi.
Repository domain eşlemesi ve üretilmiş kapsam/operationId metaverisi korunur.
Gizli yazar null kalır, bozuk yazar yanıtı hata verir. Hata varken boş yorum mesajı
gösterilmez. Kişisel/koordinatörlük HTTP eşlemesi, görünür/gizli/bozuk yazar,
telefon/tablet yorum ekleme-düzenleme ve mevcut tablo akışlarında 93 test geçti.
Hedefli analiz temiz, 73 dosya mimari kontrolünde sıfır ihlal, boyut ve diff temiz.
İki simülatöre hot reload gönderildi; mobil CI kota kuralı gereği tetiklenmedi.

Sütun genişliği ayarı ürün sahibi isteğiyle arayüzden ve ilgili form dalından
kaldırıldı; mevcut sütun genişlikleri korunur. Hedefli analiz ve diff kontrolü temiz.
İki simülatöre hot reload gönderildi.
