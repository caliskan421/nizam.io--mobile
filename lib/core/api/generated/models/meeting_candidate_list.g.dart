// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_candidate_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingCandidateList _$MeetingCandidateListFromJson(
  Map<String, dynamic> json,
) => _MeetingCandidateList(
  items: (json['items'] as List<dynamic>)
      .map((e) => MeetingCandidate.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String,
);

Map<String, dynamic> _$MeetingCandidateListToJson(
  _MeetingCandidateList instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'next_cursor': instance.nextCursor,
};
