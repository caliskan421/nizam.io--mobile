// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_create_project_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableCreateProjectCommand _$TableCreateProjectCommandFromJson(
  Map<String, dynamic> json,
) => _TableCreateProjectCommand(
  kind: TableCreateProjectCommandKind.fromJson(json['kind'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$TableCreateProjectCommandToJson(
  _TableCreateProjectCommand instance,
) => <String, dynamic>{
  'kind': _$TableCreateProjectCommandKindEnumMap[instance.kind]!,
  'name': instance.name,
};

const _$TableCreateProjectCommandKindEnumMap = {
  TableCreateProjectCommandKind.createProject: 'create_project',
  TableCreateProjectCommandKind.$unknown: r'$unknown',
};
