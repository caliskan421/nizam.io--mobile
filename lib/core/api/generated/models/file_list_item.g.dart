// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileListItem _$FileListItemFromJson(Map<String, dynamic> json) =>
    _FileListItem(
      fileId: json['file_id'] as String,
      workItemId: json['work_item_id'] as String,
      displayName: json['display_name'] as String,
      contentType: json['content_type'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      tag: json['tag'] as String,
      uploadedByAccountId: json['uploaded_by_account_id'] as String,
      subtaskId: json['subtask_id'] as String?,
    );

Map<String, dynamic> _$FileListItemToJson(_FileListItem instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'work_item_id': instance.workItemId,
      'display_name': instance.displayName,
      'content_type': instance.contentType,
      'size_bytes': instance.sizeBytes,
      'tag': instance.tag,
      'uploaded_by_account_id': instance.uploadedByAccountId,
      'subtask_id': ?instance.subtaskId,
    };
