// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'by_status.dart';

part 'program_work_item_counts.freezed.dart';
part 'program_work_item_counts.g.dart';

@Freezed()
abstract class ProgramWorkItemCounts with _$ProgramWorkItemCounts {
  const factory ProgramWorkItemCounts({
    /// Görünür canlı görev sayısı (süzgeçlerle).
    required int total,
    @JsonKey(name: 'by_status') required ByStatus byStatus,

    /// Tamamlanmamış ve `end_on` < bugün (kurulum saat dilimi) olan görev sayısı.
    required int overdue,

    /// Bekleyen tarih talebi olan görünür görev sayısı (WORK-K82 satır kuralı; üyede 0).
    @JsonKey(name: 'pending_date_requests') required int pendingDateRequests,
  }) = _ProgramWorkItemCounts;

  factory ProgramWorkItemCounts.fromJson(Map<String, Object?> json) =>
      _$ProgramWorkItemCountsFromJson(json);
}
