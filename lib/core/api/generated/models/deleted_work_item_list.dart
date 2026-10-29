// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'deleted_work_item.dart';

part 'deleted_work_item_list.freezed.dart';
part 'deleted_work_item_list.g.dart';

@Freezed()
abstract class DeletedWorkItemList with _$DeletedWorkItemList {
  const factory DeletedWorkItemList({
    required List<DeletedWorkItem> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _DeletedWorkItemList;

  factory DeletedWorkItemList.fromJson(Map<String, Object?> json) =>
      _$DeletedWorkItemListFromJson(json);
}
