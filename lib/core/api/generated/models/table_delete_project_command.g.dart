// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_delete_project_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableDeleteProjectCommand _$TableDeleteProjectCommandFromJson(
  Map<String, dynamic> json,
) => _TableDeleteProjectCommand(
  kind: TableDeleteProjectCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableDeleteProjectCommandToJson(
  _TableDeleteProjectCommand instance,
) => <String, dynamic>{
  'kind': _$TableDeleteProjectCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteProjectCommandKindEnumMap = {
  TableDeleteProjectCommandKind.deleteProject: 'delete_project',
  TableDeleteProjectCommandKind.$unknown: r'$unknown',
};
