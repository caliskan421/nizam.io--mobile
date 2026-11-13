// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table.dart';

part 'table_list.freezed.dart';
part 'table_list.g.dart';

@Freezed()
abstract class TableList with _$TableList {
  const factory TableList({
    required List<Table> items,

    /// Sonraki sayfa; son sayfada yoktur.
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _TableList;

  factory TableList.fromJson(Map<String, Object?> json) =>
      _$TableListFromJson(json);
}
