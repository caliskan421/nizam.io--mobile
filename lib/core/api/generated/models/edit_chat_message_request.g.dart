// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_chat_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditChatMessageRequest _$EditChatMessageRequestFromJson(
  Map<String, dynamic> json,
) => _EditChatMessageRequest(
  body: json['body'] as String,
  expectedRevision: (json['expected_revision'] as num).toInt(),
);

Map<String, dynamic> _$EditChatMessageRequestToJson(
  _EditChatMessageRequest instance,
) => <String, dynamic>{
  'body': instance.body,
  'expected_revision': instance.expectedRevision,
};
