// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_list_item.freezed.dart';
part 'file_list_item.g.dart';

@Freezed()
abstract class FileListItem with _$FileListItem {
  const factory FileListItem({
    @JsonKey(name: 'file_id') required String fileId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
    required String tag,
    @JsonKey(name: 'uploaded_by_account_id')
    required String uploadedByAccountId,

    /// Dosyanın bağlı olduğu alt görev (ADR-0024); yoksa alan yoktur. Alt görev silinince boşalır.
    @JsonKey(name: 'subtask_id') String? subtaskId,
  }) = _FileListItem;

  factory FileListItem.fromJson(Map<String, Object?> json) =>
      _$FileListItemFromJson(json);
}
