// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingSummary _$MeetingSummaryFromJson(Map<String, dynamic> json) =>
    _MeetingSummary(
      agendaTotal: (json['agenda_total'] as num).toInt(),
      agendaChecked: (json['agenda_checked'] as num).toInt(),
      noteCount: (json['note_count'] as num).toInt(),
      connectedCount: (json['connected_count'] as num).toInt(),
      participantCount: (json['participant_count'] as num).toInt(),
      conferenceStatus: MeetingSummaryConferenceStatus.fromJson(
        json['conference_status'] as String,
      ),
      conferenceStartedAt: json['conference_started_at'] == null
          ? null
          : DateTime.parse(json['conference_started_at'] as String),
      conferenceEndedAt: json['conference_ended_at'] == null
          ? null
          : DateTime.parse(json['conference_ended_at'] as String),
    );

Map<String, dynamic> _$MeetingSummaryToJson(_MeetingSummary instance) =>
    <String, dynamic>{
      'agenda_total': instance.agendaTotal,
      'agenda_checked': instance.agendaChecked,
      'note_count': instance.noteCount,
      'connected_count': instance.connectedCount,
      'participant_count': instance.participantCount,
      'conference_status':
          _$MeetingSummaryConferenceStatusEnumMap[instance.conferenceStatus]!,
      'conference_started_at': ?instance.conferenceStartedAt?.toIso8601String(),
      'conference_ended_at': ?instance.conferenceEndedAt?.toIso8601String(),
    };

const _$MeetingSummaryConferenceStatusEnumMap = {
  MeetingSummaryConferenceStatus.none: 'none',
  MeetingSummaryConferenceStatus.starting: 'starting',
  MeetingSummaryConferenceStatus.live: 'live',
  MeetingSummaryConferenceStatus.ending: 'ending',
  MeetingSummaryConferenceStatus.ended: 'ended',
  MeetingSummaryConferenceStatus.$unknown: r'$unknown',
};
