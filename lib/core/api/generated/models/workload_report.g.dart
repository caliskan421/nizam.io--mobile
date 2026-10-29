// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workload_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkloadReport _$WorkloadReportFromJson(Map<String, dynamic> json) =>
    _WorkloadReport(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => WorkloadMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      coordinatorships: (json['coordinatorships'] as List<dynamic>)
          .map((e) => ReportDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$WorkloadReportToJson(
  _WorkloadReport instance,
) => <String, dynamic>{
  'program_id': instance.programId,
  'program_name': instance.programName,
  'members': instance.members.map((e) => e.toJson()).toList(),
  'coordinatorships': instance.coordinatorships.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'generated_at': instance.generatedAt.toIso8601String(),
};
