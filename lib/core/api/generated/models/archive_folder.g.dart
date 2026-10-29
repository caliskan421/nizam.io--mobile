// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveFolder _$ArchiveFolderFromJson(Map<String, dynamic> json) =>
    _ArchiveFolder(
      folderId: json['folder_id'] as String,
      name: json['name'] as String,
      fileCount: (json['file_count'] as num).toInt(),
      isVirtual: json['is_virtual'] as bool,
    );

Map<String, dynamic> _$ArchiveFolderToJson(_ArchiveFolder instance) =>
    <String, dynamic>{
      'folder_id': instance.folderId,
      'name': instance.name,
      'file_count': instance.fileCount,
      'is_virtual': instance.isVirtual,
    };
