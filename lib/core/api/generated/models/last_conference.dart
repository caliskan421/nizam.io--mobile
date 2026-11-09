// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'last_conference_end_reason.dart';

part 'last_conference.freezed.dart';
part 'last_conference.g.dart';

/// Biten (sağlayıcıda kapandığı gözlenen) konferans; dış oda adı taşınmaz.
@Freezed()
abstract class LastConference with _$LastConference {
  const factory LastConference({
    required String id,
    @JsonKey(name: 'started_at') required DateTime startedAt,

    /// Kapanma isteğinin (kullanıcı, toplantı silme) ya da sistem kapanışının anı.
    @JsonKey(name: 'ended_at') required DateTime endedAt,
    @JsonKey(name: 'end_reason') required LastConferenceEndReason endReason,
  }) = _LastConference;

  factory LastConference.fromJson(Map<String, Object?> json) =>
      _$LastConferenceFromJson(json);
}
