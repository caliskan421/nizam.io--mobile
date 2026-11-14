// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_project_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableProjectCommandCreateProject _$TableProjectCommandCreateProjectFromJson(
  Map<String, dynamic> json,
) => TableProjectCommandCreateProject(
  kind: TableCreateProjectCommandKind.fromJson(json['kind'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$TableProjectCommandCreateProjectToJson(
  TableProjectCommandCreateProject instance,
) => <String, dynamic>{
  'kind': _$TableCreateProjectCommandKindEnumMap[instance.kind]!,
  'name': instance.name,
};

const _$TableCreateProjectCommandKindEnumMap = {
  TableCreateProjectCommandKind.createProject: 'create_project',
  TableCreateProjectCommandKind.$unknown: r'$unknown',
};

TableProjectCommandRenameProject _$TableProjectCommandRenameProjectFromJson(
  Map<String, dynamic> json,
) => TableProjectCommandRenameProject(
  kind: TableRenameProjectCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$TableProjectCommandRenameProjectToJson(
  TableProjectCommandRenameProject instance,
) => <String, dynamic>{
  'kind': _$TableRenameProjectCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'name': instance.name,
};

const _$TableRenameProjectCommandKindEnumMap = {
  TableRenameProjectCommandKind.renameProject: 'rename_project',
  TableRenameProjectCommandKind.$unknown: r'$unknown',
};

TableProjectCommandDeleteProject _$TableProjectCommandDeleteProjectFromJson(
  Map<String, dynamic> json,
) => TableProjectCommandDeleteProject(
  kind: TableDeleteProjectCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableProjectCommandDeleteProjectToJson(
  TableProjectCommandDeleteProject instance,
) => <String, dynamic>{
  'kind': _$TableDeleteProjectCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteProjectCommandKindEnumMap = {
  TableDeleteProjectCommandKind.deleteProject: 'delete_project',
  TableDeleteProjectCommandKind.$unknown: r'$unknown',
};
