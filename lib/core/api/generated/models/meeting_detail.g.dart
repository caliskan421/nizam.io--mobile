// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingDetail _$MeetingDetailFromJson(Map<String, dynamic> json) =>
    _MeetingDetail(
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
      conference: json['conference'] == null
          ? null
          : Conference.fromJson(json['conference'] as Map<String, dynamic>),
      conferenceAvailable: json['conference_available'] as bool,
      viewerRole: MeetingDetailViewerRole.fromJson(
        json['viewer_role'] as String,
      ),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      agenda: (json['agenda'] as List<dynamic>)
          .map((e) => AgendaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: MeetingNoteList.fromJson(json['notes'] as Map<String, dynamic>),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$MeetingDetailToJson(_MeetingDetail instance) =>
    <String, dynamic>{
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
      'conference': ?instance.conference?.toJson(),
      'conference_available': instance.conferenceAvailable,
      'viewer_role': _$MeetingDetailViewerRoleEnumMap[instance.viewerRole]!,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'agenda': instance.agenda.map((e) => e.toJson()).toList(),
      'notes': instance.notes.toJson(),
      'deleted_at': ?instance.deletedAt?.toIso8601String(),
    };

const _$MeetingCreatedByRoleEnumMap = {
  MeetingCreatedByRole.admin: 'admin',
  MeetingCreatedByRole.coordinator: 'coordinator',
  MeetingCreatedByRole.$unknown: r'$unknown',
};

const _$MeetingDetailViewerRoleEnumMap = {
  MeetingDetailViewerRole.admin: 'admin',
  MeetingDetailViewerRole.coordinator: 'coordinator',
  MeetingDetailViewerRole.member: 'member',
  MeetingDetailViewerRole.$unknown: r'$unknown',
};
