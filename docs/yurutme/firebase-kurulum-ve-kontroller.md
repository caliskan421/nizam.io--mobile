# Firebase kurulumu ve uzaktan kontroller

2026-11-11 ürün sahibi Firebase projesini oluşturdu; reverse-domain uygulama kimlikleri
kabul edildi. Kullanıcının verdiği Android/iOS istemci yapılandırmaları doğrulandı:
proje `nizamio-mobile`, iki platformda geliştirme kimliği `io.nizamio.mobile.dev`.

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
   veya klasöre koymak Firebase'i başlatmaz. Dev bağlantısı ve Dart başlatması tamamlandı;
   prod dosyaları henüz yok ve prod Firebase başlatması kapalıdır.
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
okur. Dev Android/iOS açılışında Firebase Core için en çok iki saniye beklenir; hata veya
süre aşımında kapalı portlarla giriş akışı sürer. Geç tamamlanan sonuç o koşumdaki
bileşime sonradan bağlanmaz. Başarılı dev başlatmasında ilk kareden sonra Remote Config
bir kez okunur ve `mobileReleasePolicyProvider` üzerinden reaktif olarak tutulur. Prod,
web ve masaüstü SDK'ya dokunmadan kapalı portlarla çalışır. Güncelleme kapısı `ReleasePolicyHost` ile uygulamanın navigator ağacının dışına
bağlıdır: zorunlu güncelleme derin bağlantı, açık ekran ve dialog dahil içeriği
kapatır; isteğe bağlı öneri sunucu doğrulandıktan sonra gösterilir ve o açılış
için ertelenebilir. Sonradan gelen zorunlu politika bu ertelemeyi dikkate almaz.

Güncel görünüm: `NzUpdatePage` ortak tam ekran kompozisyonudur; düğmeler alt güvenli alanın üzerinde, logo ve metinler önceki konumundan 50 dp aşağıdadır. Ekranda sürüm/build numarası gösterilmez; sürüm kararları değişmez.
İsteğe bağlı öneri yalnız “Daha sonra” ile ertelenir; çarpı kaldırılmıştır. Bu düğmede dalga ve küçülme efekti yoktur. Gizli form durumu korunur, odak ve klavye girdisi alamaz. Zorunlu kapıda kapatma/erteleme yoktur; backend/API gerekçeleri ayrı kalır.
Ana düğme “Şimdi güncelle” metnini kullanır. Mağaza hedefi varsa mağazayı açar; hedef yokken bağlantının hazır olmadığı açıklanır ve düğme politikayı yeniden okur. Zorunlu durumda eksik bağlantı açıklaması yöneticiye yönlendirir.

Android Google Services 4.5.0 eklentisi yalnız ilgili flavor dosyasını işler; kök dosyaya
fallback yapılmaz. Prod dosyası yoksa yalnız prod işleme görevleri kapanır ve bu
görevlerin eski üretilmiş kaynakları temizlenir. iOS build phase aynı biçimde flavor'a
ait plist'i seçer; bundle ID uyuşmazlığında derleme durur, prod dosyası yoksa eski dev
plist'i çıktıdan kaldırılır. Swift/SPM Firebase bağımlılıkları Flutter paketleriyle gelir;
konsoldaki yerel SwiftUI `FirebaseApp.configure()` veya elle SDK ekleme adımı tekrarlanmaz.
Flutter başlatması `Firebase.initializeApp()` ile native flavor yapılandırmasını kullanır.

FCM otomatik token üretimi, Analytics ve Crashlytics toplama kapalı kalır. Başlatma
bildirim izni istemez veya token okumaz; native kayıt repository'si ve backend mesaj
olayı henüz yoktur. Remote Config anahtarları `true` olsa bile bu dilim bunları otomatik açmaz.

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
asgari çekme aralığı release/profile derlemede 12 saat, dev debug derlemede
30 saniyedir. Bu nedenle konsoldaki değişiklik tüm cihazlarda anında
uygulanır diye kabul edilmez. Ağ/ayar hatasında aynı süreçte son geçerli politika korunur.
SDK etkinleştirilmiş ayarları yanında, yalnız doğrulanmış ve izinli anahtarları içeren
politika `AppPreferences.releasePolicy` üzerinden ayrı saklanır. Yeni açılışta bu
kopya ağ isteğinden önce yayınlanır; yeni/bozuk bir Firebase yayını önceki geçerli
minimumu silemez. Firebase başlangıcı hata/süre aşımı verirse dev mobil açılışında
aynı yerel kopya kullanılır. Kayıt bulunmaması kapalı varsayılandır; mevcut kaydın
okunamaması/bozukluğu kapıyı gevşetmek yerine hata ve yeniden deneme ekranıdır.
Yerel okuma/yazma beklemesi 500 ms ile sınırlıdır. Yazıların gerçek platform
sırası korunur; geç tamamlanan eski yazı yeni minimumun üzerine yazılamaz.
Yazma başarısızlığında o süreçteki geçerli politika korunur; diske yazılmamış yeni
politikanın sonraki açılışta geri gelmesi garanti edilmez.

Eskime kuralı: son geçerli minimum çevrimdışıyken süreyle düşürülmez. Daha düşük
minimum veya boş minimum ancak yeni, geçerli bir ayar kümesi kabul edilerek
uygulanır. Ön plana dönüşte en sık beş dakikada bir politika yeniden değerlendirilir;
Firebase SDK'nın release/profile için 12 saat, dev debug için 30 saniyelik ağ çekme
aralığı ayrıca geçerlidir. “Yeniden denetle”
bu SDK sınırını atlamaz; konsoldaki değişiklik anında tüm cihazlara ulaşmaz.
Backend minimumu/API uyumsuzluğu Firebase politikası kaldırıldığında da geçerlidir.

Apple native SDK bool varsayılanlarını `NSNumber.stringValue` ile `0`/`1` biçiminde
aktarır. Adaptör hem bu native biçimi hem `true`/`false` biçimini doğrulayıp tipli
bool'a çevirir; `yes` gibi bilinmeyen metinler hâlâ tüm adayı reddeder. Böylece yerel
kapalı telemetry/push varsayılanları geçerli bir sürüm önerisini yanlışlıkla elemez.
Gerçek cihaz/simülatör testi, SDK'daki iOS önerisini kabul edilen politikayla ve
native bool değerlerini politika bayraklarıyla karşılaştırır.

## Sürüm ve build yönetimi (2026-11-12)

Kaynak sürüm `pubspec.yaml` içindeki `version: 0.2.0+2` değeridir. `MAJOR.MINOR.PATCH`
ürün sürümü, `+2` dağıtım build numarasıdır. Hata düzeltmesi PATCH, geriye uyumlu
özellik MINOR, kırıcı ürün değişimi MAJOR artırır; mağazaya her yüklemede build
numarası monoton artırılır. Bu çalışma kendiliğinden yeni bir ürün sürümü tahsis etmez.

Çalışan Android/iOS paketin sürüm/build bilgisi `package_info_plus` ile native
metadata'dan okunur. Böylece `--build-name`/`--build-number` değerleri güncelleme
kararında ve gösterimde aynıdır. Backend `minimum_mobile_version` karşılaştırması
da aynı native sürümü alır; üretilmiş pubspec sabitine geri düşerek farklı bir
paketi uyumlu saymaz. Native metadata geçersiz/okunamazsa açık hata kapısı görünür;
kullanıcı uygulamayı yeniden açabilir. Web/masaüstü Firebase mobil kapısına girmez.

Örnek dağıtım derlemesi (örnek numaralar; yayımlama komutu değildir):

```sh
flutter build apk --release --flavor prod -t lib/main_prod.dart \
  --build-name=0.2.1 --build-number=3 --obfuscate --split-debug-info=build/symbols
```

Remote Config ürün minimumu backend minimumunu yalnız sıkılaştırır. Aynı ürün
sürümünün eski build'ini kapatmak için `*_minimum_version` ile birlikte
`*_minimum_build` kullanılır. Önerilen sürüm/build isteğe bağlı güncellemeyi belirler.

### Mağaza hedefleri ve ürün sahibinin adımları

Henüz mağaza kaydı yoktur. Hedef verilmezse mağaza açılmaz; bağlantının hazır
olmadığı açıklanır ve ana eylem politika bilgisini yeniden kontrol eder.
Android paket adına bakarak varsayımsal mağaza bağlantısı oluşturulmaz.

Mağaza kayıtları açılıp ilgili sürüm erişilebilir olduğunda prod derlemesine
`--dart-define=NIZAMIO_ANDROID_STORE_URL=<gerçek-Play-HTTPS-adresi>` ve/veya
`--dart-define=NIZAMIO_IOS_STORE_URL=<gerçek-App-Store-HTTPS-adresi>` verilir.
Yalnız `play.google.com/store/apps/details?id=io.nizamio.mobile` veya
`apps.apple.com/.../app/.../id<sayısal-kimlik>` biçimi kabul edilir. Kullanıcı bilgisi,
farklı port, fragment ve beklenmeyen sorgu parametreleri reddedilir. Bu hedefler
Remote Config'ten alınmaz. Dev uygulama kimliği prod mağazasına yönlendirilmez.
Açma başarısızlığı kullanıcıya gösterilir; yeniden deneme mümkündür.

Şu an ürün sahibinden işlem gerekmiyor. Canlıya geçişte sırasıyla:

1. Android/iOS mağaza kayıtlarını ve gerçek bağlantıları sağla; imzalı dağıtımı tamamla.
2. Prod Firebase istemci yapılandırmalarını ve prod etkinleştirmesini ayrı dilimde tamamla.
3. Sürüm mağazada hedef kullanıcılar için erişilebilir olduktan sonra önerilen sürümü yayımla.
4. Güncelleme yolu cihazda doğrulandıktan sonra gerekliyse minimum sürümü artır.

Mağaza erişimi hazır olmadan minimum yükseltilmez. Prod Firebase halen kapalıdır;
bu çalışma yalnız hazırlanmış dev bağlantısına politika UI'sını ekler.

## Sıradaki bağlantılar

- Prod istemci dosyaları ve prod Firebase etkinleştirmesi.
- Native push bayrağının oturum/izin/kayıt mekanizmasına bağlanması; bildirim kapsamı
  ve mesaj içeriği politikası backend'de. [Native push planı](native-push-altyapisi.md).
- Crashlytics için redaksiyon ve kullanıcı tercihi; Analytics için kişisel veri içermeyen
  onaylı olay şeması. Remote Config'te `true` yayınlamak bu kontrolleri atlamaz.

Bu dilim Crashlytics hata kancası, Analytics olay gönderimi veya gerçek push teslimi
eklemez. Remote Config'e erişim/yenileme belirteci, parola, sunucu adresi ve kişisel
veri konmaz. Firebase kontrolleri uygulama yetkilendirmesi yerine kullanılmaz.

## Yerel doğrulama (2026-11-12)

Aşağıdaki testler ilgili dilimlerde koşuldu. Son kullanıcı taleplerindeki alt yerleşim, çarpının kaldırılması, ana düğme etiketi ve efektsiz “Daha sonra” düzenlemelerinden sonra kullanıcının talimatıyla testler yeniden çalıştırılmadı; son iOS dev derlemesi başarılı ve iPhone/iPad simülatörlerine kuruldu.

- `flutter test test/app/config test/app/release_policy_composition_test.dart test/app/startup_test.dart test/app/composition_test.dart test/core/config test/core/preferences test/core/server test/features/server --reporter expanded`: **130 test geçti**. Cache, bozuk yayın, geçici disk hatasından toparlanma, yazma sırası, native metadata, mağaza hedefi ve güncelleme ekranı dahil.
- `flutter build ios --simulator --debug --flavor dev -t lib/main_dev.dart --build-name=0.2.1 --build-number=3`: başarılı. Üretilen plist `io.nizamio.mobile.dev`, sürüm `0.2.1`, build `3`; kaynak sürüm `0.2.0+2` değişmedi.
- `flutter build apk --debug --flavor dev -t lib/main_dev.dart --build-name=0.2.1 --build-number=3`: başarılı; Android dev APK üretildi.
- Konsoldaki `ios_recommended_version=0.2.2` yayınıyla gerçek iPhone simülatörü `integration_test/firebase_development_test.dart`: **1/1 geçti**. Kabul edilen öneri SDK'nın gerçek değeriyle eşit, politika kaynağı `remote`, native varsayılan üç bool değerinin `0` biçimi ve kapalı kalması doğrulandı. Bu deneme, Apple SDK'nın `0/1` bool temsilini reddeden ayrıştırma hatasını ortaya çıkardı; dar düzeltmenin source/services/warmup regresyonları **20/20 geçti**. Native test artık sessizce kapalı politikaya düşmeyi başarı saymaz.
- Normal `main_dev.dart` uygulaması `0.2.1+3` ve yerel doğrulanmış sunucu bağıyla iPhone simülatörüne yeniden kuruldu. Gerçek konsol yayını güncelleme önerisini açtı; kurulu sürüm ve eksik mağaza hedefi doğru gösterildi. Device Hub üzerinden **Daha sonra** düğmesine basılınca öneri kapandı ve giriş ekranı görünür oldu. Test listener uygulaması bırakılmadı.
- Referans tasarım düzenlemesi sonrası ortak sayfa, politika kapısı ve backend uyumluluk ekranı hedefli testleri **26/26 geçti**; küçük telefon/tablet, açık/koyu tema ve 2× yazı ölçeği dahil. Değişen altı UI/test dosyasının scoped analizi temiz. Güncel iOS dev derlemesi başarılı; gerçek konsol önerisiyle yeni tam ekran görüldü, sağ üst **Kapat** giriş ekranına döndürdü. Ardından uygulama yeniden açılarak yeni tasarım simülatörde görünür bırakıldı. Zorunlu görünüm için uzaktaki minimum değiştirilmedi; kapatma/geri engeli testlerle, görünüm yerel render önizlemeleriyle doğrulandı.
- Değişen Dart dosyalarının formatı ve `git diff --check` temiz. API üretilmiş dosyalarında değişiklik yok.
- Depo genelindeki denetimler tamamen yeşil değildir: mevcut 10 analiz bilgisi, 16 mimari sınır ihlali, üç eksik widget test dosyası ve dört dosya boyutu bildirimi bu dilimin dışındaki, HEAD ile aynı dosyalardadır. Daha geniş testte bulunan iki arşiv/tablet sahnesi hatası, değişiklik içermeyen `514d758` dışa aktarımında da aynı biçimde üretildi.
- Prod Firebase, gerçek mağazaya yönlendirme, imzalı dağıtım ve fiziksel cihaz testi bu kanıta dahil değildir. CI/push yapılmadı.

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

## Simülatörde güncelleme görünümünü deneme

Kurulu test paketi `0.2.1+3` olduğunda aşağıdaki **iOS** Remote Config değerleriyle
deneme yapılabilir; bu talimat kendiliğinden uzak ayar yayımlamaz:

| Senaryo | `ios_minimum_version` | `ios_recommended_version` | İki build alanı |
|---|---|---|---|
| İsteğe bağlı öneri | boş | `0.2.2` | `0` |
| Zorunlu güncelleme | `0.2.2` | `0.2.2` | `0` |
| Sıfırlama | boş | boş | `0` |

Her değişiklikten sonra konsolda **Publish changes** kullanılır; dev debug için en
az 30 saniye beklenir ve **Yeniden kontrol et** seçilir. Android politikası da
sıfırlanacaksa tüm `*_minimum_version`/`*_recommended_version` alanları boş,
`*_minimum_build`/`*_recommended_build` alanları `0` yapılır. Gerçek dağıtımda
minimum yükseltmeden önce hedef sürümün kullanıcılara erişilebilir olması gerekir.

Hot reload mevcut Dart durumunu korur; ertelenmiş öneriyi veya SDK önbelleğini
sıfırlamaz. Hot restart Dart oturumunu/ertelemesini yeniden kurar fakat native
Remote Config ve kalıcı politika önbelleğini silmez; 30 saniyelik çekme sınırı
geçerlidir. Native sürüm/build değiştirmek için paketi yeni derlemeyle kurmak
gerekir; hot reload/restart kurulu `0.2.1+3` metadata'sını değiştirmez.
