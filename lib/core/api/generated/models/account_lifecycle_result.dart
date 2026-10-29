// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_lifecycle_result_status.dart';

part 'account_lifecycle_result.freezed.dart';
part 'account_lifecycle_result.g.dart';

@Freezed()
abstract class AccountLifecycleResult with _$AccountLifecycleResult {
  const factory AccountLifecycleResult({
    @JsonKey(name: 'account_id') required String accountId,
    required AccountLifecycleResultStatus status,
  }) = _AccountLifecycleResult;

  factory AccountLifecycleResult.fromJson(Map<String, Object?> json) =>
      _$AccountLifecycleResultFromJson(json);
}
