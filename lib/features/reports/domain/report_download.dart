import 'package:meta/meta.dart';

/// İndirme hedefinin HTTP yöntemi.
enum ReportDownloadMethod { get, post }

/// PDF raporunun indirme hedefi: indirme bileti akışına (`POST /v1/download-tickets` →
/// `GET /v1/downloads/{ticket}`, identity) verilecek yöntem, göreli yol ve (yalnız POST'ta)
/// JSON gövde. Ağ isteği değildir; bilet identity tarafında alınır. Hedefler S2'dir: bilet
/// isteğinde `X-Nizamio-Program` verilmeli (bilete yazılır).
@immutable
final class ReportDownloadTarget {
  const ReportDownloadTarget({
    required this.method,
    required this.path,
    this.body,
  });

  final ReportDownloadMethod method;

  /// Göreli yol (ör. `/v1/reports/tasks/{id}/pdf`).
  final String path;

  /// Yalnız POST hedefinde: üretilmiş istek DTO'sunun JSON nesnesi (bilet isteğinin
  /// `body` alanına olduğu gibi verilir); GET hedefinde null.
  final Object? body;
}
