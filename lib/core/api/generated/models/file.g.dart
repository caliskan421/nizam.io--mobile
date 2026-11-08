// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_File _$FileFromJson(Map<String, dynamic> json) => _File(
  name: json['name'] as String,
  contentType: json['content_type'] as String,
  sizeBytes: (json['size_bytes'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$FileToJson(_File instance) => <String, dynamic>{
  'name': instance.name,
  'content_type': instance.contentType,
  'size_bytes': instance.sizeBytes,
  'created_at': instance.createdAt.toIso8601String(),
};
