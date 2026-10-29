// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinatorship_stat.dart';
import 'overdue_task.dart';

part 'dashboard_report.freezed.dart';
part 'dashboard_report.g.dart';

@Freezed()
abstract class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    @JsonKey(name: 'total_coordinatorships') required int totalCoordinatorships,
    @JsonKey(name: 'total_tasks') required int totalTasks,
    @JsonKey(name: 'active_tasks') required int activeTasks,
    @JsonKey(name: 'completed_tasks') required int completedTasks,
    @JsonKey(name: 'overdue_tasks') required int overdueTasks,
    @JsonKey(name: 'pending_approvals') required int pendingApprovals,
    @JsonKey(name: 'pending_date_changes') required int pendingDateChanges,
    @JsonKey(name: 'task_status_distribution')
    required Map<String, int> taskStatusDistribution,
    @JsonKey(name: 'priority_distribution')
    required Map<String, int> priorityDistribution,
    @JsonKey(name: 'total_users') required int totalUsers,
    @JsonKey(name: 'total_admins') required int totalAdmins,
    @JsonKey(name: 'total_coordinators') required int totalCoordinators,
    @JsonKey(name: 'total_members') required int totalMembers,
    @JsonKey(name: 'deleted_records') required int deletedRecords,
    @JsonKey(name: 'coordinatorship_stats')
    required List<CoordinatorshipStat> coordinatorshipStats,
    @JsonKey(name: 'overdue_tasks_list')
    required List<OverdueTask> overdueTasksList,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
  }) = _DashboardReport;

  factory DashboardReport.fromJson(Map<String, Object?> json) =>
      _$DashboardReportFromJson(json);
}
