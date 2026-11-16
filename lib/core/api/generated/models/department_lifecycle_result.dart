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

    /// `restored`: departmanla birlikte silinmiş ve geri gelen görev sayısı (ADR-0043).
    @JsonKey(name: 'work_items_restored') int? workItemsRestored,

    /// `purged`: kalıcı silinen görev sayısı.
    @JsonKey(name: 'work_items_deleted') int? workItemsDeleted,

    /// `purged`: kalıcı silinen dosya sayısı.
    @JsonKey(name: 'files_deleted') int? filesDeleted,

    /// `purged`: kaldırılan program bağı sayısı.
    @JsonKey(name: 'program_links_removed') int? programLinksRemoved,

    /// `purged`: departmanla silinen ekip satırı sayısı (bağ kaldırmada silinenler hariç).
    @JsonKey(name: 'memberships_deleted') int? membershipsDeleted,
  }) = _DepartmentLifecycleResult;

  factory DepartmentLifecycleResult.fromJson(Map<String, Object?> json) =>
      _$DepartmentLifecycleResultFromJson(json);
}
