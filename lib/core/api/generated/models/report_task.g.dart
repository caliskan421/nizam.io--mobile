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
  startOn: const DateOnlyConverter().fromJson(json['start_on'] as String),
  endOn: const DateOnlyConverter().fromJson(json['end_on'] as String),
  plannedEndOn: _$JsonConverterFromJson<String, DateTime>(
    json['planned_end_on'],
    const DateOnlyConverter().fromJson,
  ),
  completedOn: _$JsonConverterFromJson<String, DateTime>(
    json['completed_on'],
    const DateOnlyConverter().fromJson,
  ),
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
      'start_on': const DateOnlyConverter().toJson(instance.startOn),
      'end_on': const DateOnlyConverter().toJson(instance.endOn),
      'planned_end_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.plannedEndOn,
        const DateOnlyConverter().toJson,
      ),
      'completed_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.completedOn,
        const DateOnlyConverter().toJson,
      ),
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

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ReportTaskPriorityEnumMap = {
  ReportTaskPriority.dusuk: 'dusuk',
  ReportTaskPriority.orta: 'orta',
  ReportTaskPriority.yuksek: 'yuksek',
  ReportTaskPriority.acil: 'acil',
  ReportTaskPriority.$unknown: r'$unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
