// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubtaskCounts _$SubtaskCountsFromJson(Map<String, dynamic> json) =>
    _SubtaskCounts(
      total: (json['total'] as num).toInt(),
      done: (json['done'] as num).toInt(),
    );

Map<String, dynamic> _$SubtaskCountsToJson(_SubtaskCounts instance) =>
    <String, dynamic>{'total': instance.total, 'done': instance.done};
