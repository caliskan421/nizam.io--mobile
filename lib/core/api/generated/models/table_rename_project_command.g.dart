// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_rename_project_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableRenameProjectCommand _$TableRenameProjectCommandFromJson(
  Map<String, dynamic> json,
) => _TableRenameProjectCommand(
  kind: TableRenameProjectCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$TableRenameProjectCommandToJson(
  _TableRenameProjectCommand instance,
) => <String, dynamic>{
  'kind': _$TableRenameProjectCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'name': instance.name,
};

const _$TableRenameProjectCommandKindEnumMap = {
  TableRenameProjectCommandKind.renameProject: 'rename_project',
  TableRenameProjectCommandKind.$unknown: r'$unknown',
};
