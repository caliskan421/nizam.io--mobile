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

## Bütünleşik kapı 1 — HEAD 774701f

Başlangıç doğrulaması: `git rev-parse HEAD` → `774701f837faa27df3c32fde80df86b9a3613c45`; `git status --porcelain=v1` boştu.

| Komut | Exit | Sonuç |
|---|---:|---|
| `NIZAMIO_BACKEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--backend NIZAMIO_FRONTEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--frontend make gen-check` | 0 | Üretim ve diff denetimi başarılı; `git diff --exit-code` temiz. |
| `flutter test test/features/administration test/features/scope test/features/coordinatorships test/features/tasks/application/task_detail_writes_p3_test.dart test/features/tasks/application/task_catalog_filter_test.dart test/features/tasks/application/tasks_nav_caption_test.dart test/features/tasks/presentation/task_view_grid_truncated_test.dart test/features/timeline/application test/app/router/users_profile_flow_test.dart test/core/generated test/tool/response_headers_test.dart test/tool/program_patch_generator_test.dart test/tool/file_size_test.dart --exclude-tags golden --reporter expanded --timeout=2m --concurrency=4` | 1 | 393 geçti, 2 başarısız. |

Başarısız testlerin tam adları:

- `test/app/router/users_profile_flow_test.dart: Kullanıcı listesi, profil ve hesap: Size(1180.0, 820.0)`
- `test/app/router/users_profile_flow_test.dart: Kullanıcı listesi, profil ve hesap: Size(390.0, 844.0)`

Her iki testte de görev görünümü için beklenen `UserTaskView.calendar`, gerçek `UserTaskView.list` oldu (test satırları 318–320; tam stack ve hit-test tanıları ham çıktıda). Aynı iki test adı taban test koşumunda da başarısız olduğundan, bunlar önceki taban kırmızılarıdır; bu bütünleşik koşumda yeni başarısızlık gözlenmedi. Golden kapsam dışıdır.

Koşum sonrası `git rev-parse HEAD` aynı `774701f837faa27df3c32fde80df86b9a3613c45`; `git status --porcelain=v1` ve `git diff --stat` boş. Ham çıktılar `/tmp/nizamio-m015-luna/final-gen-check.txt` ve `/tmp/nizamio-m015-luna/final-targeted.txt`.

## Son P1 ve profil render hedefli koşumu — HEAD 5845db2

Başlangıç doğrulaması: `git rev-parse HEAD` → `5845db246a822de4b3f0440cf27db8eddcbd65ec`; `git status --porcelain=v1` boştu.

Komut: `flutter test test/features/scope/application/home_dashboard_controller_test.dart test/app/router/users_profile_flow_test.dart --reporter expanded --timeout=2m --concurrency=2` → exit 1; 20 test geçti, 2 başarısız.

Başarısız testlerin tam adları:

- `test/app/router/users_profile_flow_test.dart: Kullanıcı listesi, profil ve hesap: Size(390.0, 844.0)`
- `test/app/router/users_profile_flow_test.dart: Kullanıcı listesi, profil ve hesap: Size(1180.0, 820.0)`

Her iki senaryoda beklenen `E-posta, giriş kilidi ve son giriş bilgisi` metni bulunamadı (test satırı 356; tam stack ham çıktıda). P1/dashboard testi ve router testlerinin kalanları geçti. Bu hedef koşumu yeşil değil; bu nedenle bütünleşik kapı kabulü sağlanmadı ve full verify başlatılmadı.

Ham çıktı: `/tmp/nizamio-m015-luna/final-r2-fixes.txt`.

## Son tam verify — HEAD 21a6458

Başlangıç: `git rev-parse HEAD` → `21a64587410236bef9026a730ed6671bc80a26a2`; `git status --porcelain=v1` boştu.

| Aşama | Komut | Exit | Sonuç |
|---|---|---:|---|
| Profil hedef testi | `flutter test test/app/router/users_profile_flow_test.dart --reporter expanded --timeout=2m` | 0 | 2 geçti. |
| Üretim doğrulaması | `NIZAMIO_BACKEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--backend NIZAMIO_FRONTEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--frontend make gen-check` | 0 | `git diff --exit-code` temiz. |
| Tam kapı | `NIZAMIO_BACKEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--backend NIZAMIO_FRONTEND_DIR=/Users/muhammetalicaliskan/Projects/NIZAM.IO/nizam.io--frontend /Users/muhammetalicaliskan/Projects/NIZAM.IO/program/araclar/verify-sirasi.sh /Users/muhammetalicaliskan/.codex/worktrees/mobil-api-v015/nizam.io--mobile verify` | 2 | `make verify` coverage test aşamasında durdu; yeşil değil. |
| Coverage tanısı (sonradan, lcov mevcut) | `dart run tool/check_coverage.dart coverage/lcov.info` | 1 | Eşik yüzdeleri geçti, iki dosya lcov'da yok; `KAPI KIRMIZI`. |

Tam verify içinde `flutter pub get`, format denetimi, `flutter analyze --fatal-infos` (sorun yok), `check_boundaries` (1445 dosya, ihlal yok) ve `check_test_presence` (eksik test yok) geçti. `flutter test test/ --exclude-tags golden --coverage` sonucu 2377 geçti, 1 başarısız:

- `test/tool/boundaries_test.dart: izinler kapalıyken ham ölçüm: U2=143, U3 TextStyle=0, google_fonts=2` — beklenen 143, gerçek 157 (`boundaries_test.dart:1020`). Koordinatörün incelemesi +14 sayımı üretilmiş palet tokenlarındaki rol renklerinin iki tema varyantına bağlandığını doğruladı; bu mevcut ham ölçüm beklentisiyle ilgili, gerçek boundary lint ihlali değil.

Coverage tanısında eşikler: core 96.15% (80), application 87.70% (80), data 97.92% (80), presentation 61.73% (60), core/ui/widgets 97.17% (70); hepsi eşik üstü. Ancak `lib/features/administration/presentation/admin_users_export.dart` ve `lib/features/administration/presentation/admin_user_texts.dart` lcov'da yok. Tam verify `flutter test --coverage` başarısız olduğundan coverage denetimi ve golden hedefi sırasıyla tamamlanmadı. Makine macOS; Linux golden, backend entegrasyonu ve CI kanıtı bu koşumda yok.

Verify sonrası `kilit.sh durum verify` → `kilit[agir-is]: boş`; `pgrep -x go`, `k6`, `vegeta`, `wrk`, `hey`, `locust` sonuç vermedi; verify/flutter süreçleri kapalı. HEAD aynı kaldı. Bu kanıt güncellemesi dışında worktree temizdi.

Ham çıktılar: `/tmp/nizamio-m015-luna/final-r3-profile.txt`, `/tmp/nizamio-m015-luna/final-r3-gen-check.txt`, `/tmp/nizamio-m015-luna/final-verify.txt`, `/tmp/nizamio-m015-luna/final-coverage-diagnostic.txt`.

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
