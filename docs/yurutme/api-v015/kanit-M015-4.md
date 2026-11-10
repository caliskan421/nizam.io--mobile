# M015-4 tanık koşumu

Tarih: 2026-11-10. Çalışma ağacı: `mobil-v015-donem`. Üretim ve test kaynaklarına dokunulmadı.

| Komut | Exit | Sonuç |
|---|---:|---|
| `flutter test test/features/administration/data/program_admin_api_repository_test.dart test/features/scope/data/program_repository_test.dart test/features/scope/presentation/scope_page_test.dart test/features/scope/application/current_program_controller_test.dart test/features/scope/application/program_list_controller_test.dart test/tool/program_patch_generator_test.dart --reporter expanded --timeout=2m` | 0 | 58 test geçti. |
| `flutter test test/tool/file_size_test.dart --reporter expanded --timeout=2m` | 0 | 1 test geçti. |

## PATCH güvence incelemesi

`program_admin_api_repository_test.dart` testi gerçek adapter istek gövdesini kontrol ediyor: `short_name` ve `color` için ayrı ayrı (1) anahtar yok, (2) açık `null`, (3) somut değer (`AB`, `blue`). Dolayısıyla üç hâlli PATCH iddiası yalnız serializer metin denetimine dayanmıyor; wire gövdesinde de doğrulanıyor.

`bilinmeyen renk temizleme olarak gönderilmez` testi hem update hem create çağrısında `ProgramColor.unknown` için `throwsArgumentError` bekliyor ve adapter'da istek görülmediğini (`seen == null`) doğruluyor. Böylece bilinmeyen renk null/temizleme olarak gönderilmiyor; açıkça reddediliyor. `program_patch_generator_test.dart` ayrıca alan yoksa null-atlama dönüşümünden önce yapılmasını ve beklenmeyen şablon çıktısının `FormatException` vermesini doğruluyor.

## Ham çıktılar

- `/tmp/nizamio-m015-luna/phase4-targeted.txt`
- `/tmp/nizamio-m015-luna/phase4-file-size.txt`
