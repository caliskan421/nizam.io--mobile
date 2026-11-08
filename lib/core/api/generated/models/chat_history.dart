// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message.dart';

part 'chat_history.freezed.dart';
part 'chat_history.g.dart';

@Freezed()
abstract class ChatHistory with _$ChatHistory {
  const factory ChatHistory({
    required List<ChatMessage> items,

    /// Birebirde karşı tarafın okundu imleci (tik); grupta `null`.
    @JsonKey(name: 'peer_read_seq') required int? peerReadSeq,
  }) = _ChatHistory;

  factory ChatHistory.fromJson(Map<String, Object?> json) =>
      _$ChatHistoryFromJson(json);
}
