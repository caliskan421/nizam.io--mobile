// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_delete_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableDeleteColumnCommand _$TableDeleteColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableDeleteColumnCommand(
  kind: TableDeleteColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableDeleteColumnCommandToJson(
  _TableDeleteColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableDeleteColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'expected_schema': instance.expectedSchema,
};

const _$TableDeleteColumnCommandKindEnumMap = {
  TableDeleteColumnCommandKind.deleteColumn: 'delete_column',
  TableDeleteColumnCommandKind.$unknown: r'$unknown',
};
