// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_summary.dart';

part 'chat_list.freezed.dart';
part 'chat_list.g.dart';

@Freezed()
abstract class ChatList with _$ChatList {
  const factory ChatList({
    required List<ChatSummary> items,

    /// Boşsa son sayfa.
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _ChatList;

  factory ChatList.fromJson(Map<String, Object?> json) =>
      _$ChatListFromJson(json);
}
