// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'file_list_item.dart';

part 'archive_file_list.freezed.dart';
part 'archive_file_list.g.dart';

@Freezed()
abstract class ArchiveFileList with _$ArchiveFileList {
  const factory ArchiveFileList({
    required List<FileListItem> files,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _ArchiveFileList;

  factory ArchiveFileList.fromJson(Map<String, Object?> json) =>
      _$ArchiveFileListFromJson(json);
}
