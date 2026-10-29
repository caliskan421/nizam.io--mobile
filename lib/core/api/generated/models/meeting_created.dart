// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting.dart';
import 'meeting_side_effects.dart';

part 'meeting_created.freezed.dart';
part 'meeting_created.g.dart';

@Freezed()
abstract class MeetingCreated with _$MeetingCreated {
  const factory MeetingCreated({
    required Meeting meeting,

    /// Yazılamayan katılımcı kimlikleri.
    @JsonKey(name: 'failed_participants')
    required List<String>? failedParticipants,
    @JsonKey(name: 'side_effects') required MeetingSideEffects sideEffects,
  }) = _MeetingCreated;

  factory MeetingCreated.fromJson(Map<String, Object?> json) =>
      _$MeetingCreatedFromJson(json);
}
