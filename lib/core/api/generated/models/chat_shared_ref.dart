// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_shared_ref_kind.dart';

part 'chat_shared_ref.freezed.dart';
part 'chat_shared_ref.g.dart';

@Freezed()
abstract class ChatSharedRef with _$ChatSharedRef {
  const factory ChatSharedRef({
    @JsonKey(name: 'ref_id') required String refId,
    required ChatSharedRefKind kind,
    @JsonKey(name: 'target_id') required String targetId,
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'sender_account_id') required String senderAccountId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatSharedRef;

  factory ChatSharedRef.fromJson(Map<String, Object?> json) =>
      _$ChatSharedRefFromJson(json);
}
