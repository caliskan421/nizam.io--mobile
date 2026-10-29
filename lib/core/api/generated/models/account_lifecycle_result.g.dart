// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_lifecycle_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountLifecycleResult _$AccountLifecycleResultFromJson(
  Map<String, dynamic> json,
) => _AccountLifecycleResult(
  accountId: json['account_id'] as String,
  status: AccountLifecycleResultStatus.fromJson(json['status'] as String),
);

Map<String, dynamic> _$AccountLifecycleResultToJson(
  _AccountLifecycleResult instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'status': _$AccountLifecycleResultStatusEnumMap[instance.status]!,
};

const _$AccountLifecycleResultStatusEnumMap = {
  AccountLifecycleResultStatus.restored: 'restored',
  AccountLifecycleResultStatus.purged: 'purged',
  AccountLifecycleResultStatus.$unknown: r'$unknown',
};
