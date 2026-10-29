// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_note_request.freezed.dart';
part 'work_note_request.g.dart';

@Freezed()
abstract class WorkNoteRequest with _$WorkNoteRequest {
  const factory WorkNoteRequest({required String content}) = _WorkNoteRequest;

  factory WorkNoteRequest.fromJson(Map<String, Object?> json) =>
      _$WorkNoteRequestFromJson(json);
}
