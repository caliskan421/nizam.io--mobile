// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'program_department_detail_kind.dart';

part 'program_department_detail.freezed.dart';
part 'program_department_detail.g.dart';

@Freezed()
abstract class ProgramDepartmentDetail with _$ProgramDepartmentDetail {
  const factory ProgramDepartmentDetail({
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın bu programdaki adı.
    @JsonKey(name: 'display_name') required String displayName,
    required ProgramDepartmentDetailKind kind,

    /// Katalog kodu; kod verilmemişse alan yoktur.
    String? code,

    /// Katalog açıklaması; boşsa alan yoktur.
    String? description,
  }) = _ProgramDepartmentDetail;

  factory ProgramDepartmentDetail.fromJson(Map<String, Object?> json) =>
      _$ProgramDepartmentDetailFromJson(json);
}
