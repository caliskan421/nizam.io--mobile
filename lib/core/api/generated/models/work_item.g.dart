// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItem _$WorkItemFromJson(Map<String, dynamic> json) => _WorkItem(
  workItemId: json['work_item_id'] as String,
  programId: json['program_id'] as String,
  departmentId: json['department_id'] as String,
  title: json['title'] as String,
  priority: WorkItemPriority.fromJson(json['priority'] as String),
  status: WorkItemStatus.fromJson(json['status'] as String),
  assigneeAccountIds: (json['assignee_account_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => WorkItemAssignee.fromJson(e as Map<String, dynamic>))
      .toList(),
  startOn: const DateOnlyConverter().fromJson(json['start_on'] as String),
  endOn: const DateOnlyConverter().fromJson(json['end_on'] as String),
  isOverdue: json['is_overdue'] as bool,
  daysOverdue: (json['days_overdue'] as num).toInt(),
  isCompletedLate: json['is_completed_late'] as bool,
  daysLate: (json['days_late'] as num).toInt(),
  isCompletedEarly: json['is_completed_early'] as bool,
  daysEarly: (json['days_early'] as num).toInt(),
  completionEvidenceRequired: json['completion_evidence_required'] as bool,
  subtaskCounts: SubtaskCounts.fromJson(
    json['subtask_counts'] as Map<String, dynamic>,
  ),
  plannedEndOn: _$JsonConverterFromJson<String, DateTime>(
    json['planned_end_on'],
    const DateOnlyConverter().fromJson,
  ),
  completedOn: _$JsonConverterFromJson<String, DateTime>(
    json['completed_on'],
    const DateOnlyConverter().fromJson,
  ),
);

Map<String, dynamic> _$WorkItemToJson(_WorkItem instance) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'program_id': instance.programId,
  'department_id': instance.departmentId,
  'title': instance.title,
  'priority': _$WorkItemPriorityEnumMap[instance.priority]!,
  'status': _$WorkItemStatusEnumMap[instance.status]!,
  'assignee_account_ids': instance.assigneeAccountIds,
  'assignees': instance.assignees.map((e) => e.toJson()).toList(),
  'start_on': const DateOnlyConverter().toJson(instance.startOn),
  'end_on': const DateOnlyConverter().toJson(instance.endOn),
  'is_overdue': instance.isOverdue,
  'days_overdue': instance.daysOverdue,
  'is_completed_late': instance.isCompletedLate,
  'days_late': instance.daysLate,
  'is_completed_early': instance.isCompletedEarly,
  'days_early': instance.daysEarly,
  'completion_evidence_required': instance.completionEvidenceRequired,
  'subtask_counts': instance.subtaskCounts.toJson(),
  'planned_end_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.plannedEndOn,
    const DateOnlyConverter().toJson,
  ),
  'completed_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.completedOn,
    const DateOnlyConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$WorkItemPriorityEnumMap = {
  WorkItemPriority.dusuk: 'dusuk',
  WorkItemPriority.orta: 'orta',
  WorkItemPriority.yuksek: 'yuksek',
  WorkItemPriority.acil: 'acil',
  WorkItemPriority.$unknown: r'$unknown',
};

const _$WorkItemStatusEnumMap = {
  WorkItemStatus.baslanmadi: 'baslanmadi',
  WorkItemStatus.devamEdiyor: 'devam_ediyor',
  WorkItemStatus.onayaSunuldu: 'onaya_sunuldu',
  WorkItemStatus.iadeEdildi: 'iade_edildi',
  WorkItemStatus.tamamlandi: 'tamamlandi',
  WorkItemStatus.$unknown: r'$unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
