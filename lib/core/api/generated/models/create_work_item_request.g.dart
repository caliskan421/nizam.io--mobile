// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_work_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWorkItemRequest _$CreateWorkItemRequestFromJson(
  Map<String, dynamic> json,
) => _CreateWorkItemRequest(
  title: json['title'] as String,
  startOn: DateTime.parse(json['start_on'] as String),
  endOn: DateTime.parse(json['end_on'] as String),
  description: json['description'] as String?,
  priority: json['priority'] == null
      ? null
      : CreateWorkItemRequestPriority.fromJson(json['priority'] as String),
  assigneeAccountId: json['assignee_account_id'] as String?,
);

Map<String, dynamic> _$CreateWorkItemRequestToJson(
  _CreateWorkItemRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'start_on': instance.startOn.toIso8601String(),
  'end_on': instance.endOn.toIso8601String(),
  'description': ?instance.description,
  'priority': ?_$CreateWorkItemRequestPriorityEnumMap[instance.priority],
  'assignee_account_id': ?instance.assigneeAccountId,
};

const _$CreateWorkItemRequestPriorityEnumMap = {
  CreateWorkItemRequestPriority.dusuk: 'dusuk',
  CreateWorkItemRequestPriority.orta: 'orta',
  CreateWorkItemRequestPriority.yuksek: 'yuksek',
  CreateWorkItemRequestPriority.acil: 'acil',
  CreateWorkItemRequestPriority.$unknown: r'$unknown',
};
