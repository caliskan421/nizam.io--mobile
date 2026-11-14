// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_proposal_decision_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProposalDecisionResult _$TableProposalDecisionResultFromJson(
  Map<String, dynamic> json,
) => _TableProposalDecisionResult(
  id: json['id'] as String,
  status: TableProposalDecisionResultStatus.fromJson(json['status'] as String),
  replayed: json['replayed'] as bool,
  tableId: json['table_id'] as String?,
);

Map<String, dynamic> _$TableProposalDecisionResultToJson(
  _TableProposalDecisionResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$TableProposalDecisionResultStatusEnumMap[instance.status]!,
  'replayed': instance.replayed,
  'table_id': ?instance.tableId,
};

const _$TableProposalDecisionResultStatusEnumMap = {
  TableProposalDecisionResultStatus.approved: 'approved',
  TableProposalDecisionResultStatus.rejected: 'rejected',
  TableProposalDecisionResultStatus.$unknown: r'$unknown',
};
