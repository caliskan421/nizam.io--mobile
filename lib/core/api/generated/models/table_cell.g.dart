// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableCell _$TableCellFromJson(Map<String, dynamic> json) => _TableCell(
  rowId: json['row_id'] as String,
  columnId: json['column_id'] as String,
  value: json['value'] == null
      ? null
      : TableCellValue.fromJson(json['value'] as Map<String, dynamic>),
  version: (json['version'] as num).toInt(),
  redacted: json['redacted'] as bool?,
);

Map<String, dynamic> _$TableCellToJson(_TableCell instance) =>
    <String, dynamic>{
      'row_id': instance.rowId,
      'column_id': instance.columnId,
      'value': ?instance.value?.toJson(),
      'version': instance.version,
      'redacted': ?instance.redacted,
    };
