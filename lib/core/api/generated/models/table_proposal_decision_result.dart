// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_proposal_decision_result_status.dart';

part 'table_proposal_decision_result.freezed.dart';
part 'table_proposal_decision_result.g.dart';

@Freezed()
abstract class TableProposalDecisionResult with _$TableProposalDecisionResult {
  const factory TableProposalDecisionResult({
    /// Öneri kimliği.
    required String id,
    required TableProposalDecisionResultStatus status,
    required bool replayed,

    /// Yalnız onayda; taşınan tablo ya da yeni kopya.
    @JsonKey(name: 'table_id') String? tableId,
  }) = _TableProposalDecisionResult;

  factory TableProposalDecisionResult.fromJson(Map<String, Object?> json) =>
      _$TableProposalDecisionResultFromJson(json);
}
