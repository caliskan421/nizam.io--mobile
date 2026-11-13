// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_move_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableMoveColumnCommand _$TableMoveColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableMoveColumnCommand(
  kind: TableMoveColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
  afterId: json['after_id'] as String?,
);

Map<String, dynamic> _$TableMoveColumnCommandToJson(
  _TableMoveColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableMoveColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'expected_schema': instance.expectedSchema,
  'after_id': ?instance.afterId,
};

const _$TableMoveColumnCommandKindEnumMap = {
  TableMoveColumnCommandKind.moveColumn: 'move_column',
  TableMoveColumnCommandKind.$unknown: r'$unknown',
};
