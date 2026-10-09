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
| `shared_preferences` | Gizli OLMAYAN tercihler (tema modu ilk tercih). Yalnız `lib/core/storage/` (`SharedPreferenceStore`, S5); erişim tipli `AppPreferences` üzerinden, sabit anahtar kümesi. Belirteç/parola/sunucu bağı/kişisel veri burada tutulmaz (S1: `SecureStore`). Okuma hatası varsayılana düşer. |
| `google_fonts` (8.x) | Token yazı tipleri (Inter, JetBrains Mono) **uygulamayla gelir** (`assets/fonts/`, google_fonts adlandırması, OFL lisansları lisans sayfasında); `allowRuntimeFetching = false` — çalışma anında Google'a istek yok, çevrimdışı açılış. 9.x `material_ui` paketine geçtiği için (`flutter/material` ile tip uyumsuzluğu) 8.x pinli. |
| `gap` | **Boşluk standardı.** Çocuksuz `SizedBox(width/height)`, `SizedBox.square`, `SizedBox.fromSize` yasak (U1); `Gap` kullanılır. Çocuklu SizedBox ve `shrink/expand` serbest. |
| `drift` + `drift_flutter` (+ `drift_dev`) | İnternetsiz gösterim için yerel veri (platform.md kararı; sqflite değil). Kurulum (instance) başına ayrı dosya; farklı kuruluma yeniden bağlanmada dosya silinir (doğrulanabilir temizlik). Şema ve önbellek politikası ekran çalışmasıyla gelir; MOB-0'da yalnız paket. |
| `path_provider` | drift dosyası ve indirme biletiyle dosya indirme için. |
| `firebase_core`, `firebase_messaging`, `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` | **Önceki kararı değiştirir:** platform.md'deki "çökme raporu SaaS yok (ADR-0003)" ve "analytics kapalı" mobil için kaldırıldı (ürün sahibi). Kurallar: SDK yalnız `lib/app/**` ve `lib/core/telemetry/**` (S6); Firebase'e belirteç, parola, sunucu adresi, kişisel veri veya sunucu hata gövdesi gönderilmez (günlük redaksiyonu aynen). **Başlatma yapılmaz:** Firebase projesi ve yapılandırma dosyaları (`google-services.json`, `GoogleService-Info.plist`) dağıtım/proje sahipliği kararına bağlıdır; o zamana kadar paketler bağlıdır ama `Firebase.initializeApp` çağrılmaz. |
| `flutter_native_splash`, `flutter_launcher_icons` | Açılış ekranı ve simge. Görseller **yer tutucu** (`assets/branding/`, primary600 + "N"; KR-13 ile aynı ilke). Gerçek marka aynı dosya adlarıyla konup `make branding` çalıştırılır. |

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
