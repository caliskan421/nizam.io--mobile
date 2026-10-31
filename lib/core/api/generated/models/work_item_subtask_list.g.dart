// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_subtask_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemSubtaskList _$WorkItemSubtaskListFromJson(Map<String, dynamic> json) =>
    _WorkItemSubtaskList(
      subtasks: (json['subtasks'] as List<dynamic>)
          .map((e) => WorkItemSubtask.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$WorkItemSubtaskListToJson(
  _WorkItemSubtaskList instance,
) => <String, dynamic>{
  'subtasks': instance.subtasks.map((e) => e.toJson()).toList(),
  'total': instance.total,
};
