// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_move_row_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableMoveRowCommand _$TableMoveRowCommandFromJson(Map<String, dynamic> json) =>
    _TableMoveRowCommand(
      kind: TableMoveRowCommandKind.fromJson(json['kind'] as String),
      id: json['id'] as String,
      afterId: json['after_id'] as String?,
    );

Map<String, dynamic> _$TableMoveRowCommandToJson(
  _TableMoveRowCommand instance,
) => <String, dynamic>{
  'kind': _$TableMoveRowCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'after_id': ?instance.afterId,
};

const _$TableMoveRowCommandKindEnumMap = {
  TableMoveRowCommandKind.moveRow: 'move_row',
  TableMoveRowCommandKind.$unknown: r'$unknown',
};
