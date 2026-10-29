// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lateness.freezed.dart';
part 'lateness.g.dart';

@Freezed()
abstract class Lateness with _$Lateness {
  const factory Lateness({
    @JsonKey(name: 'is_overdue') required bool isOverdue,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'is_completed_late') required bool isCompletedLate,
    @JsonKey(name: 'days_late') required int daysLate,
    @JsonKey(name: 'is_completed_early') required bool isCompletedEarly,
    @JsonKey(name: 'days_early') required int daysEarly,
  }) = _Lateness;

  factory Lateness.fromJson(Map<String, Object?> json) =>
      _$LatenessFromJson(json);
}
