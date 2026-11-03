// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatCandidate _$ChatCandidateFromJson(Map<String, dynamic> json) =>
    _ChatCandidate(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      role: ChatCandidateRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$ChatCandidateToJson(_ChatCandidate instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'role': _$ChatCandidateRoleEnumMap[instance.role]!,
    };

const _$ChatCandidateRoleEnumMap = {
  ChatCandidateRole.companyAdmin: 'company_admin',
  ChatCandidateRole.coordinator: 'coordinator',
  ChatCandidateRole.member: 'member',
  ChatCandidateRole.$unknown: r'$unknown',
};
