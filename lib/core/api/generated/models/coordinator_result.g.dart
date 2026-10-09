// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinator_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoordinatorResult _$CoordinatorResultFromJson(Map<String, dynamic> json) =>
    _CoordinatorResult(
      membershipId: json['membership_id'] as String,
      departmentId: json['department_id'] as String,
      accountId: json['account_id'] as String,
      role: json['role'] as String,
      changed: json['changed'] as bool,
    );

Map<String, dynamic> _$CoordinatorResultToJson(_CoordinatorResult instance) =>
    <String, dynamic>{
      'membership_id': instance.membershipId,
      'department_id': instance.departmentId,
      'account_id': instance.accountId,
      'role': instance.role,
      'changed': instance.changed,
    };
