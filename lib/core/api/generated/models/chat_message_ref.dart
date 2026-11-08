// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message_ref_kind.dart';

part 'chat_message_ref.freezed.dart';
part 'chat_message_ref.g.dart';

@Freezed()
abstract class ChatMessageRef with _$ChatMessageRef {
  const factory ChatMessageRef({
    @JsonKey(name: 'ref_id') required String refId,
    required ChatMessageRefKind kind,
    @JsonKey(name: 'target_id') required String targetId,
  }) = _ChatMessageRef;

  factory ChatMessageRef.fromJson(Map<String, Object?> json) =>
      _$ChatMessageRefFromJson(json);
}
