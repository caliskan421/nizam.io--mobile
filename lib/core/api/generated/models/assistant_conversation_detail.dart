// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assistant_conversation.dart';
import 'assistant_message.dart';

part 'assistant_conversation_detail.freezed.dart';
part 'assistant_conversation_detail.g.dart';

@Freezed()
abstract class AssistantConversationDetail with _$AssistantConversationDetail {
  const factory AssistantConversationDetail({
    required AssistantConversation conversation,
    required List<AssistantMessage> messages,
  }) = _AssistantConversationDetail;

  factory AssistantConversationDetail.fromJson(Map<String, Object?> json) =>
      _$AssistantConversationDetailFromJson(json);
}
