// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Teams _$TeamsFromJson(Map<String, dynamic> json) => _Teams(
  departmentId: json['department_id'] as String,
  departmentName: json['department_name'] as String,
  role: Role.fromJson(json['role'] as String),
);

Map<String, dynamic> _$TeamsToJson(_Teams instance) => <String, dynamic>{
  'department_id': instance.departmentId,
  'department_name': instance.departmentName,
  'role': _$RoleEnumMap[instance.role]!,
};

const _$RoleEnumMap = {
  Role.coordinator: 'coordinator',
  Role.member: 'member',
  Role.$unknown: r'$unknown',
};
