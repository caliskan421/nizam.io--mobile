// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantConversation _$AssistantConversationFromJson(
  Map<String, dynamic> json,
) => _AssistantConversation(
  id: json['id'] as String,
  baslik: json['baslik'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AssistantConversationToJson(
  _AssistantConversation instance,
) => <String, dynamic>{
  'id': instance.id,
  'baslik': instance.baslik,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
