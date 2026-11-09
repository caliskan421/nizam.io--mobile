// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum LastConferenceEndReason {
  @JsonValue('ended_by_user')
  endedByUser('ended_by_user'),
  @JsonValue('meeting_deleted')
  meetingDeleted('meeting_deleted'),
  @JsonValue('provider_start_failed')
  providerStartFailed('provider_start_failed'),
  @JsonValue('provider_finished')
  providerFinished('provider_finished'),
  @JsonValue('reconciled_missing')
  reconciledMissing('reconciled_missing'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const LastConferenceEndReason(this.json);

  factory LastConferenceEndReason.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<LastConferenceEndReason> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
