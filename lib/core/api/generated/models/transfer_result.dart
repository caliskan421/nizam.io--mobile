// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_result.freezed.dart';
part 'transfer_result.g.dart';

@Freezed()
abstract class TransferResult with _$TransferResult {
  const factory TransferResult({
    @JsonKey(name: 'transfer_id') required String transferId,
    @JsonKey(name: 'moved_work_item_ids')
    required List<String>? movedWorkItemIds,
    @JsonKey(name: 'moved_file_count') required int movedFileCount,
    @JsonKey(name: 'cut_dependency_count') required int cutDependencyCount,
    @JsonKey(name: 'restored_dependency_count')
    required int restoredDependencyCount,
    @JsonKey(name: 'granted_links') required List<String> grantedLinks,
    @JsonKey(name: 'revoked_links') required List<String> revokedLinks,
    @JsonKey(name: 'retained_links') required List<String> retainedLinks,
    required bool replayed,
    @JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds,
  }) = _TransferResult;

  factory TransferResult.fromJson(Map<String, Object?> json) =>
      _$TransferResultFromJson(json);
}
