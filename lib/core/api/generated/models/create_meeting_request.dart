// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_meeting_request.freezed.dart';
part 'create_meeting_request.g.dart';

@Freezed()
abstract class CreateMeetingRequest with _$CreateMeetingRequest {
  const factory CreateMeetingRequest({
    required String title,

    /// Tarih-saat; saat dilimi yoksa kurulum saat diliminde yorumlanır. Kurulum saat dilimindeki bugünden önceki bir gün olamaz (422 `collaboration.input_invalid`).
    @JsonKey(name: 'meeting_date') required String meetingDate,

    /// En az bir departman; ilki sahip departmandır. Hepsi seçili programa katılmış olmalıdır.
    @JsonKey(name: 'department_ids') required List<String> departmentIds,
    @JsonKey(name: 'participant_ids') List<String>? participantIds,
    @JsonKey(name: 'members_included') bool? membersIncluded,
    @JsonKey(name: 'agenda_items') List<String>? agendaItems,

    /// `true` ise koordinatörlere toplantı mesajı gönderilmez.
    @JsonKey(name: 'is_instant') bool? isInstant,
  }) = _CreateMeetingRequest;

  factory CreateMeetingRequest.fromJson(Map<String, Object?> json) =>
      _$CreateMeetingRequestFromJson(json);
}
