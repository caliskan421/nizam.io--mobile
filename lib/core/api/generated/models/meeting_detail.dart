// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'agenda_item.dart';
import 'meeting_created_by_role.dart';
import 'meeting_department.dart';
import 'meeting_detail_viewer_role.dart';
import 'meeting_note_list.dart';
import 'participant.dart';

part 'meeting_detail.freezed.dart';
part 'meeting_detail.g.dart';

@Freezed()
abstract class MeetingDetail with _$MeetingDetail {
  const factory MeetingDetail({
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
    @JsonKey(name: 'viewer_role') required MeetingDetailViewerRole viewerRole,
    required List<Participant> participants,
    required List<AgendaItem> agenda,
    required MeetingNoteList notes,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _MeetingDetail;

  factory MeetingDetail.fromJson(Map<String, Object?> json) =>
      _$MeetingDetailFromJson(json);
}
