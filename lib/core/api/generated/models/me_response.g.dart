// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => _MeResponse(
  accountId: json['account_id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  companyAdmin: json['company_admin'] as bool,
);

Map<String, dynamic> _$MeResponseToJson(_MeResponse instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'email': instance.email,
      'full_name': instance.fullName,
      'company_admin': instance.companyAdmin,
    };
