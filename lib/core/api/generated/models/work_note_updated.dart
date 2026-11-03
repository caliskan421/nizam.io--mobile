// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_note_updated.freezed.dart';
part 'work_note_updated.g.dart';

@Freezed()
abstract class WorkNoteUpdated with _$WorkNoteUpdated {
  const factory WorkNoteUpdated({
    /// Her zaman `updated`.
    required String status,

    /// Notun yeni düzenleme sürümü (ADR-0027); içerik zaten günceldeyse mevcut sürüm.
    @JsonKey(name: 'edit_revision') required int editRevision,
  }) = _WorkNoteUpdated;

  factory WorkNoteUpdated.fromJson(Map<String, Object?> json) =>
      _$WorkNoteUpdatedFromJson(json);
}
