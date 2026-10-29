// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_side_effects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingSideEffects _$MeetingSideEffectsFromJson(Map<String, dynamic> json) =>
    _MeetingSideEffects(
      failedMessages: (json['failed_messages'] as num).toInt(),
      eventFailed: json['event_failed'] as bool,
    );

Map<String, dynamic> _$MeetingSideEffectsToJson(_MeetingSideEffects instance) =>
    <String, dynamic>{
      'failed_messages': instance.failedMessages,
      'event_failed': instance.eventFailed,
    };
