// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_candidate_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatCandidateList _$ChatCandidateListFromJson(Map<String, dynamic> json) =>
    _ChatCandidateList(
      items: (json['items'] as List<dynamic>)
          .map((e) => ChatCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      truncated: json['truncated'] as bool,
    );

Map<String, dynamic> _$ChatCandidateListToJson(_ChatCandidateList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'truncated': instance.truncated,
    };
