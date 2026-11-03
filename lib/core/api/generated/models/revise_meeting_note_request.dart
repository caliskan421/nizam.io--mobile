// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'revise_meeting_note_request.freezed.dart';
part 'revise_meeting_note_request.g.dart';

@Freezed()
abstract class ReviseMeetingNoteRequest with _$ReviseMeetingNoteRequest {
  const factory ReviseMeetingNoteRequest({
    required String content,

    /// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `collaboration.input_invalid` + `collaboration.revision_required`, pozitif değilse `collaboration.revision_invalid`; bayatsa ve içerik farklıysa 409 `collaboration.edit_conflict`. Tamsayı olmayan değer 422 `collaboration.input_invalid` (alan `body`).
    @JsonKey(name: 'expected_revision') required int expectedRevision,
  }) = _ReviseMeetingNoteRequest;

  factory ReviseMeetingNoteRequest.fromJson(Map<String, Object?> json) =>
      _$ReviseMeetingNoteRequestFromJson(json);
}
