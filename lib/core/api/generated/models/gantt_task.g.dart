// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gantt_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GanttTask _$GanttTaskFromJson(Map<String, dynamic> json) => _GanttTask(
  workItemId: json['work_item_id'] as String,
  title: json['title'] as String,
  programId: json['program_id'] as String,
  departmentId: json['department_id'] as String,
  priority: GanttTaskPriority.fromJson(json['priority'] as String),
  status: json['status'] as String,
  startOn: json['start_on'] as String,
  endOn: json['end_on'] as String,
  plannedEndOn: json['planned_end_on'] as String,
  completedOn: json['completed_on'] as String,
  assigneeAccountIds: (json['assignee_account_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lateness: Lateness.fromJson(json['lateness'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GanttTaskToJson(_GanttTask instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'program_id': instance.programId,
      'department_id': instance.departmentId,
      'priority': _$GanttTaskPriorityEnumMap[instance.priority]!,
      'status': instance.status,
      'start_on': instance.startOn,
      'end_on': instance.endOn,
      'planned_end_on': instance.plannedEndOn,
      'completed_on': instance.completedOn,
      'assignee_account_ids': instance.assigneeAccountIds,
      'lateness': instance.lateness.toJson(),
    };

const _$GanttTaskPriorityEnumMap = {
  GanttTaskPriority.dusuk: 'dusuk',
  GanttTaskPriority.orta: 'orta',
  GanttTaskPriority.yuksek: 'yuksek',
  GanttTaskPriority.acil: 'acil',
  GanttTaskPriority.$unknown: r'$unknown',
};
