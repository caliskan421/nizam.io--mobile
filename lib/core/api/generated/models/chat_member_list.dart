// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_member.dart';

part 'chat_member_list.freezed.dart';
part 'chat_member_list.g.dart';

@Freezed()
abstract class ChatMemberList with _$ChatMemberList {
  const factory ChatMemberList({
    required List<ChatMember> items,
    required bool truncated,
  }) = _ChatMemberList;

  factory ChatMemberList.fromJson(Map<String, Object?> json) =>
      _$ChatMemberListFromJson(json);
}
