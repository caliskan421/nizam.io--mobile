// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_note_request.freezed.dart';
part 'work_note_request.g.dart';

@Freezed()
abstract class WorkNoteRequest with _$WorkNoteRequest {
  const factory WorkNoteRequest({
    /// Not içeriği. Sunucu baş/son boşluğu kırpar; sonuç boş olamaz, kontrol karakteri taşıyamaz ve en çok 10000 karakterdir (Unicode kod noktası/rune, kırpmadan sonra ölçülür); aksi 422 `work.input_invalid` (alan `content`).
    required String content,
  }) = _WorkNoteRequest;

  factory WorkNoteRequest.fromJson(Map<String, Object?> json) =>
      _$WorkNoteRequestFromJson(json);
}
