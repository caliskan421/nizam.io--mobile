// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SentMessage _$SentMessageFromJson(Map<String, dynamic> json) => _SentMessage(
  messageId: json['message_id'] as String,
  programId: json['program_id'] as String,
  receiverAccountId: json['receiver_account_id'] as String,
  subject: json['subject'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SentMessageToJson(_SentMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'program_id': instance.programId,
      'receiver_account_id': instance.receiverAccountId,
      'subject': instance.subject,
      'created_at': instance.createdAt.toIso8601String(),
    };
