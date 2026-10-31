// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtask_counts.freezed.dart';
part 'subtask_counts.g.dart';

@Freezed()
abstract class SubtaskCounts with _$SubtaskCounts {
  const factory SubtaskCounts({required int total, required int done}) =
      _SubtaskCounts;

  factory SubtaskCounts.fromJson(Map<String, Object?> json) =>
      _$SubtaskCountsFromJson(json);
}
