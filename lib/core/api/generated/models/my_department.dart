// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_department.freezed.dart';
part 'my_department.g.dart';

/// Çağıranın bir programdaki ekip satırı (ekip programa göredir, ADR-0023).
@Freezed()
abstract class MyDepartment with _$MyDepartment {
  const factory MyDepartment({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın bu programdaki adı.
    @JsonKey(name: 'display_name') required String displayName,
    required String role,
  }) = _MyDepartment;

  factory MyDepartment.fromJson(Map<String, Object?> json) =>
      _$MyDepartmentFromJson(json);
}
