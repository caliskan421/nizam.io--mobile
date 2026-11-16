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
  workItemsRestored: (json['work_items_restored'] as num?)?.toInt(),
  workItemsDeleted: (json['work_items_deleted'] as num?)?.toInt(),
  filesDeleted: (json['files_deleted'] as num?)?.toInt(),
  programLinksRemoved: (json['program_links_removed'] as num?)?.toInt(),
  membershipsDeleted: (json['memberships_deleted'] as num?)?.toInt(),
);

Map<String, dynamic> _$DepartmentLifecycleResultToJson(
  _DepartmentLifecycleResult instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'status': _$DepartmentLifecycleResultStatusEnumMap[instance.status]!,
  'work_items_restored': ?instance.workItemsRestored,
  'work_items_deleted': ?instance.workItemsDeleted,
  'files_deleted': ?instance.filesDeleted,
  'program_links_removed': ?instance.programLinksRemoved,
  'memberships_deleted': ?instance.membershipsDeleted,
};

const _$DepartmentLifecycleResultStatusEnumMap = {
  DepartmentLifecycleResultStatus.restored: 'restored',
  DepartmentLifecycleResultStatus.purged: 'purged',
  DepartmentLifecycleResultStatus.$unknown: r'$unknown',
};
