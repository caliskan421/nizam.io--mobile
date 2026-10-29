// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_department.freezed.dart';
part 'meeting_department.g.dart';

@Freezed()
abstract class MeetingDepartment with _$MeetingDepartment {
  const factory MeetingDepartment({
    @JsonKey(name: 'department_id') required String departmentId,

    /// Bağ kurulduğu andaki departman adı.
    @JsonKey(name: 'department_name') required String departmentName,
  }) = _MeetingDepartment;

  factory MeetingDepartment.fromJson(Map<String, Object?> json) =>
      _$MeetingDepartmentFromJson(json);
}
