// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinatorship_stat.dart';
import 'date_change_stats.dart';
import 'meeting_stats.dart';
import 'message_stats.dart';
import 'monthly_activity.dart';
import 'report_task.dart';
import 'stats.dart';

part 'season_report.freezed.dart';
part 'season_report.g.dart';

@Freezed()
abstract class SeasonReport with _$SeasonReport {
  const factory SeasonReport({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    required Stats stats,
    @JsonKey(name: 'coordinatorship_performance')
    required List<CoordinatorshipStat> coordinatorshipPerformance,
    @JsonKey(name: 'task_status_distribution')
    required Map<String, int> taskStatusDistribution,
    @JsonKey(name: 'priority_distribution')
    required Map<String, int> priorityDistribution,
    required List<ReportTask> tasks,
    @JsonKey(name: 'meeting_stats') required MeetingStats meetingStats,
    @JsonKey(name: 'message_stats') required MessageStats messageStats,
    @JsonKey(name: 'date_change_stats')
    required DateChangeStats dateChangeStats,
    @JsonKey(name: 'monthly_activity')
    required List<MonthlyActivity> monthlyActivity,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
  }) = _SeasonReport;

  factory SeasonReport.fromJson(Map<String, Object?> json) =>
      _$SeasonReportFromJson(json);
}
