// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingNote _$MeetingNoteFromJson(Map<String, dynamic> json) => _MeetingNote(
  noteId: json['note_id'] as String,
  meetingId: json['meeting_id'] as String,
  authorAccountId: json['author_account_id'] as String?,
  authorName: json['author_name'] as String,
  authorRole: json['author_role'] == null
      ? null
      : MeetingNoteAuthorRole.fromJson(json['author_role'] as String),
  content: json['content'] as String,
  convertedToWorkItemId: json['converted_to_work_item_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MeetingNoteToJson(_MeetingNote instance) =>
    <String, dynamic>{
      'note_id': instance.noteId,
      'meeting_id': instance.meetingId,
      'author_account_id': ?instance.authorAccountId,
      'author_name': instance.authorName,
      'author_role': ?_$MeetingNoteAuthorRoleEnumMap[instance.authorRole],
      'content': instance.content,
      'converted_to_work_item_id': ?instance.convertedToWorkItemId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$MeetingNoteAuthorRoleEnumMap = {
  MeetingNoteAuthorRole.admin: 'admin',
  MeetingNoteAuthorRole.coordinator: 'coordinator',
  MeetingNoteAuthorRole.member: 'member',
  MeetingNoteAuthorRole.$unknown: r'$unknown',
};
