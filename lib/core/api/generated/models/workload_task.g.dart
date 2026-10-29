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
      startOn: const DateOnlyConverter().fromJson(json['start_on'] as String),
      endOn: const DateOnlyConverter().fromJson(json['end_on'] as String),
      completedOn: _$JsonConverterFromJson<String, DateTime>(
        json['completed_on'],
        const DateOnlyConverter().fromJson,
      ),
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
      'start_on': const DateOnlyConverter().toJson(instance.startOn),
      'end_on': const DateOnlyConverter().toJson(instance.endOn),
      'completed_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.completedOn,
        const DateOnlyConverter().toJson,
      ),
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'is_overdue': instance.isOverdue,
      'days_overdue': instance.daysOverdue,
      'attachment_count': instance.attachmentCount,
      'has_attachment': instance.hasAttachment,
      'latest_note': ?instance.latestNote,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$WorkloadTaskPriorityEnumMap = {
  WorkloadTaskPriority.dusuk: 'dusuk',
  WorkloadTaskPriority.orta: 'orta',
  WorkloadTaskPriority.yuksek: 'yuksek',
  WorkloadTaskPriority.acil: 'acil',
  WorkloadTaskPriority.$unknown: r'$unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
