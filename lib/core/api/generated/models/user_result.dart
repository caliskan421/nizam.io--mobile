// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_result.freezed.dart';
part 'user_result.g.dart';

@Freezed()
abstract class UserResult with _$UserResult {
  const factory UserResult({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'membership_id') String? membershipId,
    bool? created,
    bool? transferred,
    @JsonKey(name: 'changed_fields') List<String>? changedFields,
    @JsonKey(name: 'revoked_sessions') int? revokedSessions,
  }) = _UserResult;

  factory UserResult.fromJson(Map<String, Object?> json) =>
      _$UserResultFromJson(json);
}
