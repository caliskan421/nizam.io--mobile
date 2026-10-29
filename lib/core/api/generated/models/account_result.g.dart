// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountResult _$AccountResultFromJson(Map<String, dynamic> json) =>
    _AccountResult(
      accountId: json['account_id'] as String,
      revokedSessions: (json['revoked_sessions'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountResultToJson(_AccountResult instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'revoked_sessions': ?instance.revokedSessions,
    };
