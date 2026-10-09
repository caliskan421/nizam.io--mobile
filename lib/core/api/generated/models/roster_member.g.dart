// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RosterMember _$RosterMemberFromJson(Map<String, dynamic> json) =>
    _RosterMember(
      membershipId: json['membership_id'] as String,
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      status: RosterMemberStatus.fromJson(json['status'] as String),
    );

Map<String, dynamic> _$RosterMemberToJson(_RosterMember instance) =>
    <String, dynamic>{
      'membership_id': instance.membershipId,
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'role': instance.role,
      'status': _$RosterMemberStatusEnumMap[instance.status]!,
    };

const _$RosterMemberStatusEnumMap = {
  RosterMemberStatus.active: 'active',
  RosterMemberStatus.deleted: 'deleted',
  RosterMemberStatus.$unknown: r'$unknown',
};
