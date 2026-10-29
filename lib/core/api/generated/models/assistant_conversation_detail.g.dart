// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_conversation_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantConversationDetail _$AssistantConversationDetailFromJson(
  Map<String, dynamic> json,
) => _AssistantConversationDetail(
  conversation: AssistantConversation.fromJson(
    json['conversation'] as Map<String, dynamic>,
  ),
  messages: (json['messages'] as List<dynamic>)
      .map((e) => AssistantMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AssistantConversationDetailToJson(
  _AssistantConversationDetail instance,
) => <String, dynamic>{
  'conversation': instance.conversation.toJson(),
  'messages': instance.messages.map((e) => e.toJson()).toList(),
};
