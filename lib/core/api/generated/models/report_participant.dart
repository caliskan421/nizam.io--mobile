// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_participant.freezed.dart';
part 'report_participant.g.dart';

@Freezed()
abstract class ReportParticipant with _$ReportParticipant {
  const factory ReportParticipant({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
  }) = _ReportParticipant;

  factory ReportParticipant.fromJson(Map<String, Object?> json) =>
      _$ReportParticipantFromJson(json);
}
