// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'participants.freezed.dart';
part 'participants.g.dart';

@Freezed()
abstract class Participants with _$Participants {
  const factory Participants({
    required String key,
    @JsonKey(name: 'account_id') required String accountId,
    required String name,
    @JsonKey(name: 'row_id') required String rowId,
    @JsonKey(name: 'column_id') required String columnId,
  }) = _Participants;

  factory Participants.fromJson(Map<String, Object?> json) =>
      _$ParticipantsFromJson(json);
}
