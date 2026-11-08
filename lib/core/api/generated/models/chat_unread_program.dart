// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_unread_program.freezed.dart';
part 'chat_unread_program.g.dart';

@Freezed()
abstract class ChatUnreadProgram with _$ChatUnreadProgram {
  const factory ChatUnreadProgram({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    @JsonKey(name: 'unread_chats') required int unreadChats,
    required bool mentioned,
  }) = _ChatUnreadProgram;

  factory ChatUnreadProgram.fromJson(Map<String, Object?> json) =>
      _$ChatUnreadProgramFromJson(json);
}
