// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_person.dart';

part 'report_task_note.freezed.dart';
part 'report_task_note.g.dart';

@Freezed()
abstract class ReportTaskNote with _$ReportTaskNote {
  const factory ReportTaskNote({
    required String content,
    required ReportPerson author,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ReportTaskNote;

  factory ReportTaskNote.fromJson(Map<String, Object?> json) =>
      _$ReportTaskNoteFromJson(json);
}
