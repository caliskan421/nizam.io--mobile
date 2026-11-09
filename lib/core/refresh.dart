/// Yenilemeyi bekler; eski veri görünürken hatayı çağırana bildirir.
/// Veri yoksa kaynak kendi hata görünümünü taşır; ikinci bildirim yapılmaz.
Future<void> refreshWithFeedback({
  required bool shown,
  required Future<void> Function() reload,
}) async {
  try {
    await reload();
  } on Object {
    if (shown) rethrow;
  }
}
