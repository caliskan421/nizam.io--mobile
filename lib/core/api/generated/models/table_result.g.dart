// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableResult _$TableResultFromJson(Map<String, dynamic> json) => _TableResult(
  tableId: json['table_id'] as String,
  sequence: (json['sequence'] as num).toInt(),
  schemaVersion: (json['schema_version'] as num).toInt(),
  replayed: json['replayed'] as bool,
  id: json['id'] as String?,
  cells: (json['cells'] as List<dynamic>?)
      ?.map((e) => TableCell.fromJson(e as Map<String, dynamic>))
      .toList(),
  skipped: (json['skipped'] as List<dynamic>?)
      ?.map((e) => TableSkippedCell.fromJson(e as Map<String, dynamic>))
      .toList(),
  clearedGrants: (json['cleared_grants'] as num?)?.toInt(),
  status: json['status'] == null
      ? null
      : TableResultStatus.fromJson(json['status'] as String),
  converted: (json['converted'] as num?)?.toInt(),
);

Map<String, dynamic> _$TableResultToJson(_TableResult instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'sequence': instance.sequence,
      'schema_version': instance.schemaVersion,
      'replayed': instance.replayed,
      'id': ?instance.id,
      'cells': ?instance.cells?.map((e) => e.toJson()).toList(),
      'skipped': ?instance.skipped?.map((e) => e.toJson()).toList(),
      'cleared_grants': ?instance.clearedGrants,
      'status': ?_$TableResultStatusEnumMap[instance.status],
      'converted': ?instance.converted,
    };

const _$TableResultStatusEnumMap = {
  TableResultStatus.pending: 'pending',
  TableResultStatus.withdrawn: 'withdrawn',
  TableResultStatus.$unknown: r'$unknown',
};
