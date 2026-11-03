// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_work_note_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateWorkNoteRequest _$UpdateWorkNoteRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkNoteRequest(
  content: json['content'] as String,
  expectedRevision: (json['expected_revision'] as num).toInt(),
);

Map<String, dynamic> _$UpdateWorkNoteRequestToJson(
  _UpdateWorkNoteRequest instance,
) => <String, dynamic>{
  'content': instance.content,
  'expected_revision': instance.expectedRevision,
};
