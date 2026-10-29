// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'archive_task.dart';

part 'archive_tasks.freezed.dart';
part 'archive_tasks.g.dart';

@Freezed()
abstract class ArchiveTasks with _$ArchiveTasks {
  const factory ArchiveTasks({required List<ArchiveTask> tasks}) =
      _ArchiveTasks;

  factory ArchiveTasks.fromJson(Map<String, Object?> json) =>
      _$ArchiveTasksFromJson(json);
}
