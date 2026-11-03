// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_from_chat_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskFromChatMessageRequest _$CreateTaskFromChatMessageRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTaskFromChatMessageRequest(
  departmentId: json['department_id'] as String,
  startDate: const DateOnlyConverter().fromJson(json['start_date'] as String),
  endDate: const DateOnlyConverter().fromJson(json['end_date'] as String),
  title: json['title'] as String?,
  priority: json['priority'] as String?,
  assigneeAccountIds: (json['assignee_account_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CreateTaskFromChatMessageRequestToJson(
  _CreateTaskFromChatMessageRequest instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'start_date': const DateOnlyConverter().toJson(instance.startDate),
  'end_date': const DateOnlyConverter().toJson(instance.endDate),
  'title': ?instance.title,
  'priority': ?instance.priority,
  'assignee_account_ids': ?instance.assigneeAccountIds,
};
