// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_created_by_role.dart';
import 'meeting_department.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

@Freezed()
abstract class Meeting with _$Meeting {
  const factory Meeting({
    @JsonKey(name: 'meeting_id') required String meetingId,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'owner_department_id') required String ownerDepartmentId,
    required String title,
    @JsonKey(name: 'meeting_date') required DateTime meetingDate,
    @JsonKey(name: 'members_included') required bool membersIncluded,
    @JsonKey(name: 'created_by_account_id') required String createdByAccountId,
    @JsonKey(name: 'created_by_role')
    required MeetingCreatedByRole createdByRole,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<MeetingDepartment> departments,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);
}
