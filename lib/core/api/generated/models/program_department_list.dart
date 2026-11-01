// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'program_department.dart';

part 'program_department_list.freezed.dart';
part 'program_department_list.g.dart';

@Freezed()
abstract class ProgramDepartmentList with _$ProgramDepartmentList {
  const factory ProgramDepartmentList({
    required List<ProgramDepartment> departments,
  }) = _ProgramDepartmentList;

  factory ProgramDepartmentList.fromJson(Map<String, Object?> json) =>
      _$ProgramDepartmentListFromJson(json);
}
