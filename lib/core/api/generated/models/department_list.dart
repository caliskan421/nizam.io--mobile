// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'department.dart';

part 'department_list.freezed.dart';
part 'department_list.g.dart';

@Freezed()
abstract class DepartmentList with _$DepartmentList {
  const factory DepartmentList({required List<Department> departments}) =
      _DepartmentList;

  factory DepartmentList.fromJson(Map<String, Object?> json) =>
      _$DepartmentListFromJson(json);
}
