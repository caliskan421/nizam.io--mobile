// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewRequest _$ReviewRequestFromJson(Map<String, dynamic> json) =>
    _ReviewRequest(
      decision: ReviewRequestDecision.fromJson(json['decision'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ReviewRequestToJson(_ReviewRequest instance) =>
    <String, dynamic>{
      'decision': _$ReviewRequestDecisionEnumMap[instance.decision]!,
      'reason': ?instance.reason,
    };

const _$ReviewRequestDecisionEnumMap = {
  ReviewRequestDecision.approved: 'approved',
  ReviewRequestDecision.rejected: 'rejected',
  ReviewRequestDecision.$unknown: r'$unknown',
};
