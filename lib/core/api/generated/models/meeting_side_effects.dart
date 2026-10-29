// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_side_effects.freezed.dart';
part 'meeting_side_effects.g.dart';

/// İşlemden sonraki en iyi çabalı yan etkilerin özeti; arıza işlemi geri almaz.
@Freezed()
abstract class MeetingSideEffects with _$MeetingSideEffects {
  const factory MeetingSideEffects({
    @JsonKey(name: 'failed_messages') required int failedMessages,
    @JsonKey(name: 'event_failed') required bool eventFailed,
  }) = _MeetingSideEffects;

  factory MeetingSideEffects.fromJson(Map<String, Object?> json) =>
      _$MeetingSideEffectsFromJson(json);
}
