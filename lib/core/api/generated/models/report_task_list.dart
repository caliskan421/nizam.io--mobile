// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_task.dart';

part 'report_task_list.freezed.dart';
part 'report_task_list.g.dart';

@Freezed()
abstract class ReportTaskList with _$ReportTaskList {
  const factory ReportTaskList({
    required List<ReportTask> tasks,
    required int total,
  }) = _ReportTaskList;

  factory ReportTaskList.fromJson(Map<String, Object?> json) =>
      _$ReportTaskListFromJson(json);
}
