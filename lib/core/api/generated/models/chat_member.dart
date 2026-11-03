// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_member_role.dart';

part 'chat_member.freezed.dart';
part 'chat_member.g.dart';

@Freezed()
abstract class ChatMember with _$ChatMember {
  const factory ChatMember({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required ChatMemberRole role,
    required bool founder,

    /// `true` ise üye grubun kaynağından gelir; elle çıkarılamaz (409 `messaging.member_source_managed`).
    @JsonKey(name: 'from_source') required bool fromSource,
  }) = _ChatMember;

  factory ChatMember.fromJson(Map<String, Object?> json) =>
      _$ChatMemberFromJson(json);
}
