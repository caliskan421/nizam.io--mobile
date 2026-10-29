// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@Freezed()
abstract class Message with _$Message {
  const factory Message({
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'sender_account_id') required String senderAccountId,
    @JsonKey(name: 'sender_name') required String senderName,
    @JsonKey(name: 'receiver_account_id') required String receiverAccountId,
    @JsonKey(name: 'receiver_name') required String receiverName,
    required String subject,
    required String content,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'read_at') required DateTime? readAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}
