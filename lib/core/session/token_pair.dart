import 'dart:convert';

import 'package:meta/meta.dart';

/// Mobil belirteç çifti (giriş/yenileme yanıtı gövdesinden). Yalnız [TokenStore] üzerinden
/// güvenli depoya yazılır; [toString] belirteç içermez.
@immutable
final class TokenPair {
  const TokenPair({
    required this.accountId,
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
    required this.refreshExpiresAt,
    required this.forcePasswordChange,
    required this.instanceId,
  });

  final String accountId;
  final String accessToken;

  /// Unix saniyesi.
  final int accessExpiresAt;
  final String refreshToken;
  final int refreshExpiresAt;

  /// Zorunlu parola değişikliği bayrağı (girişten gelir; yenilemede taşınır).
  final bool forcePasswordChange;

  /// Çiftin ait olduğu kurulum (`/.well-known/nizamio-instance` `instance_id`). Açılışta
  /// doğrulanan bağın kimliğiyle eşleşmeyen çift geri yüklenmez (CX-Ö-03).
  final String instanceId;

  TokenPair copyWith({bool? forcePasswordChange}) => TokenPair(
    accountId: accountId,
    accessToken: accessToken,
    accessExpiresAt: accessExpiresAt,
    refreshToken: refreshToken,
    refreshExpiresAt: refreshExpiresAt,
    forcePasswordChange: forcePasswordChange ?? this.forcePasswordChange,
    instanceId: instanceId,
  );

  /// Depo biçimi (sürümlü). API DTO'su değildir.
  String encode() => jsonEncode({
    'v': 2,
    'account_id': accountId,
    'access_token': accessToken,
    'access_expires_at': accessExpiresAt,
    'refresh_token': refreshToken,
    'refresh_expires_at': refreshExpiresAt,
    'force_password_change': forcePasswordChange,
    'instance_id': instanceId,
  });

  /// Bozuk/eski (v1: kuruluma bağlı olmayan) kayıt `null` (yeniden giriş istenir).
  static TokenPair? decode(String raw) {
    try {
      final m = jsonDecode(raw);
      if (m is! Map<String, Object?> || m['v'] != 2) return null;
      return TokenPair(
        accountId: m['account_id']! as String,
        accessToken: m['access_token']! as String,
        accessExpiresAt: m['access_expires_at']! as int,
        refreshToken: m['refresh_token']! as String,
        refreshExpiresAt: m['refresh_expires_at']! as int,
        forcePasswordChange: m['force_password_change']! as bool,
        instanceId: m['instance_id']! as String,
      );
    } on Object {
      return null;
    }
  }

  @override
  String toString() => 'TokenPair(account=$accountId, access=***, refresh=***)';
}
