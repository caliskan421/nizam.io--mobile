// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'work_item_note.dart';

part 'work_item_note_list.freezed.dart';
part 'work_item_note_list.g.dart';

@Freezed()
abstract class WorkItemNoteList with _$WorkItemNoteList {
  const factory WorkItemNoteList({
    required List<WorkItemNote> notes,
    required int total,
  }) = _WorkItemNoteList;

  factory WorkItemNoteList.fromJson(Map<String, Object?> json) =>
      _$WorkItemNoteListFromJson(json);
}
