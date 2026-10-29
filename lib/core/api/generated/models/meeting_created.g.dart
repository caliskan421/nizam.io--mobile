// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingCreated _$MeetingCreatedFromJson(Map<String, dynamic> json) =>
    _MeetingCreated(
      meeting: Meeting.fromJson(json['meeting'] as Map<String, dynamic>),
      failedParticipants: (json['failed_participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sideEffects: MeetingSideEffects.fromJson(
        json['side_effects'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MeetingCreatedToJson(_MeetingCreated instance) =>
    <String, dynamic>{
      'meeting': instance.meeting.toJson(),
      'failed_participants': ?instance.failedParticipants,
      'side_effects': instance.sideEffects.toJson(),
    };
