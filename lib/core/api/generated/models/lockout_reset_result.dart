// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lockout_reset_result.freezed.dart';
part 'lockout_reset_result.g.dart';

@Freezed()
abstract class LockoutResetResult with _$LockoutResetResult {
  const factory LockoutResetResult({
    @JsonKey(name: 'accounts_reset') required int accountsReset,
    @JsonKey(name: 'attempts_cleared') required int attemptsCleared,
  }) = _LockoutResetResult;

  factory LockoutResetResult.fromJson(Map<String, Object?> json) =>
      _$LockoutResetResultFromJson(json);
}
