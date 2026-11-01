# ADR-0002 — Paket seti: tercihler, yazı tipi, boşluk standardı, yerel veri, Firebase, marka

- **Durum:** Kabul edildi (2026-10-09)
- **Karar dayanağı:** ürün sahibi talebi (F14 MOB-0 r3; "şimdiden eklensin")
- **İlgili:** platform.md §6 (yerel DB drift; Firebase SDK; çökme raporu), ADR-0001, sınır
  kuralları S1/S5/S6/U1

## Bağlam

MOB-0 ekransız altyapıdır. Ürün sahibi, ekran çalışmasında kesin kullanılacak paketlerin ve
standartların şimdiden yerleşmesini istedi. Bu ADR hangi paketin hangi kuralla girdiğini ve
önceki bir kararı değiştirdiği yeri kaydeder.

## Karar

| Paket | Kullanım ve kural |
|---|---|
| `shared_preferences` | Gizli OLMAYAN tercihler (tema modu ilk tercih). Yalnız `core/storage/shared_preference_store.dart` (kesin dosya, S5); ham depo yalnız `AppPreferences` ve `app/di`'den (S7), açık API'de taşınamaz (A4) ve bağdaştırıcılar tipi silinmiş değer veremez (A5); erişim tipli `AppPreferences` üzerinden, sabit anahtar kümesi. Belirteç/parola/sunucu bağı/kişisel veri burada tutulmaz (S1: `SecureStore`). Okuma hatası varsayılana düşer. |
| `google_fonts` (8.x) | Token yazı tipleri (2026-10-28'den beri Poppins 600, Inter 400/500/600, Geist Mono 400/500 — ADR-0003 karar 24) **uygulamayla gelir** (`assets/fonts/`, google_fonts adlandırması, OFL lisansları lisans sayfasında); `allowRuntimeFetching = false` — çalışma anında Google'a istek yok, çevrimdışı açılış. 9.x `material_ui` paketine geçtiği için (`flutter/material` ile tip uyumsuzluğu) 8.x pinli. |
| `gap` | **Boşluk standardı.** Çocuksuz `SizedBox(width/height)`, `SizedBox.square`, `SizedBox.fromSize` yasak (U1); `Gap` kullanılır. Çocuklu SizedBox ve `shrink/expand` serbest; `SizedBox.new`, yapıcı tear-off ve `typedef` takma adı da yasak. Kural sözdizimseldir (ad tabanlı): başka bir kütüphanenin aynı adlı sınıfı yanlış pozitif verebilir — projede yerel `SizedBox` tanımlanmaz. |
| `drift` + `drift_flutter` (+ `drift_dev`) | İnternetsiz gösterim için yerel veri (platform.md kararı; sqflite değil). Kurulum (instance) başına ayrı dosya; farklı kuruluma yeniden bağlanmada dosya silinir (doğrulanabilir temizlik). Şema ve önbellek politikası ekran çalışmasıyla gelir; MOB-0'da yalnız paket. |
| `path_provider` | drift dosyası ve indirme biletiyle dosya indirme için. |
| `file_picker` (^13.1.0; kilitte 13.1.0 ve federe alt paketler 2026-10-18 öncesi sürümler) | **2026-11-01 F57, koordinatör kararı — görev kanıt yükleme akışı için.** Yalnız `UploadPicker` portunun gerçekleştirmesinde: `features/tasks/data/file_upload_picker.dart` (kesin dosya, sınır kuralı F1; dışa verilemez). Tek dosya, `FileType.custom` + izinli uzantılar (`uploadExtensions`); foto kitaplığı kullanılmaz → iOS'ta izin metni yok, Android'de izin yok (SAF). Paket ağa çıkmaz; seçilen dosyanın içeriği okunmaz, adı/yolu günlüğe yazılmaz; tür/boyut yerel ön denetimden geçer, yükleme yalnız mevcut `TaskWriteRepository.attachFile` yolundan. iOS en az 14.0 ister (proje 16.0). |
| `firebase_core`, `firebase_messaging`, `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` | **Önceki kararı değiştirir:** platform.md'deki "çökme raporu SaaS yok (ADR-0003)" ve "analytics kapalı" mobil için kaldırıldı (ürün sahibi). Kurallar: SDK yalnız `lib/app/**` ve `core/telemetry/telemetry.dart` (kesin dosya, S6; A4/A5); Firebase'e belirteç, parola, sunucu adresi, kişisel veri veya sunucu hata gövdesi gönderilmez (günlük redaksiyonu aynen). **Başlatma yapılmaz:** Firebase projesi ve yapılandırma dosyaları (`google-services.json`, `GoogleService-Info.plist`) dağıtım/proje sahipliği kararına bağlıdır; o zamana kadar paketler bağlıdır ama `Firebase.initializeApp` çağrılmaz. |
| `flutter_native_splash`, `flutter_launcher_icons` | Açılış ekranı ve simge. Simge (`assets/branding/icon*.png`) uygulama içi işaretle (`NzBrandMark`) aynıdır: üstten alta `primaryTop #D8F866 → primary #C8F53C` degrade, "N" Poppins SemiBold `#0B0B0B`, yazı/karo oranı 16/44 (Android uyarlanabilir simgede güvenli alana ölçekli; arka plan `icon_background.png`). Açılış görseli hâlâ **yer tutucu** (primary600 + "N"; KR-13 ile aynı ilke). Görseller değişince `make branding` çalıştırılır. |

## Sonuçlar

- Tema modu (sistem/açık/koyu) kalıcıdır: `ThemeModeController` (get_it) +
  `themeModeProvider` (Riverpod); `runApp`'ten önce yüklenir. Güvenlik açılış sırası
  (`startup`) tercihlere bağlı değildir.
- Firebase'in etkinleştirilmesi ayrı bir iş olarak kalır: proje + yapılandırma dosyaları →
  `core/telemetry/` (başlatma, Crashlytics hata kancası, analytics olay şeması, Remote Config
  varsayılanları) → izin/aydınlatma metni.
- Yükseltme notu: `flutter_launcher_icons` iOS projesinde
  `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` değerini bozar; `make branding`
  bunu geri alır.
