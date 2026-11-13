// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_attachment_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableAttachmentMeta _$TableAttachmentMetaFromJson(Map<String, dynamic> json) =>
    _TableAttachmentMeta(
      id: json['id'] as String,
      name: json['name'] as String,
      contentType: json['content_type'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
    );

Map<String, dynamic> _$TableAttachmentMetaToJson(
  _TableAttachmentMeta instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'content_type': instance.contentType,
  'size_bytes': instance.sizeBytes,
};
