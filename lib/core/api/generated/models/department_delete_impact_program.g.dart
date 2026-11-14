// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_delete_impact_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentDeleteImpactProgram _$DepartmentDeleteImpactProgramFromJson(
  Map<String, dynamic> json,
) => _DepartmentDeleteImpactProgram(
  programId: json['program_id'] as String,
  programName: json['program_name'] as String?,
  departmentName: json['department_name'] as String?,
  linked: json['linked'] as bool,
  activeItems: (json['active_items'] as num).toInt(),
  completedItems: (json['completed_items'] as num).toInt(),
  deletedItems: (json['deleted_items'] as num).toInt(),
  deletedWithDepartment: (json['deleted_with_department'] as num).toInt(),
);

Map<String, dynamic> _$DepartmentDeleteImpactProgramToJson(
  _DepartmentDeleteImpactProgram instance,
) => <String, dynamic>{
  'program_id': instance.programId,
  'program_name': ?instance.programName,
  'department_name': ?instance.departmentName,
  'linked': instance.linked,
  'active_items': instance.activeItems,
  'completed_items': instance.completedItems,
  'deleted_items': instance.deletedItems,
  'deleted_with_department': instance.deletedWithDepartment,
};
