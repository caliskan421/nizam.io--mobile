// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_request.freezed.dart';
part 'participant_request.g.dart';

@Freezed()
abstract class ParticipantRequest with _$ParticipantRequest {
  const factory ParticipantRequest({
    @JsonKey(name: 'user_id') required String userId,
  }) = _ParticipantRequest;

  factory ParticipantRequest.fromJson(Map<String, Object?> json) =>
      _$ParticipantRequestFromJson(json);
}
