// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_created_by_role.dart';
import 'meeting_department.dart';
import 'meeting_side_effects.dart';

part 'meeting_revised.freezed.dart';
part 'meeting_revised.g.dart';

@Freezed()
abstract class MeetingRevised with _$MeetingRevised {
  const factory MeetingRevised({
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
    @JsonKey(name: 'side_effects') required MeetingSideEffects sideEffects,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _MeetingRevised;

  factory MeetingRevised.fromJson(Map<String, Object?> json) =>
      _$MeetingRevisedFromJson(json);
}
