// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    _SendMessageRequest(
      receiverAccountId: json['receiver_account_id'] as String,
      subject: json['subject'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$SendMessageRequestToJson(_SendMessageRequest instance) =>
    <String, dynamic>{
      'receiver_account_id': instance.receiverAccountId,
      'subject': instance.subject,
      'content': instance.content,
    };
