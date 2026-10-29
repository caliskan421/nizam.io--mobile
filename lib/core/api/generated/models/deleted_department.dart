// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deleted_department.freezed.dart';
part 'deleted_department.g.dart';

@Freezed()
abstract class DeletedDepartment with _$DeletedDepartment {
  const factory DeletedDepartment({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required String kind,

    /// RFC 3339 (UTC); silinme zamanı okunamazsa boş.
    @JsonKey(name: 'deleted_at') required String deletedAt,
    String? code,
  }) = _DeletedDepartment;

  factory DeletedDepartment.fromJson(Map<String, Object?> json) =>
      _$DeletedDepartmentFromJson(json);
}
