// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_skipped_cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSkippedCell _$TableSkippedCellFromJson(Map<String, dynamic> json) =>
    _TableSkippedCell(
      rowId: json['row_id'] as String,
      columnId: json['column_id'] as String,
      reason: TableSkippedCellReason.fromJson(json['reason'] as String),
    );

Map<String, dynamic> _$TableSkippedCellToJson(_TableSkippedCell instance) =>
    <String, dynamic>{
      'row_id': instance.rowId,
      'column_id': instance.columnId,
      'reason': _$TableSkippedCellReasonEnumMap[instance.reason]!,
    };

const _$TableSkippedCellReasonEnumMap = {
  TableSkippedCellReason.gone: 'gone',
  TableSkippedCellReason.changed: 'changed',
  TableSkippedCellReason.unavailable: 'unavailable',
  TableSkippedCellReason.$unknown: r'$unknown',
};
