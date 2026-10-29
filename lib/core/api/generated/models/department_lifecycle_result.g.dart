// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_lifecycle_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentLifecycleResult _$DepartmentLifecycleResultFromJson(
  Map<String, dynamic> json,
) => _DepartmentLifecycleResult(
  departmentId: json['department_id'] as String,
  status: DepartmentLifecycleResultStatus.fromJson(json['status'] as String),
);

Map<String, dynamic> _$DepartmentLifecycleResultToJson(
  _DepartmentLifecycleResult instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'status': _$DepartmentLifecycleResultStatusEnumMap[instance.status]!,
};

const _$DepartmentLifecycleResultStatusEnumMap = {
  DepartmentLifecycleResultStatus.restored: 'restored',
  DepartmentLifecycleResultStatus.purged: 'purged',
  DepartmentLifecycleResultStatus.$unknown: r'$unknown',
};
