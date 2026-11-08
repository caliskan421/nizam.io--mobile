// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_candidate_role.dart';

part 'chat_candidate.freezed.dart';
part 'chat_candidate.g.dart';

@Freezed()
abstract class ChatCandidate with _$ChatCandidate {
  const factory ChatCandidate({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,

    /// Seçili programdaki en yüksek rol.
    required ChatCandidateRole role,
  }) = _ChatCandidate;

  factory ChatCandidate.fromJson(Map<String, Object?> json) =>
      _$ChatCandidateFromJson(json);
}
