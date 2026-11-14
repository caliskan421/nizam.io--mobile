// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantTeam _$ParticipantTeamFromJson(Map<String, dynamic> json) =>
    _ParticipantTeam(
      departmentId: json['department_id'] as String,
      departmentName: json['department_name'] as String,
      role: ParticipantTeamRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$ParticipantTeamToJson(_ParticipantTeam instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'role': _$ParticipantTeamRoleEnumMap[instance.role]!,
    };

const _$ParticipantTeamRoleEnumMap = {
  ParticipantTeamRole.coordinator: 'coordinator',
  ParticipantTeamRole.member: 'member',
  ParticipantTeamRole.$unknown: r'$unknown',
};
