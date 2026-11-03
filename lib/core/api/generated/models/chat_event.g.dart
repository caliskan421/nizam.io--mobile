// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatEvent _$ChatEventFromJson(Map<String, dynamic> json) => _ChatEvent(
  chatId: json['chat_id'] as String,
  messageId: json['message_id'] as String?,
  actorAccountId: json['actor_account_id'] as String,
  affectedAccountIds: (json['affected_account_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ChatEventToJson(_ChatEvent instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'message_id': ?instance.messageId,
      'actor_account_id': instance.actorAccountId,
      'affected_account_ids': instance.affectedAccountIds,
    };
