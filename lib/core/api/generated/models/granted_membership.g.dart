// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'granted_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrantedMembership _$GrantedMembershipFromJson(Map<String, dynamic> json) =>
    _GrantedMembership(
      departmentId: json['department_id'] as String,
      accountId: json['account_id'] as String,
    );

Map<String, dynamic> _$GrantedMembershipToJson(_GrantedMembership instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'account_id': instance.accountId,
    };
