// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_task.dart';
import 'report_task_note.dart';
import 'report_task_ref.dart';

part 'report_task_detail.freezed.dart';
part 'report_task_detail.g.dart';

@Freezed()
abstract class ReportTaskDetail with _$ReportTaskDetail {
  const factory ReportTaskDetail({
    required ReportTask task,
    required String description,
    required List<ReportTaskRef> dependencies,
    @JsonKey(name: 'recent_notes') required List<ReportTaskNote> recentNotes,
  }) = _ReportTaskDetail;

  factory ReportTaskDetail.fromJson(Map<String, Object?> json) =>
      _$ReportTaskDetailFromJson(json);
}
