// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_person.dart';

part 'coordinatorship_stat.freezed.dart';
part 'coordinatorship_stat.g.dart';

@Freezed()
abstract class CoordinatorshipStat with _$CoordinatorshipStat {
  const factory CoordinatorshipStat({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required String kind,
    required List<ReportPerson> coordinators,
    @JsonKey(name: 'total_tasks') required int totalTasks,
    @JsonKey(name: 'completed_tasks') required int completedTasks,
    @JsonKey(name: 'in_progress_tasks') required int inProgressTasks,
    @JsonKey(name: 'not_started_tasks') required int notStartedTasks,
    @JsonKey(name: 'overdue_tasks') required int overdueTasks,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'member_count') required int memberCount,
    @JsonKey(name: 'meeting_count') required int meetingCount,
    @JsonKey(name: 'last_activity_at') required String? lastActivityAt,
    String? description,
  }) = _CoordinatorshipStat;

  factory CoordinatorshipStat.fromJson(Map<String, Object?> json) =>
      _$CoordinatorshipStatFromJson(json);
}
