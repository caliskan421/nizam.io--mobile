// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_uploaders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveUploaders _$ArchiveUploadersFromJson(Map<String, dynamic> json) =>
    _ArchiveUploaders(
      uploaders: (json['uploaders'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ArchiveUploadersToJson(_ArchiveUploaders instance) =>
    <String, dynamic>{'uploaders': instance.uploaders};
