// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_changes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableChanges _$TableChangesFromJson(Map<String, dynamic> json) =>
    _TableChanges(
      tableId: json['table_id'] as String,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => TableChange.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursor: (json['cursor'] as num).toInt(),
      sequence: (json['sequence'] as num).toInt(),
      more: json['more'] as bool,
    );

Map<String, dynamic> _$TableChangesToJson(_TableChanges instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
      'cursor': instance.cursor,
      'sequence': instance.sequence,
      'more': instance.more,
    };
