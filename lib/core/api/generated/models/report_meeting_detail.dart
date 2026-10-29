// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_agenda_item.dart';
import 'report_meeting.dart';
import 'report_meeting_note.dart';
import 'report_participant.dart';

part 'report_meeting_detail.freezed.dart';
part 'report_meeting_detail.g.dart';

@Freezed()
abstract class ReportMeetingDetail with _$ReportMeetingDetail {
  const factory ReportMeetingDetail({
    required ReportMeeting meeting,
    required List<ReportParticipant> participants,
    required List<ReportAgendaItem> agenda,
    required List<ReportMeetingNote> notes,
  }) = _ReportMeetingDetail;

  factory ReportMeetingDetail.fromJson(Map<String, Object?> json) =>
      _$ReportMeetingDetailFromJson(json);
}
