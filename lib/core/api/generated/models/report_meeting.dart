// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_meeting_created_by_role.dart';
import 'report_meeting_department.dart';
import 'report_person.dart';

part 'report_meeting.freezed.dart';
part 'report_meeting.g.dart';

@Freezed()
abstract class ReportMeeting with _$ReportMeeting {
  const factory ReportMeeting({
    @JsonKey(name: 'meeting_id') required String meetingId,
    required String title,
    @JsonKey(name: 'meeting_date') required DateTime meetingDate,
    @JsonKey(name: 'owner_department_id') required String ownerDepartmentId,
    required List<ReportMeetingDepartment> coordinatorships,
    @JsonKey(name: 'created_by') required ReportPerson createdBy,
    @JsonKey(name: 'created_by_role')
    required ReportMeetingCreatedByRole createdByRole,
    @JsonKey(name: 'members_included') required bool membersIncluded,
    required List<ReportPerson> participants,
    @JsonKey(name: 'participant_count') required int participantCount,
    @JsonKey(name: 'note_count') required int noteCount,
  }) = _ReportMeeting;

  factory ReportMeeting.fromJson(Map<String, Object?> json) =>
      _$ReportMeetingFromJson(json);
}
