// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_unread_program.dart';

part 'chat_unread_overview.freezed.dart';
part 'chat_unread_overview.g.dart';

@Freezed()
abstract class ChatUnreadOverview with _$ChatUnreadOverview {
  const factory ChatUnreadOverview({required List<ChatUnreadProgram> items}) =
      _ChatUnreadOverview;

  factory ChatUnreadOverview.fromJson(Map<String, Object?> json) =>
      _$ChatUnreadOverviewFromJson(json);
}
