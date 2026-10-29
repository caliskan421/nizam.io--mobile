// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_task_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportTaskDetail _$ReportTaskDetailFromJson(Map<String, dynamic> json) =>
    _ReportTaskDetail(
      task: ReportTask.fromJson(json['task'] as Map<String, dynamic>),
      description: json['description'] as String,
      dependencies: (json['dependencies'] as List<dynamic>)
          .map((e) => ReportTaskRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentNotes: (json['recent_notes'] as List<dynamic>)
          .map((e) => ReportTaskNote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportTaskDetailToJson(_ReportTaskDetail instance) =>
    <String, dynamic>{
      'task': instance.task.toJson(),
      'description': instance.description,
      'dependencies': instance.dependencies.map((e) => e.toJson()).toList(),
      'recent_notes': instance.recentNotes.map((e) => e.toJson()).toList(),
    };
