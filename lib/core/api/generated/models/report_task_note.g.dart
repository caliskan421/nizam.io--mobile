// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_task_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportTaskNote _$ReportTaskNoteFromJson(Map<String, dynamic> json) =>
    _ReportTaskNote(
      content: json['content'] as String,
      author: ReportPerson.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ReportTaskNoteToJson(_ReportTaskNote instance) =>
    <String, dynamic>{
      'content': instance.content,
      'author': instance.author.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };
