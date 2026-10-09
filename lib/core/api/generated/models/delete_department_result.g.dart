// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_department_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeleteDepartmentResult _$DeleteDepartmentResultFromJson(
  Map<String, dynamic> json,
) => _DeleteDepartmentResult(
  departmentId: json['department_id'] as String,
  deleted: json['deleted'] as bool,
);

Map<String, dynamic> _$DeleteDepartmentResultToJson(
  _DeleteDepartmentResult instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'deleted': instance.deleted,
};
