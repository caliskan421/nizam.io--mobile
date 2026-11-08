// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';
part 'chat_event.g.dart';

/// SSE olay yükü; içeriksizdir (metin, alıntı taşımaz). Kalıcı değildir.
@Freezed()
abstract class ChatEvent with _$ChatEvent {
  const factory ChatEvent({
    @JsonKey(name: 'chat_id') required String chatId,
    @JsonKey(name: 'message_id') required String? messageId,
    @JsonKey(name: 'actor_account_id') required String actorAccountId,

    /// Üyelik/sohbet olayında sohbete giren ve sohbetten düşen hesaplar; diğer olaylarda boş.
    @JsonKey(name: 'affected_account_ids')
    required List<String> affectedAccountIds,
  }) = _ChatEvent;

  factory ChatEvent.fromJson(Map<String, Object?> json) =>
      _$ChatEventFromJson(json);
}
