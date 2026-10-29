// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overdue_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OverdueTask _$OverdueTaskFromJson(Map<String, dynamic> json) => _OverdueTask(
  workItemId: json['work_item_id'] as String,
  title: json['title'] as String,
  departmentId: json['department_id'] as String,
  departmentName: json['department_name'] as String,
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => ReportPerson.fromJson(e as Map<String, dynamic>))
      .toList(),
  dueOn: const DateOnlyConverter().fromJson(json['due_on'] as String),
  daysOverdue: (json['days_overdue'] as num).toInt(),
);

Map<String, dynamic> _$OverdueTaskToJson(_OverdueTask instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'assignees': instance.assignees.map((e) => e.toJson()).toList(),
      'due_on': const DateOnlyConverter().toJson(instance.dueOn),
      'days_overdue': instance.daysOverdue,
    };
