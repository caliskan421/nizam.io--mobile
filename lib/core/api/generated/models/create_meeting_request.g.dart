// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_meeting_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateMeetingRequest _$CreateMeetingRequestFromJson(
  Map<String, dynamic> json,
) => _CreateMeetingRequest(
  title: json['title'] as String,
  meetingDate: json['meeting_date'] as String,
  departmentIds: (json['department_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  participantIds: (json['participant_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  membersIncluded: json['members_included'] as bool?,
  agendaItems: (json['agenda_items'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isInstant: json['is_instant'] as bool?,
);

Map<String, dynamic> _$CreateMeetingRequestToJson(
  _CreateMeetingRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'meeting_date': instance.meetingDate,
  'department_ids': instance.departmentIds,
  'participant_ids': ?instance.participantIds,
  'members_included': ?instance.membersIncluded,
  'agenda_items': ?instance.agendaItems,
  'is_instant': ?instance.isInstant,
};
