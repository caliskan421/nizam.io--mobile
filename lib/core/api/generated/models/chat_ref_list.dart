// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_shared_ref.dart';

part 'chat_ref_list.freezed.dart';
part 'chat_ref_list.g.dart';

@Freezed()
abstract class ChatRefList with _$ChatRefList {
  const factory ChatRefList({
    required List<ChatSharedRef> items,
    @JsonKey(name: 'next_cursor') required String? nextCursor,
  }) = _ChatRefList;

  factory ChatRefList.fromJson(Map<String, Object?> json) =>
      _$ChatRefListFromJson(json);
}
