// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item_purge_result_status.dart';

part 'work_item_purge_result.freezed.dart';
part 'work_item_purge_result.g.dart';

@Freezed()
abstract class WorkItemPurgeResult with _$WorkItemPurgeResult {
  const factory WorkItemPurgeResult({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required WorkItemPurgeResultStatus status,
    @JsonKey(name: 'files_deleted') required int filesDeleted,
  }) = _WorkItemPurgeResult;

  factory WorkItemPurgeResult.fromJson(Map<String, Object?> json) =>
      _$WorkItemPurgeResultFromJson(json);
}
