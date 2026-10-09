// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskSummary _$TaskSummaryFromJson(Map<String, dynamic> json) => _TaskSummary(
  departmentId: json['department_id'] as String,
  activeItems: (json['active_items'] as num).toInt(),
  completedItems: (json['completed_items'] as num).toInt(),
);

Map<String, dynamic> _$TaskSummaryToJson(_TaskSummary instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'active_items': instance.activeItems,
      'completed_items': instance.completedItems,
    };
