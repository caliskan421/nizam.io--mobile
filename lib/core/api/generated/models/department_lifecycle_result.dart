// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'department_lifecycle_result_status.dart';

part 'department_lifecycle_result.freezed.dart';
part 'department_lifecycle_result.g.dart';

@Freezed()
abstract class DepartmentLifecycleResult with _$DepartmentLifecycleResult {
  const factory DepartmentLifecycleResult({
    @JsonKey(name: 'department_id') required String departmentId,
    required DepartmentLifecycleResultStatus status,
  }) = _DepartmentLifecycleResult;

  factory DepartmentLifecycleResult.fromJson(Map<String, Object?> json) =>
      _$DepartmentLifecycleResultFromJson(json);
}
