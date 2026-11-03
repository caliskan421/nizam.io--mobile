// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_chat_request_source.dart';

part 'update_chat_request.freezed.dart';
part 'update_chat_request.g.dart';

/// Verilmeyen alan değişmez; en az biri gerekir.
@Freezed()
abstract class UpdateChatRequest with _$UpdateChatRequest {
  const factory UpdateChatRequest({
    String? name,
    UpdateChatRequestSource? source,
    @JsonKey(name: 'source_department_id') String? sourceDepartmentId,
  }) = _UpdateChatRequest;

  factory UpdateChatRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateChatRequestFromJson(json);
}
