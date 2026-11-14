// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_set_team_role_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSetTeamRoleCommand _$TableSetTeamRoleCommandFromJson(
  Map<String, dynamic> json,
) => _TableSetTeamRoleCommand(
  kind: TableSetTeamRoleCommandKind.fromJson(json['kind'] as String),
  role: TableSetTeamRoleCommandRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$TableSetTeamRoleCommandToJson(
  _TableSetTeamRoleCommand instance,
) => <String, dynamic>{
  'kind': _$TableSetTeamRoleCommandKindEnumMap[instance.kind]!,
  'role': _$TableSetTeamRoleCommandRoleEnumMap[instance.role]!,
};

const _$TableSetTeamRoleCommandKindEnumMap = {
  TableSetTeamRoleCommandKind.setTeamRole: 'set_team_role',
  TableSetTeamRoleCommandKind.$unknown: r'$unknown',
};

const _$TableSetTeamRoleCommandRoleEnumMap = {
  TableSetTeamRoleCommandRole.editor: 'editor',
  TableSetTeamRoleCommandRole.viewer: 'viewer',
  TableSetTeamRoleCommandRole.none: 'none',
  TableSetTeamRoleCommandRole.$unknown: r'$unknown',
};
