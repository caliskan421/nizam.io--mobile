// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'report_person.dart';

part 'overdue_task.freezed.dart';
part 'overdue_task.g.dart';

@Freezed()
abstract class OverdueTask with _$OverdueTask {
  const factory OverdueTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'department_name') required String departmentName,
    required List<ReportPerson> assignees,
    @DateOnlyConverter() @JsonKey(name: 'due_on') required DateTime dueOn,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
  }) = _OverdueTask;

  factory OverdueTask.fromJson(Map<String, Object?> json) =>
      _$OverdueTaskFromJson(json);
}
