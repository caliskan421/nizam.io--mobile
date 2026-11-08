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

    /// Yazarın görünen adı; ad çözülemezse (geçici okuma hatası dahil) `null`.
    @JsonKey(name: 'author_full_name') required String? authorFullName,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Not içeriğinin düzenleme sürümü (ADR-0027).
    @JsonKey(name: 'edit_revision') required int editRevision,
  }) = _WorkItemNote;

  factory WorkItemNote.fromJson(Map<String, Object?> json) =>
      _$WorkItemNoteFromJson(json);
}
