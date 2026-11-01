// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDepartment _$ProgramDepartmentFromJson(Map<String, dynamic> json) =>
    _ProgramDepartment(
      departmentId: json['department_id'] as String,
      displayName: json['display_name'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ProgramDepartmentToJson(_ProgramDepartment instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'display_name': instance.displayName,
      'code': ?instance.code,
    };
