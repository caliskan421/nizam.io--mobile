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
  isOverdue: json['is_overdue'] as bool,
  daysOverdue: (json['days_overdue'] as num).toInt(),
  isCompletedLate: json['is_completed_late'] as bool,
  daysLate: (json['days_late'] as num).toInt(),
  isCompletedEarly: json['is_completed_early'] as bool,
  daysEarly: (json['days_early'] as num).toInt(),
  plannedEndOn: json['planned_end_on'] == null
      ? null
      : DateTime.parse(json['planned_end_on'] as String),
  completedOn: json['completed_on'] == null
      ? null
      : DateTime.parse(json['completed_on'] as String),
);

Map<String, dynamic> _$WorkItemToJson(_WorkItem instance) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'program_id': instance.programId,
  'department_id': instance.departmentId,
  'title': instance.title,
  'priority': _$WorkItemPriorityEnumMap[instance.priority]!,
  'status': _$WorkItemStatusEnumMap[instance.status]!,
  'assignee_account_ids': instance.assigneeAccountIds,
  'is_overdue': instance.isOverdue,
  'days_overdue': instance.daysOverdue,
  'is_completed_late': instance.isCompletedLate,
  'days_late': instance.daysLate,
  'is_completed_early': instance.isCompletedEarly,
  'days_early': instance.daysEarly,
  'planned_end_on': ?instance.plannedEndOn?.toIso8601String(),
  'completed_on': ?instance.completedOn?.toIso8601String(),
};

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
