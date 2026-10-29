// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_department.freezed.dart';
part 'report_department.g.dart';

@Freezed()
abstract class ReportDepartment with _$ReportDepartment {
  const factory ReportDepartment({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    String? kind,
  }) = _ReportDepartment;

  factory ReportDepartment.fromJson(Map<String, Object?> json) =>
      _$ReportDepartmentFromJson(json);
}
