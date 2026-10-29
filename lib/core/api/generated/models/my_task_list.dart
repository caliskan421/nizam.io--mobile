// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'my_task.dart';

part 'my_task_list.freezed.dart';
part 'my_task_list.g.dart';

@Freezed()
abstract class MyTaskList with _$MyTaskList {
  const factory MyTaskList({required List<MyTask> items}) = _MyTaskList;

  factory MyTaskList.fromJson(Map<String, Object?> json) =>
      _$MyTaskListFromJson(json);
}
