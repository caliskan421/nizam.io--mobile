# M015-3 tanık koşumu

Tarih: 2026-11-10. Çalışma ağacı: `mobil-v015-koordinatorluk`. `package_config.json` zaten mevcuttu; `flutter pub get --enforce-lockfile` gerekmedi ve çalıştırılmadı.

| Komut | Exit | Sonuç |
|---|---:|---|
| `flutter test test/features/coordinatorships test/tool/file_size_test.dart --reporter expanded --timeout=2m` | 1 | Koordinatörlük dizininde 107 geçti, 2 başarısız. Çıktıda file_size testi yer almadı. |
| `flutter test test/tool/file_size_test.dart --reporter expanded --timeout=2m` | 0 | 1 geçti. |

İlk komut 19 saniyede tamamlandı; yarış/Completer beklemesi veya süreç takılması gözlenmedi.

## Başarısız testler

- `test/features/coordinatorships/application/coordinatorship_form_controller_test.dart`: `mevcut kayıt true: açık onay ve kalan adım` — beklenen `1`, gerçek `0` (`coordinatorship_form_controller_test.dart:473`).
- `test/features/coordinatorships/application/coordinatorship_recovery_test.dart`: `restore yanıtı kaybolursa not_deleted ile yalnız bağlamaya ilerler` — beklenen `true`, gerçek `false` (`coordinatorship_recovery_test.dart:72`).

M015-3 yürütme notu testlerin yazıldığını, ancak uygulayıcı tarafından henüz çalıştırılmadığını belirtiyor. Bu nedenle bu iki başarısızlık M015-3'ün ilk gözlenen kırmızılarıdır; bu ayrı worktree'de aynı testler için önceki yeşil taban kaydı yoktur ve bunları önceki fazlardan kalan kırmızılar olarak sınıflandıramıyorum. Root incelemesinde restore testinin fake yolunun sözleşmeye uymadığı belirtilmiş; düzeltme Terra'ya devredildi.

## Ham çıktılar

- `/tmp/nizamio-m015-luna/phase3-targeted.txt`
- `/tmp/nizamio-m015-luna/phase3-file-size.txt`

## P3 düzeltme sonrası yeniden koşum (r2)

Komut: `flutter test test/features/coordinatorships --reporter expanded --timeout=2m` → exit 1; 111 test geçti, 1 başarısız. 20 saniyede tamamlandı, test sürecinde bekleme olmadı. Yeni `coordinatorship_detail_scope_test.dart` de klasör kapsamına alındı.

Tek başarısız test: `test/features/coordinatorships/application/coordinatorship_detail_scope_test.dart`: `aynı departman kimliğiyle program değişiminde bekleyen eski yanıt kullanılmaz` — beklenen exception, ancak çağrı `(department: ..., program: prog-2, session: 1)` sonucu verdi (test satırı 117). Önceki koşumda kırmızı olan `coordinatorship_form_controller_test.dart: mevcut kayıt true: açık onay ve kalan adım` ve `coordinatorship_recovery_test.dart: restore yanıtı kaybolursa not_deleted ile yalnız bağlamaya ilerler` bu r2 koşumunda başarısız olmadı.

`flutter test test/tool/file_size_test.dart --reporter expanded --timeout=2m` → exit 0; 1 test geçti.

Ham çıktılar:

- `/tmp/nizamio-m015-luna/phase3-r2-targeted.txt`
- `/tmp/nizamio-m015-luna/phase3-r2-file-size.txt`

## P3 kapsam testi r3

Komut: `flutter test test/features/coordinatorships/application/coordinatorship_detail_scope_test.dart --reporter expanded --timeout=2m` → exit 1; 3 test geçti, 1 başarısız. Koşum yaklaşık 4 saniyede tamamlandı, takılma olmadı.

Tek başarısız test: `aynı departman kimliğiyle program değişiminde bekleyen eski yanıt kullanılmaz` — beklenen `2`, gerçek `3` (`coordinatorship_detail_scope_test.dart:131`). Aynı dosyadaki `başarılı okuma sonrası 403 ve 404 önceki değeri göstermez`, `aynı departmanda hesap değişince önceki yanıt yeni hesaba taşınmaz` ve `oturum nesli bildirimden önce değişince bekleyen okuma kullanılmaz` geçti. R2'deki 111 testlik diğer yeşil sonuç bu tek dosya düzenlemesi dışında değişmedi; r3 sonucu hedef test için faz hedefli kabulini tamamlamıyor.

Ham çıktı: `/tmp/nizamio-m015-luna/phase3-r3-scope.txt`.

## P3 ayrıntı ve kapsam testleri r4

Komut: `flutter test test/features/coordinatorships/application/coordinatorship_detail_scope_test.dart test/features/coordinatorships/application/coordinatorship_detail_controller_test.dart --reporter expanded --timeout=2m` → exit 0; 9 test geçti. Bu ikili koşumda `aynı departman kimliğiyle program değişiminde bekleyen eski yanıt kullanılmaz` da geçti. Mutlak GET=2 beklentisi korunarak bu koşumda doğrulandı (koordinatör kaynak ve ham çıktı kontrolü).

Ham çıktı: `/tmp/nizamio-m015-luna/phase3-r4-detail.txt`.
