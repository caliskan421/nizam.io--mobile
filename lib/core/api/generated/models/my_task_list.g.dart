// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_task_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyTaskList _$MyTaskListFromJson(Map<String, dynamic> json) => _MyTaskList(
  items: (json['items'] as List<dynamic>)
      .map((e) => MyTask.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MyTaskListToJson(_MyTaskList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
