import 'package:meta/meta.dart';

/// Tek kullanımlık, kısa ömürlü (60 sn) indirme bileti (`POST /v1/download-tickets`).
/// Tüketim `GET /v1/downloads/{ticket}` adresine kimlik başlığı olmadan gidilerek yapılır
/// (tarayıcı/indirme yöneticisi). [toString] bileti içermez.
@immutable
final class DownloadTicket {
  const DownloadTicket({
    required this.ticket,
    required this.path,
    required this.expiresAt,
  });

  /// 256 bit, base64url bilet; gizlidir (log'a yazılmaz).
  final String ticket;

  /// Sunucunun verdiği göreli tüketme yolu (`/v1/downloads/{ticket}`).
  final String path;
  final DateTime expiresAt;

  @override
  String toString() => 'DownloadTicket(…)';
}
