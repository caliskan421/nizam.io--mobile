// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_candidate.dart';

part 'meeting_candidate_list.freezed.dart';
part 'meeting_candidate_list.g.dart';

@Freezed()
abstract class MeetingCandidateList with _$MeetingCandidateList {
  const factory MeetingCandidateList({
    required List<MeetingCandidate> items,
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _MeetingCandidateList;

  factory MeetingCandidateList.fromJson(Map<String, Object?> json) =>
      _$MeetingCandidateListFromJson(json);
}
