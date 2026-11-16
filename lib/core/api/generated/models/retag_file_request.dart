// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'retag_file_request_tag.dart';

part 'retag_file_request.freezed.dart';
part 'retag_file_request.g.dart';

@Freezed()
abstract class RetagFileRequest with _$RetagFileRequest {
  const factory RetagFileRequest({
    /// Kapalı etiket kümesi (RECORDS-K07).
    required RetagFileRequestTag tag,
  }) = _RetagFileRequest;

  factory RetagFileRequest.fromJson(Map<String, Object?> json) =>
      _$RetagFileRequestFromJson(json);
}
