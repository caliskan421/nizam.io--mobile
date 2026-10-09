// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangePasswordResponse _$ChangePasswordResponseFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordResponse(
  revokedSessions: (json['revoked_sessions'] as num).toInt(),
);

Map<String, dynamic> _$ChangePasswordResponseToJson(
  _ChangePasswordResponse instance,
) => <String, dynamic>{'revoked_sessions': instance.revokedSessions};
