// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'assignees.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@Freezed()
abstract class Task with _$Task {
  const factory Task({
    required String title,
    required String status,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'department_name') required String? departmentName,
    required List<Assignees> assignees,
    @DateOnlyConverter() @JsonKey(name: 'start_on') required DateTime startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') required DateTime endOn,
    required String description,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
