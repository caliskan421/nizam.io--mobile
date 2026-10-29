// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'gantt_task_priority.dart';
import 'lateness.dart';

part 'gantt_task.freezed.dart';
part 'gantt_task.g.dart';

@Freezed()
abstract class GanttTask with _$GanttTask {
  const factory GanttTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'department_id') required String departmentId,
    required GanttTaskPriority priority,
    required String status,
    @JsonKey(name: 'start_on') required String startOn,
    @JsonKey(name: 'end_on') required String endOn,

    /// Boşsa planlanan bitiş `end_on`'dur.
    @JsonKey(name: 'planned_end_on') required String plannedEndOn,

    /// Boşsa tamamlanmamış.
    @JsonKey(name: 'completed_on') required String completedOn,
    @JsonKey(name: 'assignee_account_ids')
    required List<String> assigneeAccountIds,
    required Lateness lateness,
  }) = _GanttTask;

  factory GanttTask.fromJson(Map<String, Object?> json) =>
      _$GanttTaskFromJson(json);
}
