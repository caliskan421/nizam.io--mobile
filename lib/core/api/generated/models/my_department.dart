// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_department.freezed.dart';
part 'my_department.g.dart';

@Freezed()
abstract class MyDepartment with _$MyDepartment {
  const factory MyDepartment({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required String role,
  }) = _MyDepartment;

  factory MyDepartment.fromJson(Map<String, Object?> json) =>
      _$MyDepartmentFromJson(json);
}
