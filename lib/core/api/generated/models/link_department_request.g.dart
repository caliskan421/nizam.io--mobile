// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_department_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LinkDepartmentRequest _$LinkDepartmentRequestFromJson(
  Map<String, dynamic> json,
) => _LinkDepartmentRequest(
  departmentId: json['department_id'] as String,
  displayName: json['display_name'] as String?,
  copyMembersFromProgramId: json['copy_members_from_program_id'] as String?,
);

Map<String, dynamic> _$LinkDepartmentRequestToJson(
  _LinkDepartmentRequest instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'display_name': ?instance.displayName,
  'copy_members_from_program_id': ?instance.copyMembersFromProgramId,
};
