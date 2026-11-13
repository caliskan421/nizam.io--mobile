// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_note_author_role.dart';

part 'meeting_note.freezed.dart';
part 'meeting_note.g.dart';

@Freezed()
abstract class MeetingNote with _$MeetingNote {
  const factory MeetingNote({
    @JsonKey(name: 'note_id') required String noteId,
    @JsonKey(name: 'meeting_id') required String meetingId,
    @JsonKey(name: 'author_account_id') required String? authorAccountId,
    @JsonKey(name: 'author_name') required String authorName,

    /// Yazarın rol kopyası; eski notlarda boş (null) olabilir.
    @JsonKey(name: 'author_role') required MeetingNoteAuthorRole? authorRole,
    required String content,
    @JsonKey(name: 'converted_to_work_item_id')
    required String? convertedToWorkItemId,

    /// Nottan açılan görevin dönüşüm anındaki hedef departmanı (COLLABORATION-K82). Görev toplantının programı (`X-Nizamio-Program`) ve bu departman (`X-Nizamio-Department`) ile `getWorkItem`'dan açılır; erişim work'ün kendi yetkisidir. Dönüşmemiş notta ve alan eklenmeden önce dönüşmüş notta null; görev sonradan aktarılırsa kopya bayatlar (GAP-222).
    @JsonKey(name: 'converted_work_item_department_id')
    required String? convertedWorkItemDepartmentId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Not içeriğinin düzenleme sürümü (ADR-0027); dönüşüm işareti ve silme artırmaz.
    @JsonKey(name: 'edit_revision') required int editRevision,
  }) = _MeetingNote;

  factory MeetingNote.fromJson(Map<String, Object?> json) =>
      _$MeetingNoteFromJson(json);
}
