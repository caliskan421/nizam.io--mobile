// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item_note.freezed.dart';
part 'work_item_note.g.dart';

@Freezed()
abstract class WorkItemNote with _$WorkItemNote {
  const factory WorkItemNote({
    @JsonKey(name: 'note_id') required String noteId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'author_account_id') required String authorAccountId,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _WorkItemNote;

  factory WorkItemNote.fromJson(Map<String, Object?> json) =>
      _$WorkItemNoteFromJson(json);
}
