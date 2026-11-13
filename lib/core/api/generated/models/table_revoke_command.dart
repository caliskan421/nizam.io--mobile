// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_revoke_command_kind.dart';

part 'table_revoke_command.freezed.dart';
part 'table_revoke_command.g.dart';

/// Yalnız sahip. Var olmayan paylaşım 404 `tables.not_found`.
@Freezed()
abstract class TableRevokeCommand with _$TableRevokeCommand {
  const factory TableRevokeCommand({
    required TableRevokeCommandKind kind,
    @JsonKey(name: 'account_id') required String accountId,
  }) = _TableRevokeCommand;

  factory TableRevokeCommand.fromJson(Map<String, Object?> json) =>
      _$TableRevokeCommandFromJson(json);
}
