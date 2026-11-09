// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LastConference _$LastConferenceFromJson(Map<String, dynamic> json) =>
    _LastConference(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      endReason: LastConferenceEndReason.fromJson(json['end_reason'] as String),
    );

Map<String, dynamic> _$LastConferenceToJson(_LastConference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'end_reason': _$LastConferenceEndReasonEnumMap[instance.endReason]!,
    };

const _$LastConferenceEndReasonEnumMap = {
  LastConferenceEndReason.endedByUser: 'ended_by_user',
  LastConferenceEndReason.meetingDeleted: 'meeting_deleted',
  LastConferenceEndReason.providerStartFailed: 'provider_start_failed',
  LastConferenceEndReason.providerFinished: 'provider_finished',
  LastConferenceEndReason.reconciledMissing: 'reconciled_missing',
  LastConferenceEndReason.$unknown: r'$unknown',
};
