// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_attachment_meta.freezed.dart';
part 'table_attachment_meta.g.dart';

@Freezed()
abstract class TableAttachmentMeta with _$TableAttachmentMeta {
  const factory TableAttachmentMeta({
    required String id,

    /// Görünen dosya adı (NFC, kırpılmış).
    required String name,

    /// İzinli 11 türden biri (kanonik MIME).
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
  }) = _TableAttachmentMeta;

  factory TableAttachmentMeta.fromJson(Map<String, Object?> json) =>
      _$TableAttachmentMetaFromJson(json);
}
