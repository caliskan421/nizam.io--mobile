// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'archive_folder.dart';

part 'archive_folders.freezed.dart';
part 'archive_folders.g.dart';

@Freezed()
abstract class ArchiveFolders with _$ArchiveFolders {
  const factory ArchiveFolders({required List<ArchiveFolder> folders}) =
      _ArchiveFolders;

  factory ArchiveFolders.fromJson(Map<String, Object?> json) =>
      _$ArchiveFoldersFromJson(json);
}
