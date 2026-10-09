// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_summary.freezed.dart';
part 'task_summary.g.dart';

@Freezed()
abstract class TaskSummary with _$TaskSummary {
  const factory TaskSummary({
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'active_items') required int activeItems,
    @JsonKey(name: 'completed_items') required int completedItems,
  }) = _TaskSummary;

  factory TaskSummary.fromJson(Map<String, Object?> json) =>
      _$TaskSummaryFromJson(json);
}
