// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_team_role.dart';

part 'user_team.freezed.dart';
part 'user_team.g.dart';

@Freezed()
abstract class UserTeam with _$UserTeam {
  const factory UserTeam({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın bu programdaki adı.
    @JsonKey(name: 'display_name') required String displayName,
    required UserTeamRole role,
  }) = _UserTeam;

  factory UserTeam.fromJson(Map<String, Object?> json) =>
      _$UserTeamFromJson(json);
}
