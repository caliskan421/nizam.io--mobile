// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meeting_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMeetingNote _$ReportMeetingNoteFromJson(Map<String, dynamic> json) =>
    _ReportMeetingNote(
      noteId: json['note_id'] as String,
      content: json['content'] as String,
      author: ReportPerson.fromJson(json['author'] as Map<String, dynamic>),
      authorRole: ReportMeetingNoteAuthorRole.fromJson(
        json['author_role'] as String,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      convertedToTaskId: json['converted_to_task_id'] as String?,
      convertedTaskTitle: json['converted_task_title'] as String?,
    );

Map<String, dynamic> _$ReportMeetingNoteToJson(_ReportMeetingNote instance) =>
    <String, dynamic>{
      'note_id': instance.noteId,
      'content': instance.content,
      'author': instance.author.toJson(),
      'author_role': _$ReportMeetingNoteAuthorRoleEnumMap[instance.authorRole]!,
      'created_at': instance.createdAt.toIso8601String(),
      'converted_to_task_id': ?instance.convertedToTaskId,
      'converted_task_title': ?instance.convertedTaskTitle,
    };

const _$ReportMeetingNoteAuthorRoleEnumMap = {
  ReportMeetingNoteAuthorRole.empty: '',
  ReportMeetingNoteAuthorRole.admin: 'admin',
  ReportMeetingNoteAuthorRole.coordinator: 'coordinator',
  ReportMeetingNoteAuthorRole.member: 'member',
  ReportMeetingNoteAuthorRole.$unknown: r'$unknown',
};
