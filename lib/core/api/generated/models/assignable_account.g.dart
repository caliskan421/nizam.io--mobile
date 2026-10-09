// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignable_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignableAccount _$AssignableAccountFromJson(Map<String, dynamic> json) =>
    _AssignableAccount(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssignableAccountToJson(_AssignableAccount instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'roles': ?instance.roles,
    };
