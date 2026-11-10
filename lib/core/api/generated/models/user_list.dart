// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'known_user.dart';
import 'user_role_counts.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@Freezed()
abstract class UserList with _$UserList {
  const factory UserList({
    required List<KnownUser>? users,

    /// Bütün süzgeçlere (rol dahil) uyan hesap sayısı; imleç zincirinin toplam satır sayısıdır.
    required int total,
    @JsonKey(name: 'role_counts') required UserRoleCounts roleCounts,

    /// Devam eden listede dolu. Süzgeçli listede sayfa `limit`ten az satırla (boş da olabilir) ve dolu `next_cursor` ile dönebilir (istek başına tarama bütçesi); istemci `next_cursor` boşalana dek devam eder, satır atlanmaz ve tekrar etmez.
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _UserList;

  factory UserList.fromJson(Map<String, Object?> json) =>
      _$UserListFromJson(json);
}
