// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingDepartment _$MeetingDepartmentFromJson(Map<String, dynamic> json) =>
    _MeetingDepartment(
      departmentId: json['department_id'] as String,
      departmentName: json['department_name'] as String,
      departmentCode: json['department_code'] as String?,
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$MeetingDepartmentToJson(_MeetingDepartment instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'department_code': ?instance.departmentCode,
      'deleted': instance.deleted,
    };
