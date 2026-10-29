// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_meeting_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateMeetingRequest _$UpdateMeetingRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateMeetingRequest(
  title: json['title'] as String?,
  meetingDate: json['meeting_date'] as String?,
  departmentIds: (json['department_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  membersIncluded: json['members_included'] as bool?,
);

Map<String, dynamic> _$UpdateMeetingRequestToJson(
  _UpdateMeetingRequest instance,
) => <String, dynamic>{
  'title': ?instance.title,
  'meeting_date': ?instance.meetingDate,
  'department_ids': ?instance.departmentIds,
  'members_included': ?instance.membersIncluded,
};
