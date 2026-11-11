# Firebase kurulumu ve uzaktan kontroller

2026-11-11 ürün sahibi Firebase projesini oluşturdu; reverse-domain uygulama kimlikleri
kabul edildi. Gerçek proje kimliği ve istemci yapılandırmaları henüz bu çalışmaya verilmedi.

## Uygulama kayıtları

| Ortam | Android applicationId | iOS bundle ID |
|---|---|---|
| Geliştirme | `io.nizamio.mobile.dev` | `io.nizamio.mobile.dev` |
| Canlı | `io.nizamio.mobile` | `io.nizamio.mobile` |

Android namespace ve Kotlin paketi `io.nizamio.mobile` olur; `.dev` yalnız geliştirme
applicationId ekidir. iOS `dev` ve `prod` şemaları Debug/Profile/Release yapılandırmalarını
ayırır. Eski `Runner` şeması uyumluluk için prod kimliğinde kalır; geliştirmede `--flavor dev`
kullanılır. İmzalama hesabı veya push yetkisi bu kimlik değişikliğiyle verilmiş sayılmaz.

Firebase Console'da oluşturulan projeyi önce geliştirme ortamı olarak kullanmak,
canlı ortam için ayrı proje açmak önerilir. Proje seçimi henüz otomatik yapılmadı.

1. Project overview → **Add app → Android**. Android package name alanına
   `io.nizamio.mobile.dev`; nickname alanına `NIZAM.IO Android Dev` yazılır.
   Temel FCM/Remote Config kaydı için SHA sertifikası bu aşamada gerekmez.
2. Register app → **Download google-services.json**. Bu geliştirme kaydına ait dosya
   Android'de `android/app/src/dev/google-services.json` konumuna bağlanacak.
3. Aynı projede **Add app → iOS+**. Bundle ID `io.nizamio.mobile.dev`; nickname
   `NIZAM.IO iOS Dev`. App Store ID geliştirme kaydı için boş kalabilir.
4. **GoogleService-Info.plist** indirilir. iOS'ta doğru flavor'a ait dosyanın derlemeye
   girmesi gerekir; dev dosyası tüm prod derlemelere ortak kopyalanmaz.
5. Yapılandırma dosyaları alınca proje/uygulama kimlikleri doğrulanır; FlutterFire ile
   platform seçenekleri ve Gradle/Xcode bağlantısı tamamlanır. Yalnız dosyayı indirmek
   veya klasöre koymak Firebase'i başlatmaz. Bu bağlantı ve başlatma henüz yapılmadı.
6. Prod için karşılık gelen canlı proje/kayıtlar `io.nizamio.mobile` kimliğiyle oluşturulur.

Firebase'deki uygulama kaydının paket/bundle kimliği sonradan düzenlenmez; kimlik değişirse
yeni kayıt ve yapılandırma gerekir. Apple'da App Store Connect'e ilk build yüklendikten
sonra aynı uygulama kaydının bundle ID'si değiştirilemez; bu sınır TestFlight için de
önemlidir. Kurum kimliği mağaza/Apple kaydıyla ayrıca doğrulanmalıdır.

Apple Developer Program üyeliği Firebase'e iOS kaydı eklemek için gerekmez. Gerçek iOS
push teslimi için APNs yeteneği ve kimlik bilgileri gerekir. İndirilen istemci JSON/plist
dosyaları, backend servis hesabı JSON'u veya APNs özel anahtarı değildir; servis hesabı
ve APNs anahtarı mobil uygulamaya gömülmez.

## Hazırlanan kontroller

`MobileReleasePolicy`, Firebase SDK'sından bağımsız karar mantığıdır.
`FirebaseReleasePolicySource` açıkça verilmiş Remote Config örneği üzerinden ayarları
okur. Bileşim kökü varsayılan olarak kapalı kaynak verir; uygulama açılışında Firebase
başlatılmaz veya Remote Config isteği yapılmaz. Güncelleme ekranına bağlantı henüz yoktur.

| Remote Config parametresi | Tür | Varsayılan / anlam |
|---|---|---|
| `android_minimum_version` | String | Boş: ek zorunlu sürüm sınırı yok |
| `android_minimum_build` | Number (tam sayı) | `0`; minimum sürümle birlikte değerlendirilir |
| `android_recommended_version` | String | Boş: isteğe bağlı güncelleme önerisi yok |
| `android_recommended_build` | Number (tam sayı) | `0`; önerilen sürümle birlikte değerlendirilir |
| `ios_minimum_version` | String | Boş: ek zorunlu sürüm sınırı yok |
| `ios_minimum_build` | Number (tam sayı) | `0` |
| `ios_recommended_version` | String | Boş: isteğe bağlı güncelleme önerisi yok |
| `ios_recommended_build` | Number (tam sayı) | `0` |
| `native_push_enabled` | Boolean | `false`; izin/oturum/cihaz kaydı şartlarının yerine geçmez |
| `crash_reporting_enabled` | Boolean | `false`; henüz SDK toplamaya bağlanmadı |
| `analytics_enabled` | Boolean | `false`; henüz SDK toplamaya bağlanmadı |

Sürümler `MAJOR.MINOR.PATCH` biçimindedir. Build ayrı, negatif olmayan tam sayıdır;
sürüm boşken build sınırı verilemez. Önerilen sürüm/build açıkça minimumdan düşükse
ayar kümesi reddedilir. Bozuk tipler, negatif sayılar ve bilinmeyen sürüm biçimleri
kararı sessizce gevşetmez; aday reddedilir. Çalışan sürüm veya backend asgari sürümü
geçersizse sonuç `incompatible` olur.

Örnek: çalışan `0.2.0+2`, minimum `0.2.0`/build `2`, önerilen `0.3.0` ise isteğe bağlı
güncelleme; minimum `0.3.0` ise zorunlu güncelleme çıkar. Sürümü mağazada gerçekten
erişilebilir yapmadan minimumu yükseltmek kullanıcıları güncelleme ekranında bırakır.

Backend `minimum_mobile_version` ve API uyumu denetimi korunur. Remote Config bu
denetimleri kapatamaz. Firebase platform minimumu backend minimumundan daha yüksekse
ek ürün sürümü sınırı oluşturabilir; daha düşükse backend sınırı geçerlidir.

Adaptör, SDK'nın etkinleştirilmiş önbelleğini ağdan önce okur; çekme zaman aşımı 8 saniye,
asgari çekme aralığı 12 saattir. Bu nedenle konsoldaki değişiklik tüm cihazlarda anında
uygulanır diye kabul edilmez. Ağ/ayar hatasında aynı süreçte son geçerli politika korunur.
SDK etkinleştirilmiş ayarları saklar; **geçersiz ayar etkinleştirilmişse önceki doğrulanmış
politikanın süreçler arası ayrı kopyası henüz yoktur**. Bu durumda yeni açılışta yerel
varsayılan kullanılabilir; backend güvenlik/uyumluluk kapısı yine uygulanır. Gerçek
zorunlu güncelleme UI bağlantısından önce bu kalıcılık ve eskime politikası tamamlanmalıdır.

## Sıradaki bağlantılar

- Doğrulanmış dev/prod dosyaları, flavor'a göre Firebase başlatma ve hatada uygulama
  açılışını kilitlemeyen durum bildirimi.
- Zorunlu güncelleme ekranı, isteğe bağlı güncelleme bottomsheet'i ve güvenilir mağaza
  hedefi. Platforma göre sürüm/build okunması, ön plana dönüşte kontrollü yenileme.
- Remote Config geçerli politika kalıcılığı ve eskime kararı; güncelleme ekranı bu
  karara bağlanmadan gerçek bir Firebase zorunlu güncelleme kapısı çalışıyor sayılmaz.
- Native push bayrağının oturum/izin/kayıt mekanizmasına bağlanması; bildirim kapsamı
  ve mesaj içeriği politikası backend'de. [Native push planı](native-push-altyapisi.md).
- Crashlytics için redaksiyon ve kullanıcı tercihi; Analytics için kişisel veri içermeyen
  onaylı olay şeması. Remote Config'te `true` yayınlamak bu kontrolleri atlamayacak.

Bu dilim Crashlytics hata kancası, Analytics olay gönderimi veya gerçek push teslimi
eklemez. Remote Config parametrelerine erişim/yenileme belirteci, parola, sunucu adresi
ve kişisel veri konmaz. Firebase kontrolleri uygulama yetkilendirmesi yerine kullanılmaz.

## Komutlar

```sh
flutter run --flavor dev -t lib/main_dev.dart
flutter build ios --simulator --debug --flavor dev -t lib/main_dev.dart
flutter build ios --simulator --debug --flavor prod -t lib/main_prod.dart
```

## Resmî kaynaklar

- [Flutter Firebase kurulumu](https://firebase.google.com/docs/flutter/setup)
- [Android uygulama kaydı](https://firebase.google.com/docs/android/setup)
- [Flutter Remote Config](https://firebase.google.com/docs/remote-config/flutter/get-started)
- [Apple bundle ID değişikliği](https://developer.apple.com/documentation/xcode/changing-the-bundle-identifier)
