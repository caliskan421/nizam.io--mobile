import 'package:flutter_riverpod/misc.dart' show ProviderException;

/// Riverpod 3 bağımlılık sarmalayıcısını (`ProviderException`: hata durumundaki sağlayıcıyı
/// okuyan başka sağlayıcıya/`future`'a fırlatılır) asıl istisna ve ÖZGÜN yığına indirir. İç içe
/// sarmalar sonuna kadar açılır. Sağlayıcı adı, meta veri ya da durum okunmaz: yalnız
/// `exception` ve `stackTrace` alanları (pinned riverpod 3.4.3 `common/stack_trace.dart`).
///
/// Sarmalayıcı hiçbir koşulda ayrı "beklenmeyen" hata olarak raporlanmaz; kök hata beklenense
/// 0, beklenmeyense kökün tek raporu üretilir (aynı olay tekrar sayılmaz).
(Object, StackTrace) unwrapProviderException(Object error, StackTrace stack) {
  var e = error;
  var st = stack;
  while (e is ProviderException) {
    st = e.stackTrace;
    e = e.exception;
  }
  return (e, st);
}
