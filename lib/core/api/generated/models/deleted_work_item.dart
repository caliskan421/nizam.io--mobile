// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deleted_work_item.freezed.dart';
part 'deleted_work_item.g.dart';

@Freezed()
abstract class DeletedWorkItem with _$DeletedWorkItem {
  const factory DeletedWorkItem({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'department_id') required String departmentId,
    required String status,
    @JsonKey(name: 'deleted_at') required DateTime deletedAt,
    @JsonKey(name: 'file_count') required int fileCount,
  }) = _DeletedWorkItem;

  factory DeletedWorkItem.fromJson(Map<String, Object?> json) =>
      _$DeletedWorkItemFromJson(json);
}
