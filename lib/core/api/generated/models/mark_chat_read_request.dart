// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_chat_read_request.freezed.dart';
part 'mark_chat_read_request.g.dart';

@Freezed()
abstract class MarkChatReadRequest with _$MarkChatReadRequest {
  const factory MarkChatReadRequest({
    @JsonKey(name: 'message_id') required String messageId,
  }) = _MarkChatReadRequest;

  factory MarkChatReadRequest.fromJson(Map<String, Object?> json) =>
      _$MarkChatReadRequestFromJson(json);
}
