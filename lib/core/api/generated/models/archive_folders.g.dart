// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveFolders _$ArchiveFoldersFromJson(Map<String, dynamic> json) =>
    _ArchiveFolders(
      folders: (json['folders'] as List<dynamic>)
          .map((e) => ArchiveFolder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArchiveFoldersToJson(_ArchiveFolders instance) =>
    <String, dynamic>{
      'folders': instance.folders.map((e) => e.toJson()).toList(),
    };
