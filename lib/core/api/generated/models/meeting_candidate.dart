// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant_team.dart';

part 'meeting_candidate.freezed.dart';
part 'meeting_candidate.g.dart';

/// Katılımcı adayı (COLLABORATION-K83); e-posta ve hesap durumu taşımaz.
@Freezed()
abstract class MeetingCandidate with _$MeetingCandidate {
  const factory MeetingCandidate({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required List<ParticipantTeam> teams,

    /// Hesap `meeting_id` toplantısının katılımcısı mı; `meeting_id` yoksa her zaman false.
    @JsonKey(name: 'is_participant') required bool isParticipant,
  }) = _MeetingCandidate;

  factory MeetingCandidate.fromJson(Map<String, Object?> json) =>
      _$MeetingCandidateFromJson(json);
}
