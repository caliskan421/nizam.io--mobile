import 'package:meta/meta.dart';

/// `POST /v1/auth/refresh` yanıtının core karşılığı (bileşim kökünde üretilmiş DTO'dan
/// eşlenir; sınır kuralı A3). Mobil belirteç alanları web yanıtında boştur; doğrulaması
/// [SessionController]'dadır. Web oturum belirteci taşınmaz. [toString] alan içermez.
@immutable
final class RefreshGrant {
  const RefreshGrant({
    required this.accountId,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
    this.accessToken,
    this.refreshToken,
  });

  final String accountId;
  final String? accessToken;

  /// Unix saniyesi.
  final int accessExpiresAt;
  final String? refreshToken;

  /// Unix saniyesi.
  final int refreshExpiresAt;

  @override
  String toString() => 'RefreshGrant(…)';
}
