# Native push — ilk mobil altyapı dilimi

Ürün sahibi isteği: 2026-11-11. Çalışma mesajlaşma dalında yürütülür.
Bu dilim UI ve gerçek teslimat açmadan native bildirim için test edilebilir mobil
temeli hazırlar. Mevcut uygulama içi çan ve ön plana dönüş tazelemesi çalışmaya devam eder.

## Mevcut durum

| Parça | Durum |
|---|---|
| Android/iOS izin, token ve token yenilenme portu | Hazır |
| Firebase Messaging adaptörü | Hazır; ancak açıkça yapılandırılmış SDK örneğiyle kullanılabilir |
| Ön plan bildirimi, arka plandan dokunuş, kapalı uygulamadan ilk bildirim | Adaptör olayları hazır; henüz uygulama tüketicisine bağlanmadı |
| Hesap/kurulum/oturum bazında kayıt yaşam döngüsü | Denetleyici ve yarış testleri hazır; gerçek repository bekliyor |
| Varsayılan uygulama bağı | Kapalı adaptör; Firebase başlatılmaz, izin istenmez, token alınmaz |
| Cihazda OS bildirimi / kapalı uygulamaya gerçek teslim | Henüz yok |

Firebase bağımlılıkları zaten depodaydı. SDK yalnız `lib/app/notifications/` altında
kalır; core portları Firebase tanımaz. get_it sahipliği ve Riverpod portu mevcut DI
kararını korur. Android ve iOS'ta FCM otomatik başlatma, analytics ve Crashlytics toplama
kapalı tutulur. Bu bayraklar, daha önce çalışma anında açılmış otomatik başlatmayı
tek başına sıfırlamaz; etkinleştirme işi bunu ayrıca ele almalıdır.

## Hazırlanan mekanizma

1. Bileşim kökü varsayılan olarak `DisabledPushNotifications` verir. Yapıcılar izin
   penceresi açmaz. Yapılandırılmış Firebase adaptörü ileride açıkça enjekte edilir.
2. Açık kullanıcı tercihiyle `PushRegistrationController.enable(owner)` çağrılır.
   İzin reddedilirse cihaz tokenı okunmaz ve sunucuda kayıt yapılmaz.
3. İzin varsa token alınır. iOS'ta APNs tokenı henüz yoksa FCM token isteği yapılmaz;
   token yenilenme olayı veya sonraki açık etkinleştirme denemesi beklenir.
4. Kayıt portu tokenı Android/iOS platformu ve güncel kurulum/hesap/oturum sahibine
   bağlar. Token yenilenirse eski kayıt kaldırılır ve yeni token kaydedilir.
5. Çıkış, sunucu değişimi ve oturum iptalinde tüketici **kimlik bilgilerini silmeden önce**
   `disable()` çağırmalıdır. Yerel sahiplik hemen düşer. Geç tamamlanan kayıt yanıtı
   eski sahibin kaydı olarak silinir; yeni hesaba taşınmaz.
6. Başarısız silmeler bellekte tutulur, sonraki açık işlemde tekrar denenir. Süreç
   kapanması/ağ kesilmesi uzaktaki kaydın silindiğini garanti etmez. Bu nedenle backend
   kaydı oturum ömrüne bağlamalı ve çıkış/iptalde sunucudan geçersiz kılmalıdır.

Kayıt denetleyicisi henüz uygulamanın gerçek oturumuna bağlanmaz; authoritative native
API bulunmadığı için sahte HTTP çağrısı veya başarılı kayıt gösterimi yoktur. Sistem
bildiriminden gelen veri güvenilir yönlendirme komutu değildir: adaptör yalnız string
verileri taşır; URL açmaz, kapsam değiştirmez ve sohbet açmaz. Kullanıcıya gösterilen
uygulama durumu, doğrulanmış sunucudan tekrar okunmalıdır.

## Sonraki dilimler ve kabul ölçütleri

### 1. Backend sözleşmesi ve mesaj olayı

Backend `notifications` bugün VAPID/web push `endpoint/p256dh/auth` kabul eder.
Bu uçlara FCM tokenı gönderilmeyecek. Backend `messaging` MESSAGING-K24 kuralı mesaj
bildirimi üretimini açıkça kaldırmıştır; bunu değiştiren backend işi gereklidir.
Bu mobil çalışmada backend ve yönetim deposu değiştirilmez.

Native kayıt sözleşmesi şu davranışları tanımlamalıdır: oturumdan türetilmiş sahiplik
(istemci account id'sine güvenilmez), idempotent token güncelleme, kendi kaydını silme,
tokenın farklı hesaba taşınması, oturum iptalinde teslimin kesilmesi, kalıcı geçersiz
FCM tokenının düşürülmesi ve sağlayıcı yeniden deneme kuralları. Geçici FCM hatalarında
kayıt kaybolmamalı. Kayıt silme portunun eski sahibini taşıması yetki değildir;
gerçek repository güncel erişim belirtecini eski sahibin yerine kullanmamalıdır.

Mesaj alıcıları: gönderenin dışlanması, sohbet üyeliği/yetkisi, kapalı veya silinmiş
sohbetler, anılmalar, sessize alma tercihi ve çift teslim kararı backend'de netleşmeli.
OS kilit ekranı için ilk öneri genel bir başlıktır: mesaj metni, kişi adı, dosya adı ve
sunucu adresi sağlayıcı yüküne konmaz. Rota yerine opak bildirim/kayıt kimliği önerilir;
nihai payload backend sözleşmesinde tanımlanır. Mobil burada şema icat etmez.

### 2. Dağıtım yapılandırması

Dev/prod uygulama kimliklerine uygun Firebase projeleri ve yapılandırma dosyaları,
Apple push yeteneği/provisioning/APNs anahtarı ve Android FCM sunucu kimliği gerekir.
FCM servis hesabı ve APNs özel anahtarı mobil uygulamaya gömülmez. Firebase başlatma
başarısızlığı uygulama girişini kilitlememelidir. Analytics/Crashlytics bu işle beraber
kendiliğinden açılmaz. Android bildirim kanalı/simge ve Android 13+ izin davranışı;
iOS yetkiler ve fiziksel cihaz teslimi bu dilimde doğrulanacak.

### 3. Oturum, UI ve dokunuş bağlantısı

Kayıt denetleyicisi giriş/çıkış/kurulum değişimiyle birleştirilecek. İzin açıklaması ve
bildirim tercihi ortak UI bileşenleri ve `AppPreferences` üzerinden sunulacak. Varsayılan
başlangıç otomatik izin istemeyecek. Foreground olayı çan/mesaj rozetini mevcut
tazeleme mekanizmalarıyla güncelleyecek; aktif sohbet için çift uyarı önlenecek.

Uygulama her açılışta giriş istediği için kapalı uygulamadan dokunuş hedefi bellekte
sınırlı süre bekletilmeli; doğru sunucu ve hesap doğrulanınca backend'den çözülmelidir.
Başka hesaba ait, süresi geçmiş, yinelenen veya yetkisiz bildirim sohbet açmamalıdır.
Telefon ve tablet mevcut tipli rota/split mekanizmasını kullanacak. İlk mesaj
(`getInitialMessage`) ve arka plan dokunuşu (`onMessageOpenedApp`) birlikte ele alınacak.

### 4. Uçtan uca teslim kanıtı

Fiziksel iPhone ve Android'de ön plan/arka plan/kapalı uygulama; izin ret/sonradan açma;
token yenilenmesi; çevrimdışı çıkış; hesap ve sunucu değişimi; silinmiş sohbet;
yinelenen bildirim ve gizli kilit ekranı içerikleri sınanacak. İşletim sisteminde
zorla durdurma ile normal arka plan/kapalı durum ayrılacak. Simülatör testleri tek
başına gerçek APNs/FCM teslim kanıtı sayılmayacak.

## Kaynaklar

- [FCM istemci kurulumu ve otomatik başlatma](https://firebase.google.com/docs/cloud-messaging/flutter/client)
- [Mesaj alma ve bildirime dokunma](https://firebase.google.com/docs/cloud-messaging/flutter/receive)
- [ADR-0002](../architecture/adr-0002-paketler-tercih-yerel-veri-firebase.md)

İlk dilimin yerel doğrulama sonuçları `docs/reviews/native-push-altyapisi-kalite.md`
dosyasında tutulur. Native teslim ve CI yeşili olmadan yayın hazır kabul edilmez.
