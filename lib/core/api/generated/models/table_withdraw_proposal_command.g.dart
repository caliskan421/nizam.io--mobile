// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_withdraw_proposal_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableWithdrawProposalCommand _$TableWithdrawProposalCommandFromJson(
  Map<String, dynamic> json,
) => _TableWithdrawProposalCommand(
  kind: TableWithdrawProposalCommandKind.fromJson(json['kind'] as String),
);

Map<String, dynamic> _$TableWithdrawProposalCommandToJson(
  _TableWithdrawProposalCommand instance,
) => <String, dynamic>{
  'kind': _$TableWithdrawProposalCommandKindEnumMap[instance.kind]!,
};

const _$TableWithdrawProposalCommandKindEnumMap = {
  TableWithdrawProposalCommandKind.withdrawProposal: 'withdraw_proposal',
  TableWithdrawProposalCommandKind.$unknown: r'$unknown',
};
