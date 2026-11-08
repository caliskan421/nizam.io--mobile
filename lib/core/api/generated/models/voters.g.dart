// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Voters _$VotersFromJson(Map<String, dynamic> json) => _Voters(
  accountId: json['account_id'] as String,
  fullName: json['full_name'] as String?,
);

Map<String, dynamic> _$VotersToJson(_Voters instance) => <String, dynamic>{
  'account_id': instance.accountId,
  'full_name': ?instance.fullName,
};
