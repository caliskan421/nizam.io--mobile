// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_uploaders.freezed.dart';
part 'archive_uploaders.g.dart';

@Freezed()
abstract class ArchiveUploaders with _$ArchiveUploaders {
  const factory ArchiveUploaders({required List<String> uploaders}) =
      _ArchiveUploaders;

  factory ArchiveUploaders.fromJson(Map<String, Object?> json) =>
      _$ArchiveUploadersFromJson(json);
}
