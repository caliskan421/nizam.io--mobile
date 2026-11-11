// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_work_note_request.freezed.dart';
part 'update_work_note_request.g.dart';

@Freezed()
abstract class UpdateWorkNoteRequest with _$UpdateWorkNoteRequest {
  const factory UpdateWorkNoteRequest({
    /// Not içeriği. Sunucu baş/son boşluğu kırpar; sonuç boş olamaz, kontrol karakteri taşıyamaz ve en çok 10000 karakterdir (Unicode kod noktası/rune, kırpmadan sonra ölçülür); aksi 422 `work.input_invalid` (alan `content`).
    required String content,

    /// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `work.input_invalid` + `work.revision_required`, pozitif değilse `work.revision_invalid`; bayatsa ve içerik farklıysa 409 `work.edit_conflict`. Tamsayı olmayan değer 422 `platform.body_invalid` (alan bilgisi yok).
    @JsonKey(name: 'expected_revision') required int expectedRevision,
  }) = _UpdateWorkNoteRequest;

  factory UpdateWorkNoteRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateWorkNoteRequestFromJson(json);
}
