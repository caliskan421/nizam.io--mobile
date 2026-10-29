// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meeting_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMeetingDepartment _$ReportMeetingDepartmentFromJson(
  Map<String, dynamic> json,
) => _ReportMeetingDepartment(
  departmentId: json['department_id'] as String,
  name: json['name'] as String,
  deleted: json['deleted'] as bool,
);

Map<String, dynamic> _$ReportMeetingDepartmentToJson(
  _ReportMeetingDepartment instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'name': instance.name,
  'deleted': instance.deleted,
};
