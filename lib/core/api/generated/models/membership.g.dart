// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Membership _$MembershipFromJson(Map<String, dynamic> json) => _Membership(
  membershipId: json['membership_id'] as String,
  departmentId: json['department_id'] as String,
  accountId: json['account_id'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$MembershipToJson(_Membership instance) =>
    <String, dynamic>{
      'membership_id': instance.membershipId,
      'department_id': instance.departmentId,
      'account_id': instance.accountId,
      'role': instance.role,
    };
