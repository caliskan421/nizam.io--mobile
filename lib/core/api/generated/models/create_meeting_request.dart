// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_meeting_request_invite_mode.dart';

part 'create_meeting_request.freezed.dart';
part 'create_meeting_request.g.dart';

@Freezed()
abstract class CreateMeetingRequest with _$CreateMeetingRequest {
  const factory CreateMeetingRequest({
    required String title,

    /// Tarih-saat; saat dilimi yoksa kurulum saat diliminde yorumlanır. Kurulum saat dilimindeki bugünden önceki bir gün olamaz (422 `collaboration.input_invalid`).
    @JsonKey(name: 'meeting_date') required String meetingDate,

    /// En az bir departman; ilki sahip departmandır. Hepsi seçili programa katılmış olmalıdır. `person` kipinde tam bir eleman (aksi 422 `collaboration.input_invalid`, alan `department_ids`).
    @JsonKey(name: 'department_ids') required List<String> departmentIds,

    /// Davet kipi (COLLABORATION-K73); sonradan değişmez. `person` kipinde koordinatör mesajı gönderilmez.
    @JsonKey(name: 'invite_mode')
    @Default(CreateMeetingRequestInviteMode.coordinatorship)
    CreateMeetingRequestInviteMode inviteMode,

    /// İsteğe bağlı yer (COLLABORATION-K76): düz metne indirilir ve kırpılır; boş sonuç yer yok demektir. Kontrol karakteri ya da 200 karakterden uzun değer 422 `collaboration.input_invalid` (alan `place`).
    String? place,
    @JsonKey(name: 'participant_ids') List<String>? participantIds,

    /// `person` kipinde `true` 422 `collaboration.input_invalid` (alan `members_included`).
    @JsonKey(name: 'members_included') bool? membersIncluded,
    @JsonKey(name: 'agenda_items') List<String>? agendaItems,

    /// `true` ise koordinatörlere toplantı mesajı gönderilmez.
    @JsonKey(name: 'is_instant') bool? isInstant,
  }) = _CreateMeetingRequest;

  factory CreateMeetingRequest.fromJson(Map<String, Object?> json) =>
      _$CreateMeetingRequestFromJson(json);
}
