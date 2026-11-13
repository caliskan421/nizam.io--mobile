// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_grant_command_kind.dart';
import 'table_grant_command_role.dart';

part 'table_grant_command.freezed.dart';
part 'table_grant_command.g.dart';

/// Yalnız sahip. Hedef hesap yazım anında aynı kapsamın aktif üyesi ya da şirket yöneticisi olmalıdır; değilse 422 `tables.reference_unavailable`. Var olan paylaşımın rolünü değiştirir.
@Freezed()
abstract class TableGrantCommand with _$TableGrantCommand {
  const factory TableGrantCommand({
    required TableGrantCommandKind kind,
    @JsonKey(name: 'account_id') required String accountId,
    required TableGrantCommandRole role,
  }) = _TableGrantCommand;

  factory TableGrantCommand.fromJson(Map<String, Object?> json) =>
      _$TableGrantCommandFromJson(json);
}
