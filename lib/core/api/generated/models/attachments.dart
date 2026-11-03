// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachments.freezed.dart';
part 'attachments.g.dart';

@Freezed()
abstract class Attachments with _$Attachments {
  const factory Attachments({
    @JsonKey(name: 'attachment_id') required String attachmentId,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
  }) = _Attachments;

  factory Attachments.fromJson(Map<String, Object?> json) =>
      _$AttachmentsFromJson(json);
}
