// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lockout_reset_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LockoutResetResult _$LockoutResetResultFromJson(Map<String, dynamic> json) =>
    _LockoutResetResult(
      accountsReset: (json['accounts_reset'] as num).toInt(),
      attemptsCleared: (json['attempts_cleared'] as num).toInt(),
    );

Map<String, dynamic> _$LockoutResetResultToJson(_LockoutResetResult instance) =>
    <String, dynamic>{
      'accounts_reset': instance.accountsReset,
      'attempts_cleared': instance.attemptsCleared,
    };
