// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_work_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletedWorkItem _$DeletedWorkItemFromJson(Map<String, dynamic> json) =>
    _DeletedWorkItem(
      workItemId: json['work_item_id'] as String,
      title: json['title'] as String,
      departmentId: json['department_id'] as String,
      status: json['status'] as String,
      deletedAt: DateTime.parse(json['deleted_at'] as String),
      fileCount: (json['file_count'] as num).toInt(),
    );

Map<String, dynamic> _$DeletedWorkItemToJson(_DeletedWorkItem instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'department_id': instance.departmentId,
      'status': instance.status,
      'deleted_at': instance.deletedAt.toIso8601String(),
      'file_count': instance.fileCount,
    };
