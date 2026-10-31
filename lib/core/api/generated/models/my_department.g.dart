// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyDepartment _$MyDepartmentFromJson(Map<String, dynamic> json) =>
    _MyDepartment(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      departmentId: json['department_id'] as String,
      displayName: json['display_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$MyDepartmentToJson(_MyDepartment instance) =>
    <String, dynamic>{
      'program_id': instance.programId,
      'program_name': instance.programName,
      'department_id': instance.departmentId,
      'display_name': instance.displayName,
      'role': instance.role,
    };
