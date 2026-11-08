// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_last_message.freezed.dart';
part 'chat_last_message.g.dart';

@Freezed()
abstract class ChatLastMessage with _$ChatLastMessage {
  const factory ChatLastMessage({
    @JsonKey(name: 'message_id') required String messageId,
    required int seq,
    @JsonKey(name: 'sender_account_id') required String senderAccountId,
    @JsonKey(name: 'sender_name') required String senderName,

    /// Silinmiş mesajda `null`.
    required String? body,
    required bool deleted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatLastMessage;

  factory ChatLastMessage.fromJson(Map<String, Object?> json) =>
      _$ChatLastMessageFromJson(json);
}
