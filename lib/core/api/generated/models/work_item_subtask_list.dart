// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item_subtask.dart';

part 'work_item_subtask_list.freezed.dart';
part 'work_item_subtask_list.g.dart';

@Freezed()
abstract class WorkItemSubtaskList with _$WorkItemSubtaskList {
  const factory WorkItemSubtaskList({
    required List<WorkItemSubtask> subtasks,
    required int total,
  }) = _WorkItemSubtaskList;

  factory WorkItemSubtaskList.fromJson(Map<String, Object?> json) =>
      _$WorkItemSubtaskListFromJson(json);
}
