// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  messageId: json['message_id'] as String,
  chatId: json['chat_id'] as String,
  seq: (json['seq'] as num).toInt(),
  senderAccountId: json['sender_account_id'] as String,
  clientMessageId: json['client_message_id'] as String,
  body: json['body'] as String,
  replyToMessageId: json['reply_to_message_id'] as String?,
  edited: json['edited'] as bool,
  editedAt: json['edited_at'] == null
      ? null
      : DateTime.parse(json['edited_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  mentions: (json['mentions'] as List<dynamic>)
      .map((e) => ChatMention.fromJson(e as Map<String, dynamic>))
      .toList(),
  refs: (json['refs'] as List<dynamic>)
      .map((e) => ChatMessageRef.fromJson(e as Map<String, dynamic>))
      .toList(),
  taskIds: (json['task_ids'] as List<dynamic>).map((e) => e as String).toList(),
  reactions: (json['reactions'] as List<dynamic>)
      .map((e) => Reactions.fromJson(e as Map<String, dynamic>))
      .toList(),
  pinnedAt: json['pinned_at'] == null
      ? null
      : DateTime.parse(json['pinned_at'] as String),
  poll: json['poll'] == null
      ? null
      : Poll2.fromJson(json['poll'] as Map<String, dynamic>),
  attachments: (json['attachments'] as List<dynamic>)
      .map((e) => Attachments.fromJson(e as Map<String, dynamic>))
      .toList(),
  editRevision: (json['edit_revision'] as num).toInt(),
  senderName: json['sender_name'] as String?,
  replyTo: json['reply_to'] == null
      ? null
      : ChatMessageQuote.fromJson(json['reply_to'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'chat_id': instance.chatId,
      'seq': instance.seq,
      'sender_account_id': instance.senderAccountId,
      'client_message_id': instance.clientMessageId,
      'body': instance.body,
      'reply_to_message_id': ?instance.replyToMessageId,
      'edited': instance.edited,
      'edited_at': ?instance.editedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'mentions': instance.mentions.map((e) => e.toJson()).toList(),
      'refs': instance.refs.map((e) => e.toJson()).toList(),
      'task_ids': instance.taskIds,
      'reactions': instance.reactions.map((e) => e.toJson()).toList(),
      'pinned_at': ?instance.pinnedAt?.toIso8601String(),
      'poll': ?instance.poll?.toJson(),
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'edit_revision': instance.editRevision,
      'sender_name': ?instance.senderName,
      'reply_to': ?instance.replyTo?.toJson(),
    };
