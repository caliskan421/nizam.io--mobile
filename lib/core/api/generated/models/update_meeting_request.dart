// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_meeting_request.freezed.dart';
part 'update_meeting_request.g.dart';

/// Davet kipi değişmez: `invite_mode` alanı her değerde 422 `collaboration.input_invalid` (alan `invite_mode`). `person` kipinde `department_ids` ve `members_included: true` da 422'dir (COLLABORATION-K73).
@Freezed()
abstract class UpdateMeetingRequest with _$UpdateMeetingRequest {
  const factory UpdateMeetingRequest({
    /// Verilirse kuruluştaki kuralla aynı: düz metne indirilip kırpıldıktan sonra 1–255 karakter (Unicode kod noktası); aksi 422 `collaboration.input_invalid` (alan `title`).
    String? title,

    /// Verilirse kuruluştaki kuralla aynı: geçmiş gün olamaz.
    @JsonKey(name: 'meeting_date') String? meetingDate,

    /// Alan yoksa yer değişmez; `null` ya da boş dizge yeri kaldırır; değer kuruluştaki kuralla doğrulanır (COLLABORATION-K76).
    String? place,
    @JsonKey(name: 'department_ids') List<String>? departmentIds,
    @JsonKey(name: 'members_included') bool? membersIncluded,
  }) = _UpdateMeetingRequest;

  factory UpdateMeetingRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateMeetingRequestFromJson(json);
}
