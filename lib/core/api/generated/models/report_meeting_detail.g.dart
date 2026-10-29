// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meeting_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportMeetingDetail _$ReportMeetingDetailFromJson(Map<String, dynamic> json) =>
    _ReportMeetingDetail(
      meeting: ReportMeeting.fromJson(json['meeting'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ReportParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      agenda: (json['agenda'] as List<dynamic>)
          .map((e) => ReportAgendaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: (json['notes'] as List<dynamic>)
          .map((e) => ReportMeetingNote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportMeetingDetailToJson(
  _ReportMeetingDetail instance,
) => <String, dynamic>{
  'meeting': instance.meeting.toJson(),
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'agenda': instance.agenda.map((e) => e.toJson()).toList(),
  'notes': instance.notes.map((e) => e.toJson()).toList(),
};
