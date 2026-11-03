// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendChatMessageRequest _$SendChatMessageRequestFromJson(
  Map<String, dynamic> json,
) => _SendChatMessageRequest(
  clientMessageId: json['client_message_id'] as String,
  body: json['body'] as String,
  replyToMessageId: json['reply_to_message_id'] as String?,
  mentions: (json['mentions'] as List<dynamic>?)
      ?.map((e) => ChatMention.fromJson(e as Map<String, dynamic>))
      .toList(),
  poll: json['poll'] == null
      ? null
      : Poll.fromJson(json['poll'] as Map<String, dynamic>),
  refs: (json['refs'] as List<dynamic>?)
      ?.map((e) => Refs.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SendChatMessageRequestToJson(
  _SendChatMessageRequest instance,
) => <String, dynamic>{
  'client_message_id': instance.clientMessageId,
  'body': instance.body,
  'reply_to_message_id': ?instance.replyToMessageId,
  'mentions': ?instance.mentions?.map((e) => e.toJson()).toList(),
  'poll': ?instance.poll?.toJson(),
  'refs': ?instance.refs?.map((e) => e.toJson()).toList(),
};
