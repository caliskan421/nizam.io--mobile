// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    _CreateUserRequest(
      email: json['email'] as String,
      departmentId: json['department_id'] as String,
      fullName: json['full_name'] as String?,
      role: json['role'] as String?,
      transferAccountId: json['transfer_account_id'] as String?,
      companyAdmin: json['company_admin'] as bool?,
    );

Map<String, dynamic> _$CreateUserRequestToJson(_CreateUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'department_id': instance.departmentId,
      'full_name': ?instance.fullName,
      'role': ?instance.role,
      'transfer_account_id': ?instance.transferAccountId,
      'company_admin': ?instance.companyAdmin,
    };
