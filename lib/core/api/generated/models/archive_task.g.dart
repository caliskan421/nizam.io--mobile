// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveTask _$ArchiveTaskFromJson(Map<String, dynamic> json) => _ArchiveTask(
  workItemId: json['work_item_id'] as String,
  title: json['title'] as String,
  fileCount: (json['file_count'] as num).toInt(),
);

Map<String, dynamic> _$ArchiveTaskToJson(_ArchiveTask instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'file_count': instance.fileCount,
    };
