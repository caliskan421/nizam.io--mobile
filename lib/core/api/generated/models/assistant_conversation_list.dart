// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assistant_conversation.dart';

part 'assistant_conversation_list.freezed.dart';
part 'assistant_conversation_list.g.dart';

@Freezed()
abstract class AssistantConversationList with _$AssistantConversationList {
  const factory AssistantConversationList({
    required List<AssistantConversation> conversations,
  }) = _AssistantConversationList;

  factory AssistantConversationList.fromJson(Map<String, Object?> json) =>
      _$AssistantConversationListFromJson(json);
}
