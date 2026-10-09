// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    _UpdateUserRequest(
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      resetPassword: json['reset_password'] as bool?,
      forcePasswordChange: json['force_password_change'] as bool?,
      companyAdmin: json['company_admin'] as bool?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(_UpdateUserRequest instance) =>
    <String, dynamic>{
      'email': ?instance.email,
      'full_name': ?instance.fullName,
      'reset_password': ?instance.resetPassword,
      'force_password_change': ?instance.forcePasswordChange,
      'company_admin': ?instance.companyAdmin,
    };
