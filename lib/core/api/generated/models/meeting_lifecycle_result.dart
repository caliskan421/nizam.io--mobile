// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_lifecycle_result_status.dart';

part 'meeting_lifecycle_result.freezed.dart';
part 'meeting_lifecycle_result.g.dart';

@Freezed()
abstract class MeetingLifecycleResult with _$MeetingLifecycleResult {
  const factory MeetingLifecycleResult({
    @JsonKey(name: 'meeting_id') required String meetingId,
    required MeetingLifecycleResultStatus status,
  }) = _MeetingLifecycleResult;

  factory MeetingLifecycleResult.fromJson(Map<String, Object?> json) =>
      _$MeetingLifecycleResultFromJson(json);
}
