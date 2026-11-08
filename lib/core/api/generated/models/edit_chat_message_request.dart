// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_chat_message_request.freezed.dart';
part 'edit_chat_message_request.g.dart';

@Freezed()
abstract class EditChatMessageRequest with _$EditChatMessageRequest {
  const factory EditChatMessageRequest({
    required String body,

    /// İstemcinin gördüğü mesaj `edit_revision` değeri (ADR-0027). Eksikse 422 `messaging.input_invalid` + `messaging.revision_required`, pozitif değilse `messaging.revision_invalid`; bayatsa ve gövde farklıysa 409 `messaging.edit_conflict`. Tamsayı olmayan değer 422 `messaging.input_invalid` (alan `body`).
    @JsonKey(name: 'expected_revision') required int expectedRevision,
  }) = _EditChatMessageRequest;

  factory EditChatMessageRequest.fromJson(Map<String, Object?> json) =>
      _$EditChatMessageRequestFromJson(json);
}
