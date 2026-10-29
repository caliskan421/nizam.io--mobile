import 'package:meta/meta.dart';

import 'report_common.dart';
import 'report_task.dart';

/// Dönem sayaçları (sunucu `Stats`).
@immutable
final class SeasonStats {
  const SeasonStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
    required this.overdueTasks,
    required this.totalNotes,
    required this.totalAttachments,
    required this.totalMeetings,
    required this.totalMessages,
    required this.totalCoordinatorships,
    required this.totalUsers,
    required this.totalMembers,
  });

  final int totalTasks;
  final int completedTasks;

  /// Yüzde (0–100).
  final double completionRate;
  final int overdueTasks;
  final int totalNotes;
  final int totalAttachments;
  final int totalMeetings;
  final int totalMessages;
  final int totalCoordinatorships;
  final int totalUsers;
  final int totalMembers;
}

/// Toplantı sayaçları.
@immutable
final class SeasonMeetingStats {
  const SeasonMeetingStats({
    required this.totalMeetings,
    required this.totalNotes,
    required this.convertedToTask,
    required this.totalParticipants,
  });

  final int totalMeetings;
  final int totalNotes;
  final int convertedToTask;
  final int totalParticipants;
}

/// Mesaj sayaçları.
@immutable
final class SeasonMessageStats {
  const SeasonMessageStats({
    required this.total,
    required this.fromAdmins,
    required this.fromOthers,
  });

  final int total;
  final int fromAdmins;
  final int fromOthers;
}

/// Tarih değişikliği talebi sayaçları.
@immutable
final class SeasonDateChangeStats {
  const SeasonDateChangeStats({
    required this.total,
    required this.approved,
    required this.rejected,
    required this.pending,
  });

  final int total;
  final int approved;
  final int rejected;
  final int pending;
}

/// Aylık etkinlik satırı. [month] sunucu dizgesi olduğu gibi (`YYYY-MM`; sözleşmede biçim
/// tanımsız), artan sırada.
@immutable
final class SeasonMonthlyActivity {
  const SeasonMonthlyActivity({
    required this.month,
    required this.createdTasks,
    required this.completedTasks,
    required this.meetings,
    required this.messages,
    required this.count,
  });

  final String month;
  final int createdTasks;
  final int completedTasks;
  final int meetings;
  final int messages;
  final int count;
}

/// Dönem raporu (`GET /v1/reports/season`): seçili programın tamamı; silinmiş kayıtlar
/// girmez (REPORTING-K08).
@immutable
final class SeasonReport {
  const SeasonReport({
    required this.programId,
    required this.programName,
    required this.stats,
    required this.coordinatorshipPerformance,
    required this.statusDistribution,
    required this.priorityDistribution,
    required this.tasks,
    required this.meetingStats,
    required this.messageStats,
    required this.dateChangeStats,
    required this.monthlyActivity,
    required this.generatedAt,
  });

  final String programId;
  final String programName;
  final SeasonStats stats;
  final List<ReportCoordinatorshipStat> coordinatorshipPerformance;

  /// Tanınmayan anahtarların toplamı [ReportTaskStatus.unknown] altındadır.
  final Map<ReportTaskStatus, int> statusDistribution;
  final Map<ReportPriority, int> priorityDistribution;
  final List<ReportTask> tasks;
  final SeasonMeetingStats meetingStats;
  final SeasonMessageStats messageStats;
  final SeasonDateChangeStats dateChangeStats;
  final List<SeasonMonthlyActivity> monthlyActivity;
  final DateTime generatedAt;
}
