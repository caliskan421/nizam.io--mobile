// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_note.dart';

part 'note_converted.freezed.dart';
part 'note_converted.g.dart';

@Freezed()
abstract class NoteConverted with _$NoteConverted {
  const factory NoteConverted({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required MeetingNote note,
  }) = _NoteConverted;

  factory NoteConverted.fromJson(Map<String, Object?> json) =>
      _$NoteConvertedFromJson(json);
}
