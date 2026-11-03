// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachments.dart';
import 'chat_mention.dart';
import 'chat_message_quote.dart';
import 'chat_message_ref.dart';
import 'poll2.dart';
import 'reactions.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@Freezed()
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'chat_id') required String chatId,
    required int seq,
    @JsonKey(name: 'sender_account_id') required String senderAccountId,
    @JsonKey(name: 'client_message_id') required String clientMessageId,
    required String body,
    @JsonKey(name: 'reply_to_message_id') required String? replyToMessageId,
    required bool edited,
    @JsonKey(name: 'edited_at') required DateTime? editedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// Gönderimdeki bahsetmeler (düzenleme değiştirmez); ad çözülmez.
    required List<ChatMention> mentions,

    /// Paylaşılan öğeler (statik); kart `GET /v1/chat-refs/{refId}` ile okunur.
    required List<ChatMessageRef> refs,

    /// Bu mesajdan açılan görevler.
    @JsonKey(name: 'task_ids') required List<String> taskIds,

    /// Tür başına tepki sayısı; tepki edenler gösterilmez.
    required List<Reactions> reactions,
    @JsonKey(name: 'pinned_at') required DateTime? pinnedAt,

    /// Anket (soru mesaj gövdesidir); sonuçta oy verenler görünür.
    required Poll2? poll,
    required List<Attachments> attachments,

    /// Gövdenin düzenleme sürümü (ADR-0027); tombstone, sabitleme ve tepki artırmaz.
    @JsonKey(name: 'edit_revision') required int editRevision,

    /// Yalnız geçmiş cevabında.
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'reply_to') ChatMessageQuote? replyTo,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}
