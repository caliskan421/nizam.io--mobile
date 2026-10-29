// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_file_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveFileList _$ArchiveFileListFromJson(Map<String, dynamic> json) =>
    _ArchiveFileList(
      files: (json['files'] as List<dynamic>)
          .map((e) => FileListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$ArchiveFileListToJson(_ArchiveFileList instance) =>
    <String, dynamic>{
      'files': instance.files.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
