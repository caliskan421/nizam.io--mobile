// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_created_by_role.dart';
import 'meeting_deleted_by.dart';
import 'meeting_department.dart';
import 'meeting_invite_mode.dart';
import 'meeting_side_effects.dart';
import 'meeting_summary.dart';

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

    /// Toplantı yeri (düz metin, en çok 200 karakter); belirtilmemişse null (COLLABORATION-K76).
    required String? place,
    @JsonKey(name: 'members_included') required bool membersIncluded,

    /// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
    @JsonKey(name: 'invite_mode') required MeetingInviteMode inviteMode,
    @JsonKey(name: 'created_by_account_id') required String createdByAccountId,
    @JsonKey(name: 'created_by_role')
    required MeetingCreatedByRole createdByRole,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<MeetingDepartment> departments,
    @JsonKey(name: 'side_effects') required MeetingSideEffects sideEffects,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,

    /// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
    @JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy,

    /// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
    MeetingSummary? summary,
  }) = _MeetingRevised;

  factory MeetingRevised.fromJson(Map<String, Object?> json) =>
      _$MeetingRevisedFromJson(json);
}
