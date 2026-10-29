// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_task.freezed.dart';
part 'archive_task.g.dart';

@Freezed()
abstract class ArchiveTask with _$ArchiveTask {
  const factory ArchiveTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'file_count') required int fileCount,
  }) = _ArchiveTask;

  factory ArchiveTask.fromJson(Map<String, Object?> json) =>
      _$ArchiveTaskFromJson(json);
}
