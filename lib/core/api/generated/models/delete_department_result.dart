// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_department_result.freezed.dart';
part 'delete_department_result.g.dart';

@Freezed()
abstract class DeleteDepartmentResult with _$DeleteDepartmentResult {
  const factory DeleteDepartmentResult({
    @JsonKey(name: 'department_id') required String departmentId,
    required bool deleted,
  }) = _DeleteDepartmentResult;

  factory DeleteDepartmentResult.fromJson(Map<String, Object?> json) =>
      _$DeleteDepartmentResultFromJson(json);
}
