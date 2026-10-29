// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantChatRequest _$AssistantChatRequestFromJson(
  Map<String, dynamic> json,
) => _AssistantChatRequest(
  soru: json['soru'] as String,
  sohbetId: json['sohbet_id'] as String?,
);

Map<String, dynamic> _$AssistantChatRequestToJson(
  _AssistantChatRequest instance,
) => <String, dynamic>{'soru': instance.soru, 'sohbet_id': ?instance.sohbetId};
