// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConferenceToken _$ConferenceTokenFromJson(Map<String, dynamic> json) =>
    _ConferenceToken(
      token: json['token'] as String,
      url: json['url'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      role: ConferenceTokenRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$ConferenceTokenToJson(_ConferenceToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'url': instance.url,
      'expires_at': instance.expiresAt.toIso8601String(),
      'role': _$ConferenceTokenRoleEnumMap[instance.role]!,
    };

const _$ConferenceTokenRoleEnumMap = {
  ConferenceTokenRole.host: 'host',
  ConferenceTokenRole.speaker: 'speaker',
  ConferenceTokenRole.$unknown: r'$unknown',
};
