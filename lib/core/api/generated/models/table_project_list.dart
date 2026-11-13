// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_project.dart';

part 'table_project_list.freezed.dart';
part 'table_project_list.g.dart';

@Freezed()
abstract class TableProjectList with _$TableProjectList {
  const factory TableProjectList({
    required List<TableProject> items,

    /// Sonraki sayfa; son sayfada yoktur.
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _TableProjectList;

  factory TableProjectList.fromJson(Map<String, Object?> json) =>
      _$TableProjectListFromJson(json);
}
