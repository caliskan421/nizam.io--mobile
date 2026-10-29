// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../date_only.dart';

import 'work_item_priority.dart';
import 'work_item_status.dart';

part 'work_item.freezed.dart';
part 'work_item.g.dart';

@Freezed()
abstract class WorkItem with _$WorkItem {
  const factory WorkItem({
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'department_id') required String departmentId,
    required String title,
    required WorkItemPriority priority,
    required WorkItemStatus status,
    @JsonKey(name: 'assignee_account_ids')
    required List<String> assigneeAccountIds,
    @JsonKey(name: 'is_overdue') required bool isOverdue,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'is_completed_late') required bool isCompletedLate,
    @JsonKey(name: 'days_late') required int daysLate,
    @JsonKey(name: 'is_completed_early') required bool isCompletedEarly,
    @JsonKey(name: 'days_early') required int daysEarly,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,
    @DateOnlyConverter() @JsonKey(name: 'completed_on') DateTime? completedOn,
  }) = _WorkItem;

  factory WorkItem.fromJson(Map<String, Object?> json) =>
      _$WorkItemFromJson(json);
}
