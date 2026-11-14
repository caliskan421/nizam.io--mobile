// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_withdraw_proposal_command_kind.dart';

part 'table_withdraw_proposal_command.freezed.dart';
part 'table_withdraw_proposal_command.g.dart';

/// Yalnız sahip; tablonun bekleyen önerisini geri çeker (bayat öneri dahil). Tablo verisi ve işlem sırası değişmez. Bekleyen öneri yoksa 404 `tables.not_found`.
@Freezed()
abstract class TableWithdrawProposalCommand
    with _$TableWithdrawProposalCommand {
  const factory TableWithdrawProposalCommand({
    required TableWithdrawProposalCommandKind kind,
  }) = _TableWithdrawProposalCommand;

  factory TableWithdrawProposalCommand.fromJson(Map<String, Object?> json) =>
      _$TableWithdrawProposalCommandFromJson(json);
}
