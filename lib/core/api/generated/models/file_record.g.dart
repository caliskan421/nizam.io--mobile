// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileRecord _$FileRecordFromJson(Map<String, dynamic> json) => _FileRecord(
  fileId: json['file_id'] as String,
  workItemId: json['work_item_id'] as String,
  displayName: json['display_name'] as String,
  contentType: json['content_type'] as String,
  sizeBytes: (json['size_bytes'] as num).toInt(),
  tag: FileRecordTag.fromJson(json['tag'] as String),
  subtaskId: json['subtask_id'] as String?,
);

Map<String, dynamic> _$FileRecordToJson(_FileRecord instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'work_item_id': instance.workItemId,
      'display_name': instance.displayName,
      'content_type': instance.contentType,
      'size_bytes': instance.sizeBytes,
      'tag': _$FileRecordTagEnumMap[instance.tag]!,
      'subtask_id': ?instance.subtaskId,
    };

const _$FileRecordTagEnumMap = {
  FileRecordTag.ister: 'ister',
  FileRecordTag.plan: 'plan',
  FileRecordTag.girdi: 'girdi',
  FileRecordTag.analiz: 'analiz',
  FileRecordTag.cikti: 'cikti',
  FileRecordTag.sonuc: 'sonuc',
  FileRecordTag.$unknown: r'$unknown',
};
