// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_history_item.freezed.dart';
part 'transfer_history_item.g.dart';

@Freezed()
abstract class TransferHistoryItem with _$TransferHistoryItem {
  const factory TransferHistoryItem({
    @JsonKey(name: 'transfer_id') required String transferId,
    @JsonKey(name: 'source_program_id') required String sourceProgramId,
    @JsonKey(name: 'target_program_id') required String targetProgramId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'work_item_ids') required List<String>? workItemIds,
    @JsonKey(name: 'moved_item_count') required int movedItemCount,
    @JsonKey(name: 'moved_file_count') required int movedFileCount,
    @JsonKey(name: 'cut_dependency_count') required int cutDependencyCount,
    @JsonKey(name: 'restored_dependency_count')
    required int restoredDependencyCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds,
    @JsonKey(name: 'reverses_transfer_id') String? reversesTransferId,
  }) = _TransferHistoryItem;

  factory TransferHistoryItem.fromJson(Map<String, Object?> json) =>
      _$TransferHistoryItemFromJson(json);
}
