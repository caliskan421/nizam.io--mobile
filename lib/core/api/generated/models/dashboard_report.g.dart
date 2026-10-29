// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardReport _$DashboardReportFromJson(Map<String, dynamic> json) =>
    _DashboardReport(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      totalCoordinatorships: (json['total_coordinatorships'] as num).toInt(),
      totalTasks: (json['total_tasks'] as num).toInt(),
      activeTasks: (json['active_tasks'] as num).toInt(),
      completedTasks: (json['completed_tasks'] as num).toInt(),
      overdueTasks: (json['overdue_tasks'] as num).toInt(),
      pendingApprovals: (json['pending_approvals'] as num).toInt(),
      pendingDateChanges: (json['pending_date_changes'] as num).toInt(),
      taskStatusDistribution: Map<String, int>.from(
        json['task_status_distribution'] as Map,
      ),
      priorityDistribution: Map<String, int>.from(
        json['priority_distribution'] as Map,
      ),
      totalUsers: (json['total_users'] as num).toInt(),
      totalAdmins: (json['total_admins'] as num).toInt(),
      totalCoordinators: (json['total_coordinators'] as num).toInt(),
      totalMembers: (json['total_members'] as num).toInt(),
      deletedRecords: (json['deleted_records'] as num).toInt(),
      coordinatorshipStats: (json['coordinatorship_stats'] as List<dynamic>)
          .map((e) => CoordinatorshipStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      overdueTasksList: (json['overdue_tasks_list'] as List<dynamic>)
          .map((e) => OverdueTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$DashboardReportToJson(_DashboardReport instance) =>
    <String, dynamic>{
      'program_id': instance.programId,
      'program_name': instance.programName,
      'total_coordinatorships': instance.totalCoordinatorships,
      'total_tasks': instance.totalTasks,
      'active_tasks': instance.activeTasks,
      'completed_tasks': instance.completedTasks,
      'overdue_tasks': instance.overdueTasks,
      'pending_approvals': instance.pendingApprovals,
      'pending_date_changes': instance.pendingDateChanges,
      'task_status_distribution': instance.taskStatusDistribution,
      'priority_distribution': instance.priorityDistribution,
      'total_users': instance.totalUsers,
      'total_admins': instance.totalAdmins,
      'total_coordinators': instance.totalCoordinators,
      'total_members': instance.totalMembers,
      'deleted_records': instance.deletedRecords,
      'coordinatorship_stats': instance.coordinatorshipStats
          .map((e) => e.toJson())
          .toList(),
      'overdue_tasks_list': instance.overdueTasksList
          .map((e) => e.toJson())
          .toList(),
      'generated_at': instance.generatedAt.toIso8601String(),
    };
