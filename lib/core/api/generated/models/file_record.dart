// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'file_record_tag.dart';

part 'file_record.freezed.dart';
part 'file_record.g.dart';

@Freezed()
abstract class FileRecord with _$FileRecord {
  const factory FileRecord({
    @JsonKey(name: 'file_id') required String fileId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
    required FileRecordTag tag,
  }) = _FileRecord;

  factory FileRecord.fromJson(Map<String, Object?> json) =>
      _$FileRecordFromJson(json);
}
