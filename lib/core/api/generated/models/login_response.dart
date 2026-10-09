// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@Freezed()
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'account_id') required String accountId,

    /// Erişim/oturum belirtecinin bitişi (Unix saniyesi).
    @JsonKey(name: 'expires_at') required int expiresAt,
    @JsonKey(name: 'force_password_change') required bool forcePasswordChange,

    /// Web oturum belirteci (yalnız web).
    String? token,

    /// Mobil erişim belirteci (yalnız mobil).
    @JsonKey(name: 'access_token') String? accessToken,

    /// Mobil yenileme belirteci (yalnız mobil; web'de çerezdedir).
    @JsonKey(name: 'refresh_token') String? refreshToken,

    /// Yenileme belirtecinin bitişi (Unix saniyesi).
    @JsonKey(name: 'refresh_expires_at') int? refreshExpiresAt,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
