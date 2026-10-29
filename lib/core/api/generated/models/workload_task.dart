// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'workload_task_priority.dart';

part 'workload_task.freezed.dart';
part 'workload_task.g.dart';

@Freezed()
abstract class WorkloadTask with _$WorkloadTask {
  const factory WorkloadTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    required String status,
    required WorkloadTaskPriority priority,
    @DateOnlyConverter() @JsonKey(name: 'start_on') required DateTime startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') required DateTime endOn,
    @DateOnlyConverter()
    @JsonKey(name: 'completed_on')
    required DateTime? completedOn,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'department_name') required String departmentName,
    @JsonKey(name: 'is_overdue') required bool isOverdue,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'attachment_count') required int attachmentCount,
    @JsonKey(name: 'has_attachment') required bool hasAttachment,

    /// Görevin son notu; not yoksa alan gönderilmez.
    @JsonKey(name: 'latest_note') String? latestNote,
  }) = _WorkloadTask;

  factory WorkloadTask.fromJson(Map<String, Object?> json) =>
      _$WorkloadTaskFromJson(json);
}
