// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_rename_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableRenameColumnCommand _$TableRenameColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableRenameColumnCommand(
  kind: TableRenameColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  name: json['name'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableRenameColumnCommandToJson(
  _TableRenameColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableRenameColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'name': instance.name,
  'expected_schema': instance.expectedSchema,
};

const _$TableRenameColumnCommandKindEnumMap = {
  TableRenameColumnCommandKind.renameColumn: 'rename_column',
  TableRenameColumnCommandKind.$unknown: r'$unknown',
};
