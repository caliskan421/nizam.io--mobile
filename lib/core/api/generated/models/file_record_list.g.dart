// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_record_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileRecordList _$FileRecordListFromJson(Map<String, dynamic> json) =>
    _FileRecordList(
      files: (json['files'] as List<dynamic>)
          .map((e) => FileListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileRecordListToJson(_FileRecordList instance) =>
    <String, dynamic>{'files': instance.files.map((e) => e.toJson()).toList()};
