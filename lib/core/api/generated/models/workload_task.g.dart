// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workload_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkloadTask _$WorkloadTaskFromJson(Map<String, dynamic> json) =>
    _WorkloadTask(
      workItemId: json['work_item_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      priority: WorkloadTaskPriority.fromJson(json['priority'] as String),
      startOn: DateTime.parse(json['start_on'] as String),
      endOn: DateTime.parse(json['end_on'] as String),
      completedOn: json['completed_on'] == null
          ? null
          : DateTime.parse(json['completed_on'] as String),
      departmentId: json['department_id'] as String,
      departmentName: json['department_name'] as String,
      isOverdue: json['is_overdue'] as bool,
      daysOverdue: (json['days_overdue'] as num).toInt(),
      attachmentCount: (json['attachment_count'] as num).toInt(),
      hasAttachment: json['has_attachment'] as bool,
      latestNote: json['latest_note'] as String?,
    );

Map<String, dynamic> _$WorkloadTaskToJson(_WorkloadTask instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'status': instance.status,
      'priority': _$WorkloadTaskPriorityEnumMap[instance.priority]!,
      'start_on': instance.startOn.toIso8601String(),
      'end_on': instance.endOn.toIso8601String(),
      'completed_on': ?instance.completedOn?.toIso8601String(),
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'is_overdue': instance.isOverdue,
      'days_overdue': instance.daysOverdue,
      'attachment_count': instance.attachmentCount,
      'has_attachment': instance.hasAttachment,
      'latest_note': ?instance.latestNote,
    };

const _$WorkloadTaskPriorityEnumMap = {
  WorkloadTaskPriority.dusuk: 'dusuk',
  WorkloadTaskPriority.orta: 'orta',
  WorkloadTaskPriority.yuksek: 'yuksek',
  WorkloadTaskPriority.acil: 'acil',
  WorkloadTaskPriority.$unknown: r'$unknown',
};
