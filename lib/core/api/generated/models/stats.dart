// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

@Freezed()
abstract class Stats with _$Stats {
  const factory Stats({
    @JsonKey(name: 'total_tasks') required int totalTasks,
    @JsonKey(name: 'completed_tasks') required int completedTasks,
    @JsonKey(name: 'completion_rate') required num completionRate,
    @JsonKey(name: 'overdue_tasks') required int overdueTasks,
    @JsonKey(name: 'total_notes') required int totalNotes,
    @JsonKey(name: 'total_attachments') required int totalAttachments,
    @JsonKey(name: 'total_meetings') required int totalMeetings,
    @JsonKey(name: 'total_messages') required int totalMessages,
    @JsonKey(name: 'total_coordinatorships') required int totalCoordinatorships,
    @JsonKey(name: 'total_users') required int totalUsers,
    @JsonKey(name: 'total_members') required int totalMembers,
  }) = _Stats;

  factory Stats.fromJson(Map<String, Object?> json) => _$StatsFromJson(json);
}
