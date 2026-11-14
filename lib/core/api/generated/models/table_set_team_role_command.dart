// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_set_team_role_command_kind.dart';
import 'table_set_team_role_command_role.dart';

part 'table_set_team_role_command.freezed.dart';
part 'table_set_team_role_command.g.dart';

/// Yalnız sahip ve yalnız koordinatörlük alanı (kişisel alanda 422). Tablonun departmanındaki güncel ekip üyelerine `editor` ya da `viewer` dinamik erişimi açar; `none` kapatır. Erişim her istekte ekip satırından türetilir: ekipten ayrılan ya da paylaşımı kapatılan hesap sonraki istekte 404 alır (TABLES-K12).
@Freezed()
abstract class TableSetTeamRoleCommand with _$TableSetTeamRoleCommand {
  const factory TableSetTeamRoleCommand({
    required TableSetTeamRoleCommandKind kind,
    required TableSetTeamRoleCommandRole role,
  }) = _TableSetTeamRoleCommand;

  factory TableSetTeamRoleCommand.fromJson(Map<String, Object?> json) =>
      _$TableSetTeamRoleCommandFromJson(json);
}
