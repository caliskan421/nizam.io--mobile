// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_quote.freezed.dart';
part 'chat_message_quote.g.dart';

@Freezed()
abstract class ChatMessageQuote with _$ChatMessageQuote {
  const factory ChatMessageQuote({
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'sender_account_id') required String? senderAccountId,
    @JsonKey(name: 'sender_name') required String? senderName,
    required String? body,

    /// `true` ise alıntılanan mesaj silinmiştir; diğer alanlar `null`.
    required bool deleted,
  }) = _ChatMessageQuote;

  factory ChatMessageQuote.fromJson(Map<String, Object?> json) =>
      _$ChatMessageQuoteFromJson(json);
}
