// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_meeting_department.freezed.dart';
part 'report_meeting_department.g.dart';

@Freezed()
abstract class ReportMeetingDepartment with _$ReportMeetingDepartment {
  const factory ReportMeetingDepartment({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required bool deleted,
  }) = _ReportMeetingDepartment;

  factory ReportMeetingDepartment.fromJson(Map<String, Object?> json) =>
      _$ReportMeetingDepartmentFromJson(json);
}
