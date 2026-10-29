// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveTasks _$ArchiveTasksFromJson(Map<String, dynamic> json) =>
    _ArchiveTasks(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => ArchiveTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArchiveTasksToJson(_ArchiveTasks instance) =>
    <String, dynamic>{'tasks': instance.tasks.map((e) => e.toJson()).toList()};
