// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'known_user.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@Freezed()
abstract class UserList with _$UserList {
  const factory UserList({
    required List<KnownUser>? users,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _UserList;

  factory UserList.fromJson(Map<String, Object?> json) =>
      _$UserListFromJson(json);
}
