# Responsive altyapı (2026-10-29)

Karar: [ADR-0003 karar 25](../architecture/adr-0003-ui-temeli.md). Bağımsız kullanıcı işi;
program fazı ve `DURUM.md` kaydı değildir. Tablet tasarımı (`docs/design/tablet/`)
**uygulanmadı**, backend'e bağlanmadı.

## Kapsam

Mevcut ekranların pencere boyutu ve yön değişiminde doğru yerleşmesi ve durum kaybetmemesi.
Eşikler (600 / 840) ve mimari aynı; yeni provider, bağımlılık, önbellek, durum kalıcılığı,
menteşe/iki panel yok.

## Parçalar ve kabul

| Parça | İçerik | Kabul kanıtı |
|---|---|---|
| 1 | `NzLayout.fromConstraints`; `NzPage` dolgu ve azami genişliği gövdeye ayrılan alandan okur, kabuk pencereye, sayfa yerel kısıta bakar | `test/core/ui/layout/nz_layout_test.dart`, `test/core/ui/page/nz_page_test.dart` |
| 2 | `OrientationPolicyHost` (Android kısa kenar < 600 dp → dikey; diğerleri OS varsayılanı), iOS `Info.plist`: iPhone dikey, iPad dört yön | `test/app/orientation_policy_test.dart` |
| 3 | Gerçek `createRouter` + `StatefulNavigationShell` ve sayfalarda yeniden boyut regresyonları; bu belge ve ADR kararı | aşağıdaki iki test |

Parça 3 testleri tek uygulama/yönlendirici/kapsayıcıda yalnız `tester.view.physicalSize`
değiştirir (yeniden `pumpWidget` yok):

- `test/app/router/shell_resize_test.dart` — `/archive` sekmesinde 599↔600, 839↔840, tablet
  1180×820 ↔ 820×1180, dar bölünmüş görünüm 375×820. Her adımda: alt menü/ray doğru, rota
  aynı, `NzAdaptiveShell` ve `ArchivePage` State'i aynı nesne, arama ve etiket taslağı
  `TextEditingController`'ları aynı nesne ve metinleri aynı, denetleyici durumu (sorgu,
  sıralama, etiket, açık panel) aynı nesne, kaydırma konumu yeni sınıra sıkıştırılmış eski
  değer (sıfırdan farklı konum en az 4 adımda birebir, en az 2 adımda sıkıştırılarak korunur),
  test sarmalayıcısıyla sayılan `ArchiveRepository.loadFolders` çağrısı 1.
- `test/features/messages/presentation/chat_page_test.dart` "yeniden boyut" — klavye açıkken
  (`viewInsets` 300) yanıt bağlamı + taslakla tablet dikey → yatay → dikey: `ChatPage` State'i,
  taslak denetleyicisi, metin ve yanıt bağlamı korunur, yazma alanı klavyenin üstünde, hata yok.

Duyarlılık denetimi (yerel, geri alındı): `_TagsPanel`'e genişlik anahtarı verilince kabuk
testi denetleyici kimliğinde kırmızı oldu. Kabuk gövdesine (`_shell`) dış anahtar eklemek
testi kırmadı: go_router `StatefulNavigationShell`'i kendi `GlobalKey`'iyle taşır. Bu yüzden
üretim kabuğu değiştirilmedi.

## Komutlar

```sh
flutter test test/app/router/shell_resize_test.dart \
  test/features/messages/presentation/chat_page_test.dart \
  test/app/orientation_policy_test.dart
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
make boundaries
```

Tam yerel doğrulama, birleşik çalışma ağacında makine kilidiyle çalıştırılır:

```sh
../program/araclar/verify-sirasi.sh "$PWD"
```

## Koordinatör doğrulaması (2026-10-29)

- Opus 5.5 medium üç parçayı uyguladı; koordinatör her parçanın kodunu ve testlerini inceledi.
- Dal: `codex/mobile-responsive-foundation`; başlangıç `c3d790e` ve oturum başındaki
  kaydedilmemiş güncel çalışmalar. `git fetch --no-tags origin` sonrası `origin/main`
  tabanda: geride 0, ileride 47 commit. Mevcut diğer çalışmalar korunmuştur.
- Tam `make verify` makine kilidiyle **EXIT=0**: format (646 dosya, değişiklik yok), statik
  analiz, mimari sınırlar, test varlığı ve **1.468 test** başarılı.
- Kapsama: core %95,96; application %96,22; data %99,85; presentation %94,23;
  ortak UI widget'ları %99,07. Beş dizin eşiği de sağlandı.
- `git diff --check` ve `plutil -lint ios/Runner/Info.plist` başarılı. Üretim gezinme kabuğu,
  Android manifesti, API ve bağımlılıklar bu işte değiştirilmedi.
- Paylaşılan dosyalarda önceden kaydedilmemiş çalışmalar bulunduğu için toplu commit veya
  push yapılmadı. Uzak CI tetiklenmedi (KR-27). Tablet prototipine geçilmedi.

## Limitler

- Fiziksel cihazda dönüş, iPad Split View/Stage Manager ve katlanabilir/menteşe davranışı
  denenmedi; kanıt widget testindeki benzetimdir (testte tablet boyutu telefon kilidinden
  bağımsız simüle edilir).
- Linux golden testleri macOS'ta koşmaz; bu iş için golden ve uzak CI çalıştırılmadı.
- Kök navigator'da açılan alt sayfaların (ör. `ArchiveFolderPage`) yeniden boyut testi yoktur;
  kabuk yeniden ebeveynleme kanıtı `ArchivePage` üzerindendir.
- `ArchiveFoldersController` `keepAlive`'dır; yükleme sayacı yalnız ek veri yüklemesi
  oluşmadığını kanıtlar. Sayfanın yeniden kurulmadığı ayrıca State nesnesinin kimliğiyle
  doğrulanır. Sohbet testinde autoDispose yanıt bağlamı korunur; bu testler bütün sağlayıcılar
  için genel bir yaşam süresi garantisi değildir.
- Android telefon kilidi ilk View hazır olduktan sonra uygulanır; soğuk açılışta ilk kare
  geçici olarak yatay olabilir. Android 16+ büyük ekranlarda işletim sistemi yön isteğini
  yok sayabilir; yerleşim buna rağmen kullanılabilir alanı izler.
