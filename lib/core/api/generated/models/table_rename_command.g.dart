// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_rename_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableRenameCommand _$TableRenameCommandFromJson(Map<String, dynamic> json) =>
    _TableRenameCommand(
      kind: TableRenameCommandKind.fromJson(json['kind'] as String),
      name: json['name'] as String,
    );

Map<String, dynamic> _$TableRenameCommandToJson(_TableRenameCommand instance) =>
    <String, dynamic>{
      'kind': _$TableRenameCommandKindEnumMap[instance.kind]!,
      'name': instance.name,
    };

const _$TableRenameCommandKindEnumMap = {
  TableRenameCommandKind.renameTable: 'rename_table',
  TableRenameCommandKind.$unknown: r'$unknown',
};
