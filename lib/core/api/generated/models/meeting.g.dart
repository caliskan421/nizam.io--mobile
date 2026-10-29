// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meeting _$MeetingFromJson(Map<String, dynamic> json) => _Meeting(
  meetingId: json['meeting_id'] as String,
  programId: json['program_id'] as String,
  ownerDepartmentId: json['owner_department_id'] as String,
  title: json['title'] as String,
  meetingDate: DateTime.parse(json['meeting_date'] as String),
  membersIncluded: json['members_included'] as bool,
  createdByAccountId: json['created_by_account_id'] as String,
  createdByRole: MeetingCreatedByRole.fromJson(
    json['created_by_role'] as String,
  ),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  departments: (json['departments'] as List<dynamic>)
      .map((e) => MeetingDepartment.fromJson(e as Map<String, dynamic>))
      .toList(),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$MeetingToJson(_Meeting instance) => <String, dynamic>{
  'meeting_id': instance.meetingId,
  'program_id': instance.programId,
  'owner_department_id': instance.ownerDepartmentId,
  'title': instance.title,
  'meeting_date': instance.meetingDate.toIso8601String(),
  'members_included': instance.membersIncluded,
  'created_by_account_id': instance.createdByAccountId,
  'created_by_role': _$MeetingCreatedByRoleEnumMap[instance.createdByRole]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'departments': instance.departments.map((e) => e.toJson()).toList(),
  'deleted_at': ?instance.deletedAt?.toIso8601String(),
};

const _$MeetingCreatedByRoleEnumMap = {
  MeetingCreatedByRole.admin: 'admin',
  MeetingCreatedByRole.coordinator: 'coordinator',
  MeetingCreatedByRole.$unknown: r'$unknown',
};
