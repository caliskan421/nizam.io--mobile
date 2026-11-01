// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item_file_list_item.freezed.dart';
part 'work_item_file_list_item.g.dart';

/// Görev dosya listesinin öğesi: `FileListItem` alanları ve yükleyenin görünen adı. Arşiv listesi (`FileListItem`) bu alanı taşımaz.
@Freezed()
abstract class WorkItemFileListItem with _$WorkItemFileListItem {
  const factory WorkItemFileListItem({
    @JsonKey(name: 'file_id') required String fileId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
    required String tag,
    @JsonKey(name: 'uploaded_by_account_id')
    required String uploadedByAccountId,

    /// Yükleyenin görünen adı; satırı olmayan hesapta ya da ad okuması o an başarısızsa (geçici) `null`, silinmiş hesabın adı döner.
    @JsonKey(name: 'uploaded_by_full_name') required String? uploadedByFullName,

    /// Dosyanın bağlı olduğu alt görev (ADR-0024); yoksa alan yoktur. Alt görev silinince boşalır.
    @JsonKey(name: 'subtask_id') String? subtaskId,
  }) = _WorkItemFileListItem;

  factory WorkItemFileListItem.fromJson(Map<String, Object?> json) =>
      _$WorkItemFileListItemFromJson(json);
}
