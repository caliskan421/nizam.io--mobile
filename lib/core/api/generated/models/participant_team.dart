// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant_team_role.dart';

part 'participant_team.freezed.dart';
part 'participant_team.g.dart';

/// Hesabın seçili programdaki bir ekip satırı (COLLABORATION-K72 ile aynı görüntü).
@Freezed()
abstract class ParticipantTeam with _$ParticipantTeam {
  const factory ParticipantTeam({
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın programdaki adı.
    @JsonKey(name: 'department_name') required String departmentName,
    required ParticipantTeamRole role,
  }) = _ParticipantTeam;

  factory ParticipantTeam.fromJson(Map<String, Object?> json) =>
      _$ParticipantTeamFromJson(json);
}
