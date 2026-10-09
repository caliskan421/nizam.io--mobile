// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'known_user.freezed.dart';
part 'known_user.g.dart';

@Freezed()
abstract class KnownUser with _$KnownUser {
  const factory KnownUser({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required List<String>? memberships,
  }) = _KnownUser;

  factory KnownUser.fromJson(Map<String, Object?> json) =>
      _$KnownUserFromJson(json);
}
