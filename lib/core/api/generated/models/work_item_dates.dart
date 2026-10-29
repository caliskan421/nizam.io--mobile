// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../date_only.dart';

part 'work_item_dates.freezed.dart';
part 'work_item_dates.g.dart';

@Freezed()
abstract class WorkItemDates with _$WorkItemDates {
  const factory WorkItemDates({
    @DateOnlyConverter() @JsonKey(name: 'start_on') required DateTime startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') required DateTime endOn,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,
    @DateOnlyConverter() @JsonKey(name: 'completed_on') DateTime? completedOn,
    @DateOnlyConverter()
    @JsonKey(name: 'original_completed_on')
    DateTime? originalCompletedOn,
    @DateOnlyConverter() @JsonKey(name: 'submitted_on') DateTime? submittedOn,
  }) = _WorkItemDates;

  factory WorkItemDates.fromJson(Map<String, Object?> json) =>
      _$WorkItemDatesFromJson(json);
}
