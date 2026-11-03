// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageQuote _$ChatMessageQuoteFromJson(Map<String, dynamic> json) =>
    _ChatMessageQuote(
      messageId: json['message_id'] as String,
      senderAccountId: json['sender_account_id'] as String?,
      senderName: json['sender_name'] as String?,
      body: json['body'] as String?,
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$ChatMessageQuoteToJson(_ChatMessageQuote instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'sender_account_id': ?instance.senderAccountId,
      'sender_name': ?instance.senderName,
      'body': ?instance.body,
      'deleted': instance.deleted,
    };
