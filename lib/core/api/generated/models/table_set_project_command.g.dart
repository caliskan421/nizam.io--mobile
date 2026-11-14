// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_set_project_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSetProjectCommand _$TableSetProjectCommandFromJson(
  Map<String, dynamic> json,
) => _TableSetProjectCommand(
  kind: TableSetProjectCommandKind.fromJson(json['kind'] as String),
  projectId: json['project_id'] as String?,
);

Map<String, dynamic> _$TableSetProjectCommandToJson(
  _TableSetProjectCommand instance,
) => <String, dynamic>{
  'kind': _$TableSetProjectCommandKindEnumMap[instance.kind]!,
  'project_id': ?instance.projectId,
};

const _$TableSetProjectCommandKindEnumMap = {
  TableSetProjectCommandKind.setProject: 'set_project',
  TableSetProjectCommandKind.$unknown: r'$unknown',
};
