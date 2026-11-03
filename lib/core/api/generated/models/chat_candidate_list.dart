// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_candidate.dart';

part 'chat_candidate_list.freezed.dart';
part 'chat_candidate_list.g.dart';

@Freezed()
abstract class ChatCandidateList with _$ChatCandidateList {
  const factory ChatCandidateList({
    required List<ChatCandidate> items,
    required bool truncated,
  }) = _ChatCandidateList;

  factory ChatCandidateList.fromJson(Map<String, Object?> json) =>
      _$ChatCandidateListFromJson(json);
}
