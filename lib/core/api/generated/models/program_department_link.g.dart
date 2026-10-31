// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_department_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDepartmentLink _$ProgramDepartmentLinkFromJson(
  Map<String, dynamic> json,
) => _ProgramDepartmentLink(
  programId: json['program_id'] as String,
  departmentId: json['department_id'] as String,
  displayName: json['display_name'] as String,
  copiedMemberCount: (json['copied_member_count'] as num).toInt(),
);

Map<String, dynamic> _$ProgramDepartmentLinkToJson(
  _ProgramDepartmentLink instance,
) => <String, dynamic>{
  'program_id': instance.programId,
  'department_id': instance.departmentId,
  'display_name': instance.displayName,
  'copied_member_count': instance.copiedMemberCount,
};
