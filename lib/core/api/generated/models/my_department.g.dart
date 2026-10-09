// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyDepartment _$MyDepartmentFromJson(Map<String, dynamic> json) =>
    _MyDepartment(
      departmentId: json['department_id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$MyDepartmentToJson(_MyDepartment instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'name': instance.name,
      'role': instance.role,
    };
