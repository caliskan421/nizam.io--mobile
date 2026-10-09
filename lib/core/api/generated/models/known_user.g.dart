// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KnownUser _$KnownUserFromJson(Map<String, dynamic> json) => _KnownUser(
  accountId: json['account_id'] as String,
  fullName: json['full_name'] as String,
  memberships: (json['memberships'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$KnownUserToJson(_KnownUser instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'memberships': ?instance.memberships,
    };
