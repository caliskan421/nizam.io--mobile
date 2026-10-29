// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_event_done.freezed.dart';
part 'assistant_event_done.g.dart';

@Freezed()
abstract class AssistantEventDone with _$AssistantEventDone {
  const factory AssistantEventDone({
    @JsonKey(name: 'sohbet_id') required String sohbetId,
  }) = _AssistantEventDone;

  factory AssistantEventDone.fromJson(Map<String, Object?> json) =>
      _$AssistantEventDoneFromJson(json);
}
