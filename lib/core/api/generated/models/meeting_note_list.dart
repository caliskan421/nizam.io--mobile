// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_note.dart';

part 'meeting_note_list.freezed.dart';
part 'meeting_note_list.g.dart';

@Freezed()
abstract class MeetingNoteList with _$MeetingNoteList {
  const factory MeetingNoteList({
    required List<MeetingNote> items,
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _MeetingNoteList;

  factory MeetingNoteList.fromJson(Map<String, Object?> json) =>
      _$MeetingNoteListFromJson(json);
}
