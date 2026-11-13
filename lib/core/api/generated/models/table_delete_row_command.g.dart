// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_delete_row_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableDeleteRowCommand _$TableDeleteRowCommandFromJson(
  Map<String, dynamic> json,
) => _TableDeleteRowCommand(
  kind: TableDeleteRowCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableDeleteRowCommandToJson(
  _TableDeleteRowCommand instance,
) => <String, dynamic>{
  'kind': _$TableDeleteRowCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteRowCommandKindEnumMap = {
  TableDeleteRowCommandKind.deleteRow: 'delete_row',
  TableDeleteRowCommandKind.$unknown: r'$unknown',
};
