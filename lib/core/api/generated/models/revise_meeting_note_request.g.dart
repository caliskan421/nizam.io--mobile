// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revise_meeting_note_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviseMeetingNoteRequest _$ReviseMeetingNoteRequestFromJson(
  Map<String, dynamic> json,
) => _ReviseMeetingNoteRequest(
  content: json['content'] as String,
  expectedRevision: (json['expected_revision'] as num).toInt(),
);

Map<String, dynamic> _$ReviseMeetingNoteRequestToJson(
  _ReviseMeetingNoteRequest instance,
) => <String, dynamic>{
  'content': instance.content,
  'expected_revision': instance.expectedRevision,
};
