// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'set_chat_reaction_request_kind.dart';

part 'set_chat_reaction_request.freezed.dart';
part 'set_chat_reaction_request.g.dart';

@Freezed()
abstract class SetChatReactionRequest with _$SetChatReactionRequest {
  const factory SetChatReactionRequest({
    required SetChatReactionRequestKind kind,
  }) = _SetChatReactionRequest;

  factory SetChatReactionRequest.fromJson(Map<String, Object?> json) =>
      _$SetChatReactionRequestFromJson(json);
}
