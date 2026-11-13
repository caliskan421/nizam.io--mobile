// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingCandidate _$MeetingCandidateFromJson(Map<String, dynamic> json) =>
    _MeetingCandidate(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      teams: (json['teams'] as List<dynamic>)
          .map((e) => ParticipantTeam.fromJson(e as Map<String, dynamic>))
          .toList(),
      isParticipant: json['is_participant'] as bool,
    );

Map<String, dynamic> _$MeetingCandidateToJson(_MeetingCandidate instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'teams': instance.teams.map((e) => e.toJson()).toList(),
      'is_participant': instance.isParticipant,
    };
