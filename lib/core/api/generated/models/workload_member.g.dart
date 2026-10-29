// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workload_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkloadMember _$WorkloadMemberFromJson(Map<String, dynamic> json) =>
    _WorkloadMember(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      coordinatorships: (json['coordinatorships'] as List<dynamic>)
          .map((e) => ReportDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => WorkloadTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkloadMemberToJson(
  _WorkloadMember instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'full_name': instance.fullName,
  'coordinatorships': instance.coordinatorships.map((e) => e.toJson()).toList(),
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
};
