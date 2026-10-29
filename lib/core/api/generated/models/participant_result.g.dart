// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantResult _$ParticipantResultFromJson(Map<String, dynamic> json) =>
    _ParticipantResult(
      meetingId: json['meeting_id'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ParticipantResultToJson(_ParticipantResult instance) =>
    <String, dynamic>{
      'meeting_id': instance.meetingId,
      'user_id': instance.userId,
    };
