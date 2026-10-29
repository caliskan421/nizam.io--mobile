// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_person.dart';
import 'report_task_priority.dart';

part 'report_task.freezed.dart';
part 'report_task.g.dart';

@Freezed()
abstract class ReportTask with _$ReportTask {
  const factory ReportTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'department_name') required String departmentName,
    required String status,
    required ReportTaskPriority priority,
    @JsonKey(name: 'start_on') required DateTime startOn,
    @JsonKey(name: 'end_on') required DateTime endOn,
    @JsonKey(name: 'planned_end_on') required DateTime? plannedEndOn,
    @JsonKey(name: 'completed_on') required DateTime? completedOn,
    @JsonKey(name: 'created_by') required ReportPerson createdBy,
    required List<ReportPerson> assignees,
    @JsonKey(name: 'is_overdue') required bool isOverdue,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'is_completed_late') required bool isCompletedLate,
    @JsonKey(name: 'days_late') required int daysLate,
    @JsonKey(name: 'is_completed_early') required bool isCompletedEarly,
    @JsonKey(name: 'days_early') required int daysEarly,
    @JsonKey(name: 'has_pending_dependency') required bool hasPendingDependency,
    @JsonKey(name: 'dependency_count') required int dependencyCount,
    @JsonKey(name: 'note_count') required int noteCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ReportTask;

  factory ReportTask.fromJson(Map<String, Object?> json) =>
      _$ReportTaskFromJson(json);
}
