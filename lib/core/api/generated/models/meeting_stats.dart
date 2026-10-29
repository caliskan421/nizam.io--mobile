// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_stats.freezed.dart';
part 'meeting_stats.g.dart';

@Freezed()
abstract class MeetingStats with _$MeetingStats {
  const factory MeetingStats({
    @JsonKey(name: 'total_meetings') required int totalMeetings,
    @JsonKey(name: 'total_notes') required int totalNotes,
    @JsonKey(name: 'converted_to_task') required int convertedToTask,
    @JsonKey(name: 'total_participants') required int totalParticipants,
  }) = _MeetingStats;

  factory MeetingStats.fromJson(Map<String, Object?> json) =>
      _$MeetingStatsFromJson(json);
}
