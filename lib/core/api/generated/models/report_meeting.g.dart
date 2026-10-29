// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMeeting _$ReportMeetingFromJson(
  Map<String, dynamic> json,
) => _ReportMeeting(
  meetingId: json['meeting_id'] as String,
  title: json['title'] as String,
  meetingDate: DateTime.parse(json['meeting_date'] as String),
  ownerDepartmentId: json['owner_department_id'] as String,
  coordinatorships: (json['coordinatorships'] as List<dynamic>)
      .map((e) => ReportMeetingDepartment.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdBy: ReportPerson.fromJson(json['created_by'] as Map<String, dynamic>),
  createdByRole: ReportMeetingCreatedByRole.fromJson(
    json['created_by_role'] as String,
  ),
  membersIncluded: json['members_included'] as bool,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => ReportPerson.fromJson(e as Map<String, dynamic>))
      .toList(),
  participantCount: (json['participant_count'] as num).toInt(),
  noteCount: (json['note_count'] as num).toInt(),
);

Map<String, dynamic> _$ReportMeetingToJson(
  _ReportMeeting instance,
) => <String, dynamic>{
  'meeting_id': instance.meetingId,
  'title': instance.title,
  'meeting_date': instance.meetingDate.toIso8601String(),
  'owner_department_id': instance.ownerDepartmentId,
  'coordinatorships': instance.coordinatorships.map((e) => e.toJson()).toList(),
  'created_by': instance.createdBy.toJson(),
  'created_by_role':
      _$ReportMeetingCreatedByRoleEnumMap[instance.createdByRole]!,
  'members_included': instance.membersIncluded,
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'participant_count': instance.participantCount,
  'note_count': instance.noteCount,
};

const _$ReportMeetingCreatedByRoleEnumMap = {
  ReportMeetingCreatedByRole.admin: 'admin',
  ReportMeetingCreatedByRole.coordinator: 'coordinator',
  ReportMeetingCreatedByRole.$unknown: r'$unknown',
};
