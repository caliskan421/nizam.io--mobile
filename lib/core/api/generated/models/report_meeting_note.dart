// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_meeting_note_author_role.dart';
import 'report_person.dart';

part 'report_meeting_note.freezed.dart';
part 'report_meeting_note.g.dart';

@Freezed()
abstract class ReportMeetingNote with _$ReportMeetingNote {
  const factory ReportMeetingNote({
    @JsonKey(name: 'note_id') required String noteId,
    required String content,
    required ReportPerson author,

    /// Yazarın rol kopyası; rolü kaydedilmemiş eski notlarda boş dizge.
    @JsonKey(name: 'author_role')
    required ReportMeetingNoteAuthorRole authorRole,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'converted_to_task_id') required String? convertedToTaskId,
    @JsonKey(name: 'converted_task_title') required String? convertedTaskTitle,
  }) = _ReportMeetingNote;

  factory ReportMeetingNote.fromJson(Map<String, Object?> json) =>
      _$ReportMeetingNoteFromJson(json);
}
