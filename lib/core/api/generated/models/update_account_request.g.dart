// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAccountRequest _$UpdateAccountRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateAccountRequest(
  email: json['email'] as String?,
  fullName: json['full_name'] as String?,
  password: json['password'] as String?,
  forcePasswordChange: json['force_password_change'] as bool?,
);

Map<String, dynamic> _$UpdateAccountRequestToJson(
  _UpdateAccountRequest instance,
) => <String, dynamic>{
  'email': ?instance.email,
  'full_name': ?instance.fullName,
  'password': ?instance.password,
  'force_password_change': ?instance.forcePasswordChange,
};
