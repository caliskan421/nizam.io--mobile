// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sent_message.freezed.dart';
part 'sent_message.g.dart';

@Freezed()
abstract class SentMessage with _$SentMessage {
  const factory SentMessage({
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'receiver_account_id') required String receiverAccountId,
    required String subject,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _SentMessage;

  factory SentMessage.fromJson(Map<String, Object?> json) =>
      _$SentMessageFromJson(json);
}
