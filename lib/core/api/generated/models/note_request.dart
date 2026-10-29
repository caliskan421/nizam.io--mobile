// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_request.freezed.dart';
part 'note_request.g.dart';

@Freezed()
abstract class NoteRequest with _$NoteRequest {
  const factory NoteRequest({required String content}) = _NoteRequest;

  factory NoteRequest.fromJson(Map<String, Object?> json) =>
      _$NoteRequestFromJson(json);
}
