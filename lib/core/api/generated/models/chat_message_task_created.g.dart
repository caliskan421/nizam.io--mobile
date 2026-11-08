// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_task_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageTaskCreated _$ChatMessageTaskCreatedFromJson(
  Map<String, dynamic> json,
) => _ChatMessageTaskCreated(
  workItemId: json['work_item_id'] as String,
  message: ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatMessageTaskCreatedToJson(
  _ChatMessageTaskCreated instance,
) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'message': instance.message.toJson(),
};
