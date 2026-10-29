// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';

part 'message_list.freezed.dart';
part 'message_list.g.dart';

@Freezed()
abstract class MessageList with _$MessageList {
  const factory MessageList({
    required List<Message> items,

    /// Boşsa son sayfa.
    @JsonKey(name: 'next_cursor') required String nextCursor,
  }) = _MessageList;

  factory MessageList.fromJson(Map<String, Object?> json) =>
      _$MessageListFromJson(json);
}
