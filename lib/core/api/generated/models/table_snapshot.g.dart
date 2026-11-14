// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSnapshot _$TableSnapshotFromJson(Map<String, dynamic> json) =>
    _TableSnapshot(
      table: Table.fromJson(json['table'] as Map<String, dynamic>),
      columns: (json['columns'] as List<dynamic>)
          .map((e) => TableColumn.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => TableRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      cells: (json['cells'] as List<dynamic>)
          .map((e) => TableCell.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      references: (json['references'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
      attachments: (json['attachments'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          TableAttachmentMeta.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );

Map<String, dynamic> _$TableSnapshotToJson(
  _TableSnapshot instance,
) => <String, dynamic>{
  'table': instance.table.toJson(),
  'columns': instance.columns.map((e) => e.toJson()).toList(),
  'rows': instance.rows.map((e) => e.toJson()).toList(),
  'cells': instance.cells.map((e) => e.toJson()).toList(),
  'next_cursor': ?instance.nextCursor,
  'references': ?instance.references,
  'attachments': ?instance.attachments?.map((k, e) => MapEntry(k, e.toJson())),
};
