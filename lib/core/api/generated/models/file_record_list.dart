// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item_file_list_item.dart';

part 'file_record_list.freezed.dart';
part 'file_record_list.g.dart';

@Freezed()
abstract class FileRecordList with _$FileRecordList {
  const factory FileRecordList({required List<WorkItemFileListItem> files}) =
      _FileRecordList;

  factory FileRecordList.fromJson(Map<String, Object?> json) =>
      _$FileRecordListFromJson(json);
}
