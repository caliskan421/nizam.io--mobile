// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinator_result.freezed.dart';
part 'coordinator_result.g.dart';

@Freezed()
abstract class CoordinatorResult with _$CoordinatorResult {
  const factory CoordinatorResult({
    @JsonKey(name: 'membership_id') required String membershipId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'account_id') required String accountId,
    required String role,
    required bool changed,
  }) = _CoordinatorResult;

  factory CoordinatorResult.fromJson(Map<String, Object?> json) =>
      _$CoordinatorResultFromJson(json);
}
