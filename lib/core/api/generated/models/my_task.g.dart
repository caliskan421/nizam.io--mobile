// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyTask _$MyTaskFromJson(Map<String, dynamic> json) => _MyTask(
  workItemId: json['work_item_id'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$MyTaskToJson(_MyTask instance) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'title': instance.title,
  'status': instance.status,
};
