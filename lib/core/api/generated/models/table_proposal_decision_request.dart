// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_proposal_decision_request_decision.dart';

part 'table_proposal_decision_request.freezed.dart';
part 'table_proposal_decision_request.g.dart';

@Freezed()
abstract class TableProposalDecisionRequest
    with _$TableProposalDecisionRequest {
  const factory TableProposalDecisionRequest({
    required TableProposalDecisionRequestDecision decision,
  }) = _TableProposalDecisionRequest;

  factory TableProposalDecisionRequest.fromJson(Map<String, Object?> json) =>
      _$TableProposalDecisionRequestFromJson(json);
}
