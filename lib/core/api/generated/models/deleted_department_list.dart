// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'deleted_department.dart';

part 'deleted_department_list.freezed.dart';
part 'deleted_department_list.g.dart';

@Freezed()
abstract class DeletedDepartmentList with _$DeletedDepartmentList {
  const factory DeletedDepartmentList({
    required List<DeletedDepartment> departments,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _DeletedDepartmentList;

  factory DeletedDepartmentList.fromJson(Map<String, Object?> json) =>
      _$DeletedDepartmentListFromJson(json);
}
