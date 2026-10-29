// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item_lifecycle_result_status.dart';

part 'work_item_lifecycle_result.freezed.dart';
part 'work_item_lifecycle_result.g.dart';

@Freezed()
abstract class WorkItemLifecycleResult with _$WorkItemLifecycleResult {
  const factory WorkItemLifecycleResult({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required WorkItemLifecycleResultStatus status,
  }) = _WorkItemLifecycleResult;

  factory WorkItemLifecycleResult.fromJson(Map<String, Object?> json) =>
      _$WorkItemLifecycleResultFromJson(json);
}
