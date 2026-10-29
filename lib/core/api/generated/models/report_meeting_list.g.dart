// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meeting_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMeetingList _$ReportMeetingListFromJson(Map<String, dynamic> json) =>
    _ReportMeetingList(
      meetings: (json['meetings'] as List<dynamic>)
          .map((e) => ReportMeeting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportMeetingListToJson(_ReportMeetingList instance) =>
    <String, dynamic>{
      'meetings': instance.meetings.map((e) => e.toJson()).toList(),
    };
