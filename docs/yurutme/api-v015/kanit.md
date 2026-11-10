# Luna kanıtı — taban

Tarih: 2026-11-10. Çalışma ağacı: `mobil-api-v015` worktree. Ham çıktılar `/tmp/nizamio-m015-luna/` altında tutuldu; commit'e alınmamalı.

| Komut | Exit | Sonuç |
|---|---:|---|
| `flutter pub get --enforce-lockfile` | 0 | Bağımlılıklar çözüldü. |
| `flutter test test/ --exclude-tags golden --reporter expanded --timeout=10m` | 1 | 2359 geçti, 6 başarısız. macOS'ta golden kapsam dışı. |
| `flutter analyze --fatal-infos` | 1 | 9 issue (8 info, 1 warning). |
| `dart run tool/check_test_presence.dart` | 1 | 1 eksik test dosyası. |

## Başarısız testler

- `test/app/router/users_profile_flow_test.dart`: `Kullanıcı listesi, profil ve hesap: Size(1180.0, 820.0)`
- `test/app/router/users_profile_flow_test.dart`: `Kullanıcı listesi, profil ve hesap: Size(390.0, 844.0)`
- `test/features/administration/application/admin_user_task_panel_controller_test.dart`: `çoklu filtre değişir ve temizle varsayılan açığa dönerken Liste/Takvim görünümü korunur`
- `test/features/administration/domain/admin_user_tasks_test.dart`: `varsayılan açık; durum seçimleri birleşir ve öncelik seçimiyle kesişir`
- `test/tool/boundaries_test.dart`: `gerçek lib/ ağacı kurallara uyar`
- `test/tool/api_surface_test.dart`: `U1–U6 tip çözümlemeli (Codex 6) gerçek lib/ ağacında ihlal yok`

İki araç testi aynı ihlali bildiriyor: `lib/features/administration/presentation/admin_user_account_dock.dart:61 [U1]` boşluk için `SizedBox` yerine `Gap` kullanılmalı.

## Diğer taban kapıları

- Analyze: 9 issue. 7'si administration altındaki `user_account_draft_controller.dart`, `admin_user_account_dock.dart`, `admin_user_profile_page.dart`, `admin_user_tasks_panel.dart` dosyalarında; 1'i `person_files.dart`, 1'i `calendar_grid.dart` dosyasında. Tam çıktıda her satır ve tanı kodu mevcut.
- Test-presence: eksik `test/features/administration/application/user_account_draft_controller_test.dart`.

## Ham çıktı dosyaları

- `/tmp/nizamio-m015-luna/pub-get.txt`
- `/tmp/nizamio-m015-luna/test-base.txt`
- `/tmp/nizamio-m015-luna/analyze-base.txt`
- `/tmp/nizamio-m015-luna/test-presence-base.txt`

## M015-0/1 hedefli koşum

Tarih: 2026-11-10. Kaynak ağacı dondurulduktan sonra çalıştırıldı; kaynak dosyaları değiştirilmedi.

| Komut | Exit | Sonuç |
|---|---:|---|
| `flutter test test/features/tasks/application/task_detail_writes_p3_test.dart test/features/tasks/data/task_write_api_repository_p3_test.dart test/features/timeline/application/timeline_controller_test.dart test/features/timeline/application/gantt_provider_test.dart test/features/timeline/data/gantt_api_repository_test.dart test/features/administration/data/organization_admin_api_repository_test.dart test/core/generated/generated_test.dart test/tool/response_headers_test.dart test/app/tablet_measurements_test.dart --reporter expanded --timeout=10m` | 0 | 137 test geçti. |
| `flutter test test/tool/file_size_test.dart --reporter expanded --timeout=10m` | 0 | 1 test geçti. |

`tablet_measurements_test.dart` gerçek yolu `test/app/tablet_measurements_test.dart` olarak `rg --files test` ile bulundu. Bu hedefli grupta yeni kırmızı yok; taban test koşumundaki altı başarısızlık bu komutlarda yeniden oluşmadı. Tool boundaries/API surface taban kırmızıları bu tur tekrar koşturulmadı. Golden testleri kapsam dışı.

Ham çıktılar `/tmp/nizamio-m015-luna/phase01-targeted.txt` ve `/tmp/nizamio-m015-luna/phase01-file-size.txt`.

## D01/D02 sonrası güvenlik hedefli koşum — kesildi

Komut: `flutter test test/features/tasks/application/task_detail_writes_p3_test.dart test/features/timeline/application/timeline_request_context_test.dart test/features/timeline/application/timeline_controller_test.dart test/features/timeline/application/gantt_provider_test.dart test/tool/file_size_test.dart --reporter expanded --timeout=10m`

Log: `/tmp/nizamio-m015-luna/phase01-security.txt`. Koşum `timeline_request_context_test.dart` içinde `program değişiminden sonra eski POST yenileme başlatmaz` testinde takılı kaldı. Koordinatör talimatıyla yalnız bu koşuma ait Dart PID 68225'e TERM gönderilerek süreç kesildi. Dolayısıyla bu koşum **tamamlanmadı; geçerli yeşil kanıt değildir**. Kesilme anında 61 test geçti, test koşucusu kapanırken iki hata raporladı:

- `test/features/tasks/application/task_detail_writes_p3_test.dart`: `tarih talebi geciken conflict_retry ve program değişiminde ikinci POST gönderilmez`
- `test/features/timeline/application/timeline_request_context_test.dart`: `program değişiminden sonra eski POST yenileme başlatmaz` (did not complete; koşum kesildi)

Flutter test süreci kapanışta ayrıca `Bad state: Cannot close sink while adding stream` bildirdi. Wrapper logundaki `EXIT_CODE=0`, Dart sürecine TERM gönderilmesinden sonra oluşan shell kodudur; **test başarısı anlamına gelmez**. Yeniden koşum final tam koşuma bırakıldı.
