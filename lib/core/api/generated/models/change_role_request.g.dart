// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_role_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeRoleRequest _$ChangeRoleRequestFromJson(Map<String, dynamic> json) =>
    _ChangeRoleRequest(
      role: ChangeRoleRequestRole.fromJson(json['role'] as String),
      confirm: json['confirm'] as bool?,
    );

Map<String, dynamic> _$ChangeRoleRequestToJson(_ChangeRoleRequest instance) =>
    <String, dynamic>{
      'role': _$ChangeRoleRequestRoleEnumMap[instance.role]!,
      'confirm': ?instance.confirm,
    };

const _$ChangeRoleRequestRoleEnumMap = {
  ChangeRoleRequestRole.koordinator: 'koordinator',
  ChangeRoleRequestRole.uye: 'uye',
  ChangeRoleRequestRole.$unknown: r'$unknown',
};
