// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_proposal_decision_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProposalDecisionRequest _$TableProposalDecisionRequestFromJson(
  Map<String, dynamic> json,
) => _TableProposalDecisionRequest(
  decision: TableProposalDecisionRequestDecision.fromJson(
    json['decision'] as String,
  ),
);

Map<String, dynamic> _$TableProposalDecisionRequestToJson(
  _TableProposalDecisionRequest instance,
) => <String, dynamic>{
  'decision': _$TableProposalDecisionRequestDecisionEnumMap[instance.decision]!,
};

const _$TableProposalDecisionRequestDecisionEnumMap = {
  TableProposalDecisionRequestDecision.approve: 'approve',
  TableProposalDecisionRequestDecision.reject: 'reject',
  TableProposalDecisionRequestDecision.$unknown: r'$unknown',
};
