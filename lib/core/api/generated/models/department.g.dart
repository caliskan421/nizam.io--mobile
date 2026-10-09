// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Department _$DepartmentFromJson(Map<String, dynamic> json) => _Department(
  departmentId: json['department_id'] as String,
  name: json['name'] as String,
  kind: json['kind'] as String,
  code: json['code'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$DepartmentToJson(_Department instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'name': instance.name,
      'kind': instance.kind,
      'code': ?instance.code,
      'description': ?instance.description,
    };
