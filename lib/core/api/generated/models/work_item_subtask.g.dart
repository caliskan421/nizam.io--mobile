// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_subtask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemSubtask _$WorkItemSubtaskFromJson(Map<String, dynamic> json) =>
    _WorkItemSubtask(
      subtaskId: json['subtask_id'] as String,
      workItemId: json['work_item_id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool,
      createdByAccountId: json['created_by_account_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      assigneeFullName: json['assignee_full_name'] as String?,
      doneByFullName: json['done_by_full_name'] as String?,
      createdByFullName: json['created_by_full_name'] as String?,
      assigneeAccountId: json['assignee_account_id'] as String?,
      startOn: _$JsonConverterFromJson<String, DateTime>(
        json['start_on'],
        const DateOnlyConverter().fromJson,
      ),
      endOn: _$JsonConverterFromJson<String, DateTime>(
        json['end_on'],
        const DateOnlyConverter().fromJson,
      ),
      doneAt: json['done_at'] == null
          ? null
          : DateTime.parse(json['done_at'] as String),
      doneByAccountId: json['done_by_account_id'] as String?,
    );

Map<String, dynamic> _$WorkItemSubtaskToJson(_WorkItemSubtask instance) =>
    <String, dynamic>{
      'subtask_id': instance.subtaskId,
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'done': instance.done,
      'created_by_account_id': instance.createdByAccountId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'assignee_full_name': ?instance.assigneeFullName,
      'done_by_full_name': ?instance.doneByFullName,
      'created_by_full_name': ?instance.createdByFullName,
      'assignee_account_id': ?instance.assigneeAccountId,
      'start_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.startOn,
        const DateOnlyConverter().toJson,
      ),
      'end_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.endOn,
        const DateOnlyConverter().toJson,
      ),
      'done_at': ?instance.doneAt?.toIso8601String(),
      'done_by_account_id': ?instance.doneByAccountId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
