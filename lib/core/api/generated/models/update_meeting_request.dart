// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_meeting_request.freezed.dart';
part 'update_meeting_request.g.dart';

@Freezed()
abstract class UpdateMeetingRequest with _$UpdateMeetingRequest {
  const factory UpdateMeetingRequest({
    String? title,

    /// Verilirse kuruluştaki kuralla aynı: geçmiş gün olamaz.
    @JsonKey(name: 'meeting_date') String? meetingDate,
    @JsonKey(name: 'department_ids') List<String>? departmentIds,
    @JsonKey(name: 'members_included') bool? membersIncluded,
  }) = _UpdateMeetingRequest;

  factory UpdateMeetingRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateMeetingRequestFromJson(json);
}
