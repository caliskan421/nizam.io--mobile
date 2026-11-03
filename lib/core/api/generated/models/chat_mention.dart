// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_mention_kind.dart';

part 'chat_mention.freezed.dart';
part 'chat_mention.g.dart';

@Freezed()
abstract class ChatMention with _$ChatMention {
  const factory ChatMention({
    required ChatMentionKind kind,

    /// `all`da yoktur.
    @JsonKey(name: 'target_id') String? targetId,
  }) = _ChatMention;

  factory ChatMention.fromJson(Map<String, Object?> json) =>
      _$ChatMentionFromJson(json);
}
