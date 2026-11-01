// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_department.freezed.dart';
part 'program_department.g.dart';

@Freezed()
abstract class ProgramDepartment with _$ProgramDepartment {
  const factory ProgramDepartment({
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın bu programdaki adı.
    @JsonKey(name: 'display_name') required String displayName,

    /// Katalog kodu; kod verilmemişse alan yoktur.
    String? code,
  }) = _ProgramDepartment;

  factory ProgramDepartment.fromJson(Map<String, Object?> json) =>
      _$ProgramDepartmentFromJson(json);
}
