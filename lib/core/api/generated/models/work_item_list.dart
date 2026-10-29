// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item.dart';

part 'work_item_list.freezed.dart';
part 'work_item_list.g.dart';

@Freezed()
abstract class WorkItemList with _$WorkItemList {
  const factory WorkItemList({
    required List<WorkItem> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _WorkItemList;

  factory WorkItemList.fromJson(Map<String, Object?> json) =>
      _$WorkItemListFromJson(json);
}
