// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_delete_impact_program.freezed.dart';
part 'department_delete_impact_program.g.dart';

@Freezed()
abstract class DepartmentDeleteImpactProgram
    with _$DepartmentDeleteImpactProgram {
  const factory DepartmentDeleteImpactProgram({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String? programName,

    /// Departmanın o programdaki adı; bağ yoksa null.
    @JsonKey(name: 'department_name') required String? departmentName,

    /// Departman bu programa hâlâ bağlı mı.
    required bool linked,
    @JsonKey(name: 'active_items') required int activeItems,
    @JsonKey(name: 'completed_items') required int completedItems,
    @JsonKey(name: 'deleted_items') required int deletedItems,
    @JsonKey(name: 'deleted_with_department')
    required int deletedWithDepartment,
  }) = _DepartmentDeleteImpactProgram;

  factory DepartmentDeleteImpactProgram.fromJson(Map<String, Object?> json) =>
      _$DepartmentDeleteImpactProgramFromJson(json);
}
