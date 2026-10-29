// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_conversation_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantConversationList _$AssistantConversationListFromJson(
  Map<String, dynamic> json,
) => _AssistantConversationList(
  conversations: (json['conversations'] as List<dynamic>)
      .map((e) => AssistantConversation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AssistantConversationListToJson(
  _AssistantConversationList instance,
) => <String, dynamic>{
  'conversations': instance.conversations.map((e) => e.toJson()).toList(),
};
