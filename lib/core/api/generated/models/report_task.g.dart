// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportTask _$ReportTaskFromJson(Map<String, dynamic> json) => _ReportTask(
  workItemId: json['work_item_id'] as String,
  title: json['title'] as String,
  departmentId: json['department_id'] as String,
  departmentName: json['department_name'] as String,
  status: json['status'] as String,
  priority: ReportTaskPriority.fromJson(json['priority'] as String),
  startOn: DateTime.parse(json['start_on'] as String),
  endOn: DateTime.parse(json['end_on'] as String),
  plannedEndOn: json['planned_end_on'] == null
      ? null
      : DateTime.parse(json['planned_end_on'] as String),
  completedOn: json['completed_on'] == null
      ? null
      : DateTime.parse(json['completed_on'] as String),
  createdBy: ReportPerson.fromJson(json['created_by'] as Map<String, dynamic>),
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => ReportPerson.fromJson(e as Map<String, dynamic>))
      .toList(),
  isOverdue: json['is_overdue'] as bool,
  daysOverdue: (json['days_overdue'] as num).toInt(),
  isCompletedLate: json['is_completed_late'] as bool,
  daysLate: (json['days_late'] as num).toInt(),
  isCompletedEarly: json['is_completed_early'] as bool,
  daysEarly: (json['days_early'] as num).toInt(),
  hasPendingDependency: json['has_pending_dependency'] as bool,
  dependencyCount: (json['dependency_count'] as num).toInt(),
  noteCount: (json['note_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReportTaskToJson(_ReportTask instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'status': instance.status,
      'priority': _$ReportTaskPriorityEnumMap[instance.priority]!,
      'start_on': instance.startOn.toIso8601String(),
      'end_on': instance.endOn.toIso8601String(),
      'planned_end_on': ?instance.plannedEndOn?.toIso8601String(),
      'completed_on': ?instance.completedOn?.toIso8601String(),
      'created_by': instance.createdBy.toJson(),
      'assignees': instance.assignees.map((e) => e.toJson()).toList(),
      'is_overdue': instance.isOverdue,
      'days_overdue': instance.daysOverdue,
      'is_completed_late': instance.isCompletedLate,
      'days_late': instance.daysLate,
      'is_completed_early': instance.isCompletedEarly,
      'days_early': instance.daysEarly,
      'has_pending_dependency': instance.hasPendingDependency,
      'dependency_count': instance.dependencyCount,
      'note_count': instance.noteCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ReportTaskPriorityEnumMap = {
  ReportTaskPriority.dusuk: 'dusuk',
  ReportTaskPriority.orta: 'orta',
  ReportTaskPriority.yuksek: 'yuksek',
  ReportTaskPriority.acil: 'acil',
  ReportTaskPriority.$unknown: r'$unknown',
};
