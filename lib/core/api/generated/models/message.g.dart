// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  messageId: json['message_id'] as String,
  programId: json['program_id'] as String,
  senderAccountId: json['sender_account_id'] as String,
  senderName: json['sender_name'] as String,
  receiverAccountId: json['receiver_account_id'] as String,
  receiverName: json['receiver_name'] as String,
  subject: json['subject'] as String,
  content: json['content'] as String,
  isRead: json['is_read'] as bool,
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'message_id': instance.messageId,
  'program_id': instance.programId,
  'sender_account_id': instance.senderAccountId,
  'sender_name': instance.senderName,
  'receiver_account_id': instance.receiverAccountId,
  'receiver_name': instance.receiverName,
  'subject': instance.subject,
  'content': instance.content,
  'is_read': instance.isRead,
  'read_at': ?instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
