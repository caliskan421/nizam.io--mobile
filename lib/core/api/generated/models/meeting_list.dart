// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting.dart';

part 'meeting_list.freezed.dart';
part 'meeting_list.g.dart';

@Freezed()
abstract class MeetingList with _$MeetingList {
  const factory MeetingList({
    required List<Meeting> items,
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _MeetingList;

  factory MeetingList.fromJson(Map<String, Object?> json) =>
      _$MeetingListFromJson(json);
}
