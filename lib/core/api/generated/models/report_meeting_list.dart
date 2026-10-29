// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_meeting.dart';

part 'report_meeting_list.freezed.dart';
part 'report_meeting_list.g.dart';

@Freezed()
abstract class ReportMeetingList with _$ReportMeetingList {
  const factory ReportMeetingList({required List<ReportMeeting> meetings}) =
      _ReportMeetingList;

  factory ReportMeetingList.fromJson(Map<String, Object?> json) =>
      _$ReportMeetingListFromJson(json);
}
