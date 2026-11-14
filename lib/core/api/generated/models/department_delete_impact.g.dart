// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_delete_impact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentDeleteImpact _$DepartmentDeleteImpactFromJson(
  Map<String, dynamic> json,
) => _DepartmentDeleteImpact(
  departmentId: json['department_id'] as String,
  name: json['name'] as String,
  deleted: json['deleted'] as bool,
  programs: (json['programs'] as List<dynamic>)
      .map(
        (e) =>
            DepartmentDeleteImpactProgram.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  activeItems: (json['active_items'] as num).toInt(),
  completedItems: (json['completed_items'] as num).toInt(),
  deletedItems: (json['deleted_items'] as num).toInt(),
  deletedWithDepartment: (json['deleted_with_department'] as num).toInt(),
  fileCount: (json['file_count'] as num).toInt(),
  memberCount: (json['member_count'] as num).toInt(),
  meetingCount: (json['meeting_count'] as num).toInt(),
  permanentBlockers: DepartmentPermanentBlockers.fromJson(
    json['permanent_blockers'] as Map<String, dynamic>,
  ),
  permanentBlocked: json['permanent_blocked'] as bool,
);

Map<String, dynamic> _$DepartmentDeleteImpactToJson(
  _DepartmentDeleteImpact instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'name': instance.name,
  'deleted': instance.deleted,
  'programs': instance.programs.map((e) => e.toJson()).toList(),
  'active_items': instance.activeItems,
  'completed_items': instance.completedItems,
  'deleted_items': instance.deletedItems,
  'deleted_with_department': instance.deletedWithDepartment,
  'file_count': instance.fileCount,
  'member_count': instance.memberCount,
  'meeting_count': instance.meetingCount,
  'permanent_blockers': instance.permanentBlockers.toJson(),
  'permanent_blocked': instance.permanentBlocked,
};
