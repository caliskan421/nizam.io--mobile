// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attachments _$AttachmentsFromJson(Map<String, dynamic> json) => _Attachments(
  attachmentId: json['attachment_id'] as String,
  fileName: json['file_name'] as String,
  contentType: json['content_type'] as String,
  sizeBytes: (json['size_bytes'] as num).toInt(),
);

Map<String, dynamic> _$AttachmentsToJson(_Attachments instance) =>
    <String, dynamic>{
      'attachment_id': instance.attachmentId,
      'file_name': instance.fileName,
      'content_type': instance.contentType,
      'size_bytes': instance.sizeBytes,
    };
