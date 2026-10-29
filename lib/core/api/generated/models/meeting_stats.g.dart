// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingStats _$MeetingStatsFromJson(Map<String, dynamic> json) =>
    _MeetingStats(
      totalMeetings: (json['total_meetings'] as num).toInt(),
      totalNotes: (json['total_notes'] as num).toInt(),
      convertedToTask: (json['converted_to_task'] as num).toInt(),
      totalParticipants: (json['total_participants'] as num).toInt(),
    );

Map<String, dynamic> _$MeetingStatsToJson(_MeetingStats instance) =>
    <String, dynamic>{
      'total_meetings': instance.totalMeetings,
      'total_notes': instance.totalNotes,
      'converted_to_task': instance.convertedToTask,
      'total_participants': instance.totalParticipants,
    };
