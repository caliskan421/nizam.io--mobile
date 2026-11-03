// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMember _$ChatMemberFromJson(Map<String, dynamic> json) => _ChatMember(
  accountId: json['account_id'] as String,
  fullName: json['full_name'] as String,
  role: ChatMemberRole.fromJson(json['role'] as String),
  founder: json['founder'] as bool,
  fromSource: json['from_source'] as bool,
);

Map<String, dynamic> _$ChatMemberToJson(_ChatMember instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'role': _$ChatMemberRoleEnumMap[instance.role]!,
      'founder': instance.founder,
      'from_source': instance.fromSource,
    };

const _$ChatMemberRoleEnumMap = {
  ChatMemberRole.admin: 'admin',
  ChatMemberRole.founder: 'founder',
  ChatMemberRole.member: 'member',
  ChatMemberRole.$unknown: r'$unknown',
};
