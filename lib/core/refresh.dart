import 'telemetry/report_source.dart';
import 'telemetry/unexpected_error.dart';

/// Yenilemeyi bekler; eski veri görünürken hatayı çağırana bildirir.
/// Veri yoksa kaynak kendi hata görünümünü taşır; ikinci bildirim yapılmaz.
/// Hata her iki durumda girişte politika yardımcısından geçer (beklenen 0 rapor, kaynak
/// sağlayıcı zaten raporladıysa tekrar tek rapor).
Future<void> refreshWithFeedback({
  required bool shown,
  required Future<void> Function() reload,
}) async {
  try {
    await reload();
  } on Object catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.ui);
    if (shown) rethrow;
  }
}
