// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_task_ref.freezed.dart';
part 'report_task_ref.g.dart';

@Freezed()
abstract class ReportTaskRef with _$ReportTaskRef {
  const factory ReportTaskRef({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    required String status,
    @JsonKey(name: 'department_name') required String departmentName,
  }) = _ReportTaskRef;

  factory ReportTaskRef.fromJson(Map<String, Object?> json) =>
      _$ReportTaskRefFromJson(json);
}
