// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_last_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatLastMessage _$ChatLastMessageFromJson(Map<String, dynamic> json) =>
    _ChatLastMessage(
      messageId: json['message_id'] as String,
      seq: (json['seq'] as num).toInt(),
      senderAccountId: json['sender_account_id'] as String,
      senderName: json['sender_name'] as String,
      body: json['body'] as String?,
      deleted: json['deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChatLastMessageToJson(_ChatLastMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'seq': instance.seq,
      'sender_account_id': instance.senderAccountId,
      'sender_name': instance.senderName,
      'body': ?instance.body,
      'deleted': instance.deleted,
      'created_at': instance.createdAt.toIso8601String(),
    };
