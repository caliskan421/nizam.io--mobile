// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_task.freezed.dart';
part 'my_task.g.dart';

@Freezed()
abstract class MyTask with _$MyTask {
  const factory MyTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    required String status,
  }) = _MyTask;

  factory MyTask.fromJson(Map<String, Object?> json) => _$MyTaskFromJson(json);
}
