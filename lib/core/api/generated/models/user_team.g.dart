// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTeam _$UserTeamFromJson(Map<String, dynamic> json) => _UserTeam(
  programId: json['program_id'] as String,
  programName: json['program_name'] as String,
  departmentId: json['department_id'] as String,
  displayName: json['display_name'] as String,
  role: UserTeamRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$UserTeamToJson(_UserTeam instance) => <String, dynamic>{
  'program_id': instance.programId,
  'program_name': instance.programName,
  'department_id': instance.departmentId,
  'display_name': instance.displayName,
  'role': _$UserTeamRoleEnumMap[instance.role]!,
};

const _$UserTeamRoleEnumMap = {
  UserTeamRole.uye: 'uye',
  UserTeamRole.koordinator: 'koordinator',
  UserTeamRole.$unknown: r'$unknown',
};
