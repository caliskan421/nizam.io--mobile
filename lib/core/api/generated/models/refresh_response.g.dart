// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    _RefreshResponse(
      accountId: json['account_id'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
      refreshExpiresAt: (json['refresh_expires_at'] as num).toInt(),
      token: json['token'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$RefreshResponseToJson(_RefreshResponse instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'expires_at': instance.expiresAt,
      'refresh_expires_at': instance.refreshExpiresAt,
      'token': ?instance.token,
      'access_token': ?instance.accessToken,
      'refresh_token': ?instance.refreshToken,
    };
