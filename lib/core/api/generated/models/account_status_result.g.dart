// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_status_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountStatusResult _$AccountStatusResultFromJson(Map<String, dynamic> json) =>
    _AccountStatusResult(
      accountId: json['account_id'] as String,
      accountStatus: AccountStatusResultAccountStatus.fromJson(
        json['account_status'] as String,
      ),
      changed: json['changed'] as bool,
      revokedSessions: (json['revoked_sessions'] as num).toInt(),
    );

Map<String, dynamic> _$AccountStatusResultToJson(
  _AccountStatusResult instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'account_status':
      _$AccountStatusResultAccountStatusEnumMap[instance.accountStatus]!,
  'changed': instance.changed,
  'revoked_sessions': instance.revokedSessions,
};

const _$AccountStatusResultAccountStatusEnumMap = {
  AccountStatusResultAccountStatus.active: 'active',
  AccountStatusResultAccountStatus.disabled: 'disabled',
  AccountStatusResultAccountStatus.$unknown: r'$unknown',
};
