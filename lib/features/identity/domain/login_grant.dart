import 'package:meta/meta.dart';

/// Giriş yanıtının domain karşılığı (`data` katmanında eşlenir). Mobil belirteç alanları
/// sunucu mobil sınıfı tanımadıysa (web yanıtı) boştur; doğrulaması uygulama katmanındadır.
/// Web oturum belirteci (`token`) taşınmaz. [toString] belirteç içermez.
@immutable
final class LoginGrant {
  const LoginGrant({
    required this.accountId,
    required this.accessExpiresAt,
    required this.forcePasswordChange,
    this.accessToken,
    this.refreshToken,
    this.refreshExpiresAt,
  });

  final String accountId;
  final String? accessToken;

  /// Unix saniyesi.
  final int accessExpiresAt;
  final String? refreshToken;

  /// Unix saniyesi.
  final int? refreshExpiresAt;
  final bool forcePasswordChange;

  @override
  String toString() => 'LoginGrant(accountId: $accountId)';
}
