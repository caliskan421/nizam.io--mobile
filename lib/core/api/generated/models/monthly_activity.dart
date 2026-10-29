// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_activity.freezed.dart';
part 'monthly_activity.g.dart';

@Freezed()
abstract class MonthlyActivity with _$MonthlyActivity {
  const factory MonthlyActivity({
    required String month,
    @JsonKey(name: 'created_tasks') required int createdTasks,
    @JsonKey(name: 'completed_tasks') required int completedTasks,
    required int meetings,
    required int messages,
    required int count,
  }) = _MonthlyActivity;

  factory MonthlyActivity.fromJson(Map<String, Object?> json) =>
      _$MonthlyActivityFromJson(json);
}
