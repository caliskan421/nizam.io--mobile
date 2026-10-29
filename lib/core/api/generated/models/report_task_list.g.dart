// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_task_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportTaskList _$ReportTaskListFromJson(Map<String, dynamic> json) =>
    _ReportTaskList(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => ReportTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ReportTaskListToJson(_ReportTaskList instance) =>
    <String, dynamic>{
      'tasks': instance.tasks.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
