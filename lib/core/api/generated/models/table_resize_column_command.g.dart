// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_resize_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableResizeColumnCommand _$TableResizeColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableResizeColumnCommand(
  kind: TableResizeColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  width: (json['width'] as num).toInt(),
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableResizeColumnCommandToJson(
  _TableResizeColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableResizeColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'width': instance.width,
  'expected_schema': instance.expectedSchema,
};

const _$TableResizeColumnCommandKindEnumMap = {
  TableResizeColumnCommandKind.resizeColumn: 'resize_column',
  TableResizeColumnCommandKind.$unknown: r'$unknown',
};
