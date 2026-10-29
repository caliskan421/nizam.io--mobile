// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportDepartment _$ReportDepartmentFromJson(Map<String, dynamic> json) =>
    _ReportDepartment(
      departmentId: json['department_id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String?,
    );

Map<String, dynamic> _$ReportDepartmentToJson(_ReportDepartment instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'name': instance.name,
      'kind': ?instance.kind,
    };
