// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeasonReport _$SeasonReportFromJson(Map<String, dynamic> json) =>
    _SeasonReport(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      stats: Stats.fromJson(json['stats'] as Map<String, dynamic>),
      coordinatorshipPerformance:
          (json['coordinatorship_performance'] as List<dynamic>)
              .map(
                (e) => CoordinatorshipStat.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      taskStatusDistribution: Map<String, int>.from(
        json['task_status_distribution'] as Map,
      ),
      priorityDistribution: Map<String, int>.from(
        json['priority_distribution'] as Map,
      ),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => ReportTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      meetingStats: MeetingStats.fromJson(
        json['meeting_stats'] as Map<String, dynamic>,
      ),
      messageStats: MessageStats.fromJson(
        json['message_stats'] as Map<String, dynamic>,
      ),
      dateChangeStats: DateChangeStats.fromJson(
        json['date_change_stats'] as Map<String, dynamic>,
      ),
      monthlyActivity: (json['monthly_activity'] as List<dynamic>)
          .map((e) => MonthlyActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$SeasonReportToJson(
  _SeasonReport instance,
) => <String, dynamic>{
  'program_id': instance.programId,
  'program_name': instance.programName,
  'stats': instance.stats.toJson(),
  'coordinatorship_performance': instance.coordinatorshipPerformance
      .map((e) => e.toJson())
      .toList(),
  'task_status_distribution': instance.taskStatusDistribution,
  'priority_distribution': instance.priorityDistribution,
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
  'meeting_stats': instance.meetingStats.toJson(),
  'message_stats': instance.messageStats.toJson(),
  'date_change_stats': instance.dateChangeStats.toJson(),
  'monthly_activity': instance.monthlyActivity.map((e) => e.toJson()).toList(),
  'generated_at': instance.generatedAt.toIso8601String(),
};
