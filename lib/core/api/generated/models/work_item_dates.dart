// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item_dates.freezed.dart';
part 'work_item_dates.g.dart';

@Freezed()
abstract class WorkItemDates with _$WorkItemDates {
  const factory WorkItemDates({
    @JsonKey(name: 'start_on') required DateTime startOn,
    @JsonKey(name: 'end_on') required DateTime endOn,
    @JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,
    @JsonKey(name: 'completed_on') DateTime? completedOn,
    @JsonKey(name: 'original_completed_on') DateTime? originalCompletedOn,
    @JsonKey(name: 'submitted_on') DateTime? submittedOn,
  }) = _WorkItemDates;

  factory WorkItemDates.fromJson(Map<String, Object?> json) =>
      _$WorkItemDatesFromJson(json);
}
