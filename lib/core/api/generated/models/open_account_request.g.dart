// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenAccountRequest _$OpenAccountRequestFromJson(Map<String, dynamic> json) =>
    _OpenAccountRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['full_name'] as String?,
      forcePasswordChange: json['force_password_change'] as bool?,
    );

Map<String, dynamic> _$OpenAccountRequestToJson(_OpenAccountRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'full_name': ?instance.fullName,
      'force_password_change': ?instance.forcePasswordChange,
    };
