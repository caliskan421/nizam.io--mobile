# Geçiş ölçümü (perf)

Görevler/Zaman çizelgesi geçişlerinin kare sürelerini ölçen tek test (`integration_test/perf_transitions_test.dart`),
tek sürücü (`test_driver/perf_driver.dart`), tek fikstür (`integration_test/support/perf_fixture.dart`, 160 görev,
sunucu sözleşmesi biçiminde, tarihler bugüne göre ±60 gün). Sonuç tablosu: [`tasks-timeline-transitions.md`](tasks-timeline-transitions.md).

Senaryolar: S1 tablet Liste→Zaman çizelgesi, S2 tablet Zaman çizelgesi→Liste, S3 telefon Liste→Zaman çizelgesi,
S4 telefon görev ayrıntısı sekme geçişi (Özet→Alt görev).

## Komut

```sh
# telefon (gerçek iPhone, profile)
tool/perf.sh 00008110-000C5D6426C0A01E S3,S4 telefon-profile profile
# tablet vekili (macOS masaüstü, profile; macos/ platformu yerelde üretilir, aşağıya bakın)
tool/perf.sh macos S1,S2 tablet-macos profile
# son çare: simülatör, debug (mutlak değil, yalnız önce/sonra kıyası)
tool/perf.sh ED5DCAAF-2A7E-480E-8316-E1B9A96DD9BC S1,S2 tablet-sim debug
tool/perf.sh 3EB4F9D3-BA5B-4CCD-96FC-B1683EB69EA3 S3,S4 telefon-sim debug
```

Sonuç `build/perf/<çıktı-adı>.json` (ham kare listesi dahil; yerel, commit'lenmez). Betik bağımsız değişkenleri:
`<cihaz> <senaryolar> <çıktı-adı> [profile|debug] [native|tablet|phone]`. Tek satır karşılığı:

```sh
PERF_OUT=adı flutter drive --profile -d <cihaz> --driver=test_driver/perf_driver.dart \
  --target=integration_test/perf_transitions_test.dart --dart-define=PERF_ONLY=S1,S2
```

Ek tanımlar: `PERF_REPS` (ölçülü tekrar, varsayılan 3), `PERF_WINDOW_MS` (varsayılan 1800),
`PERF_VIEW=tablet|phone` (görünüm boyutunu 1376×1032 / 430×932 mantıksal px yapar; yüzey büyütülmez, yalnız
yerleşim değişir, mutlak raster sayısı için `native` kullanın).

## macOS vekili

Depoda `macos/` yoktur ve eklenmez. Geçici üretim: `flutter create --platforms=macos --project-name nizamio .`
(commit'lenmez). Tablet yerleşimi pencere genişliğine bağlıdır; pencereyi 1376×1032 yapmak için
`macos/Runner/MainFlutterWindow.swift` içinde `self.setContentSize(NSSize(width: 1376, height: 1032))`
eklenir (geçici). Kalıcı ihtiyaç doğarsa `macos/` için ayrı karar gerekir.

## Yöntem

Gerçek `NizamioApp` + gerçek bileşim kökü + `Flavor.dev` + sahte HTTP ile gerçek giriş akışı; her senaryoda bir
ısınma turu (sayılmaz) ve 3 ölçülü tekrar. Ölçüm penceresi dokunuştan başlayıp 1,8 sn sürer (`pumpAndSettle` değil);
ham `FrameTiming` listesi `SchedulerBinding.addTimingsCallback` ile toplanır, anlamsal ağaç pencerede kapalıdır.
Yüzdelikler tekrarların birleşik karelerinden (en yakın sıra); "ilk kare" dokunuştan sonraki ilk karenin UI+raster
toplamı (tekrar medyanı).

Geri dönüş ve bulucular güncel arayüze göredir: Liste/Zaman çizelgesi anahtarı yalnız simgedir, anlamsal etiketle
("Liste", "Zaman çizelgesi") bulunur; tablette çizelgeden "Liste" anahtarıyla, telefonda (çizelge tam ekran açılır)
sistem geri hareketiyle dönülür. Anlamsal ağaç yeniden açılınca birkaç kare beklenir. Telefon simülatöründe görünüm
`native` kullanılır (`phone` görünümünde raster 0 görünebilir). Nokta kıyası: her noktada bu düzenek `git cherry-pick -n`
ile o commit'in üstüne bindirilir.
