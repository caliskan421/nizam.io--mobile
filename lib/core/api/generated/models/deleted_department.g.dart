// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletedDepartment _$DeletedDepartmentFromJson(Map<String, dynamic> json) =>
    _DeletedDepartment(
      departmentId: json['department_id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String,
      deletedAt: json['deleted_at'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$DeletedDepartmentToJson(_DeletedDepartment instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'name': instance.name,
      'kind': instance.kind,
      'deleted_at': instance.deletedAt,
      'code': ?instance.code,
    };
