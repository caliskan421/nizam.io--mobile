// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KnownUser _$KnownUserFromJson(Map<String, dynamic> json) => _KnownUser(
  accountId: json['account_id'] as String,
  fullName: json['full_name'] as String,
  email: json['email'] as String,
  companyAdmin: json['company_admin'] as bool,
  accountStatus: KnownUserAccountStatus.fromJson(
    json['account_status'] as String,
  ),
  loginLocked: json['login_locked'] as bool,
  memberships: (json['memberships'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  teams: (json['teams'] as List<dynamic>)
      .map((e) => UserTeam.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KnownUserToJson(
  _KnownUser instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'full_name': instance.fullName,
  'email': instance.email,
  'company_admin': instance.companyAdmin,
  'account_status': _$KnownUserAccountStatusEnumMap[instance.accountStatus]!,
  'login_locked': instance.loginLocked,
  'memberships': ?instance.memberships,
  'teams': instance.teams.map((e) => e.toJson()).toList(),
};

const _$KnownUserAccountStatusEnumMap = {
  KnownUserAccountStatus.active: 'active',
  KnownUserAccountStatus.disabled: 'disabled',
  KnownUserAccountStatus.$unknown: r'$unknown',
};
