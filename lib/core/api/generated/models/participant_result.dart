// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_result.freezed.dart';
part 'participant_result.g.dart';

@Freezed()
abstract class ParticipantResult with _$ParticipantResult {
  const factory ParticipantResult({
    @JsonKey(name: 'meeting_id') required String meetingId,
    @JsonKey(name: 'user_id') required String userId,
  }) = _ParticipantResult;

  factory ParticipantResult.fromJson(Map<String, Object?> json) =>
      _$ParticipantResultFromJson(json);
}
