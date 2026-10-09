// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserResult _$UserResultFromJson(Map<String, dynamic> json) => _UserResult(
  accountId: json['account_id'] as String,
  membershipId: json['membership_id'] as String?,
  created: json['created'] as bool?,
  transferred: json['transferred'] as bool?,
  changedFields: (json['changed_fields'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  revokedSessions: (json['revoked_sessions'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserResultToJson(_UserResult instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'membership_id': ?instance.membershipId,
      'created': ?instance.created,
      'transferred': ?instance.transferred,
      'changed_fields': ?instance.changedFields,
      'revoked_sessions': ?instance.revokedSessions,
    };
