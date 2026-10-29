// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoordinatorshipStat _$CoordinatorshipStatFromJson(Map<String, dynamic> json) =>
    _CoordinatorshipStat(
      departmentId: json['department_id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String,
      coordinators: (json['coordinators'] as List<dynamic>)
          .map((e) => ReportPerson.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTasks: (json['total_tasks'] as num).toInt(),
      completedTasks: (json['completed_tasks'] as num).toInt(),
      inProgressTasks: (json['in_progress_tasks'] as num).toInt(),
      notStartedTasks: (json['not_started_tasks'] as num).toInt(),
      overdueTasks: (json['overdue_tasks'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      memberCount: (json['member_count'] as num).toInt(),
      meetingCount: (json['meeting_count'] as num).toInt(),
      lastActivityAt: json['last_activity_at'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CoordinatorshipStatToJson(
  _CoordinatorshipStat instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'name': instance.name,
  'kind': instance.kind,
  'coordinators': instance.coordinators.map((e) => e.toJson()).toList(),
  'total_tasks': instance.totalTasks,
  'completed_tasks': instance.completedTasks,
  'in_progress_tasks': instance.inProgressTasks,
  'not_started_tasks': instance.notStartedTasks,
  'overdue_tasks': instance.overdueTasks,
  'completion_rate': instance.completionRate,
  'member_count': instance.memberCount,
  'meeting_count': instance.meetingCount,
  'last_activity_at': ?instance.lastActivityAt,
  'description': ?instance.description,
};
