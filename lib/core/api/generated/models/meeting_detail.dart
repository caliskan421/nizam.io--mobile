// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'agenda_item.dart';
import 'conference.dart';
import 'last_conference.dart';
import 'meeting_created_by_role.dart';
import 'meeting_deleted_by.dart';
import 'meeting_department.dart';
import 'meeting_detail_viewer_role.dart';
import 'meeting_invite_mode.dart';
import 'meeting_note_list.dart';
import 'meeting_summary.dart';
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

    /// Toplantı yeri (düz metin, en çok 200 karakter); belirtilmemişse null (COLLABORATION-K76).
    required String? place,
    @JsonKey(name: 'members_included') required bool membersIncluded,

    /// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
    @JsonKey(name: 'invite_mode') required MeetingInviteMode inviteMode,
    @JsonKey(name: 'created_by_account_id') required String createdByAccountId,

    /// Toplantıyı açan hesabın bugünkü görünen adı (COLLABORATION-K81); bütün toplantı görüntülerinde (kuruluş, güncelleme, liste, detay, silinenler) aynıdır. Hesap çözülemezse null.
    @JsonKey(name: 'created_by_full_name') required String? createdByFullName,
    @JsonKey(name: 'created_by_role')
    required MeetingCreatedByRole createdByRole,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<MeetingDepartment> departments,

    /// Aktif ya da kapanmakta olan konferans; yoksa null. Dış oda adı taşınmaz.
    required Conference? conference,

    /// En yeni biten konferans (COLLABORATION-K70); yoksa null. `conference` ile ikisi de null ise toplantıda hiç konferans açılmamıştır. Süreyi istemci `ended_at − started_at` olarak hesaplar; boş oda 5 dk sonra kapandığından sistem kapanışında (`provider_finished`, `reconciled_missing`) süre bu payı içerir.
    @JsonKey(name: 'last_conference') required LastConference? lastConference,

    /// Bağlı video sağlayıcısı oda açabiliyor mu (`none` iken false). İstemci başlat düğmesini buna göre gösterir.
    @JsonKey(name: 'conference_available') required bool conferenceAvailable,

    /// Çağıranın erişimi (COLLABORATION-K74): `coordinator` yönetimdir (`person` kipinde sahip departmanı hâlâ koordine eden oluşturan); `member` salt okuma ve not (katılımcı ve koordinatörlüğü düşmüş katılımcı oluşturan dahil).
    @JsonKey(name: 'viewer_role') required MeetingDetailViewerRole viewerRole,
    required List<Participant> participants,
    required List<AgendaItem> agenda,
    required MeetingNoteList notes,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,

    /// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
    @JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy,

    /// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
    MeetingSummary? summary,
  }) = _MeetingDetail;

  factory MeetingDetail.fromJson(Map<String, Object?> json) =>
      _$MeetingDetailFromJson(json);
}
