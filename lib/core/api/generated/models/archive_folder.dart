// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_folder.freezed.dart';
part 'archive_folder.g.dart';

@Freezed()
abstract class ArchiveFolder with _$ArchiveFolder {
  const factory ArchiveFolder({
    @JsonKey(name: 'folder_id') required String folderId,
    required String name,
    @JsonKey(name: 'file_count') required int fileCount,

    /// Üyenin "Görevlerim" sanal klasörü.
    @JsonKey(name: 'is_virtual') required bool isVirtual,
  }) = _ArchiveFolder;

  factory ArchiveFolder.fromJson(Map<String, Object?> json) =>
      _$ArchiveFolderFromJson(json);
}
