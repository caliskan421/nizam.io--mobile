// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_result.freezed.dart';
part 'review_result.g.dart';

@Freezed()
abstract class ReviewResult with _$ReviewResult {
  const factory ReviewResult({
    @JsonKey(name: 'affected_tasks_count') required int affectedTasksCount,
  }) = _ReviewResult;

  factory ReviewResult.fromJson(Map<String, Object?> json) =>
      _$ReviewResultFromJson(json);
}
