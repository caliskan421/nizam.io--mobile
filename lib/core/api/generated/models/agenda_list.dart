// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'agenda_item.dart';

part 'agenda_list.freezed.dart';
part 'agenda_list.g.dart';

@Freezed()
abstract class AgendaList with _$AgendaList {
  const factory AgendaList({
    required List<AgendaItem> items,

    /// Gündem tek sayfadır; her zaman boş.
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _AgendaList;

  factory AgendaList.fromJson(Map<String, Object?> json) =>
      _$AgendaListFromJson(json);
}
