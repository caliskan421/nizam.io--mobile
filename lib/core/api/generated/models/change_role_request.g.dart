// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_role_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeRoleRequest _$ChangeRoleRequestFromJson(Map<String, dynamic> json) =>
    _ChangeRoleRequest(
      role: json['role'] as String,
      confirm: json['confirm'] as bool?,
    );

Map<String, dynamic> _$ChangeRoleRequestToJson(_ChangeRoleRequest instance) =>
    <String, dynamic>{'role': instance.role, 'confirm': ?instance.confirm};
