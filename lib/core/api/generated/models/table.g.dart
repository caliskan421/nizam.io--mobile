// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Table _$TableFromJson(Map<String, dynamic> json) => _Table(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  programId: json['program_id'] as String,
  departmentId: json['department_id'] as String,
  space: TableSpace.fromJson(json['space'] as String),
  schemaVersion: (json['schema_version'] as num).toInt(),
  sequence: (json['sequence'] as num).toInt(),
  teamRole: json['team_role'] == null
      ? null
      : TableTeamRole.fromJson(json['team_role'] as String),
  projectId: json['project_id'] as String?,
  isTemplate: json['is_template'] as bool?,
);

Map<String, dynamic> _$TableToJson(_Table instance) => <String, dynamic>{
  'id': instance.id,
  'owner_id': instance.ownerId,
  'name': instance.name,
  'program_id': instance.programId,
  'department_id': instance.departmentId,
  'space': _$TableSpaceEnumMap[instance.space]!,
  'schema_version': instance.schemaVersion,
  'sequence': instance.sequence,
  'team_role': ?_$TableTeamRoleEnumMap[instance.teamRole],
  'project_id': ?instance.projectId,
  'is_template': ?instance.isTemplate,
};

const _$TableSpaceEnumMap = {
  TableSpace.personal: 'personal',
  TableSpace.coordinatorship: 'coordinatorship',
  TableSpace.$unknown: r'$unknown',
};

const _$TableTeamRoleEnumMap = {
  TableTeamRole.editor: 'editor',
  TableTeamRole.viewer: 'viewer',
  TableTeamRole.$unknown: r'$unknown',
};
