// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      accountId: json['account_id'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
      forcePasswordChange: json['force_password_change'] as bool,
      token: json['token'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      refreshExpiresAt: (json['refresh_expires_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'expires_at': instance.expiresAt,
      'force_password_change': instance.forcePasswordChange,
      'token': ?instance.token,
      'access_token': ?instance.accessToken,
      'refresh_token': ?instance.refreshToken,
      'refresh_expires_at': ?instance.refreshExpiresAt,
    };
