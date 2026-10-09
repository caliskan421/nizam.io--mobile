// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'my_department.dart';

part 'my_department_list.freezed.dart';
part 'my_department_list.g.dart';

@Freezed()
abstract class MyDepartmentList with _$MyDepartmentList {
  const factory MyDepartmentList({required List<MyDepartment>? departments}) =
      _MyDepartmentList;

  factory MyDepartmentList.fromJson(Map<String, Object?> json) =>
      _$MyDepartmentListFromJson(json);
}
