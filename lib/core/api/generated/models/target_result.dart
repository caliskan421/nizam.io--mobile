// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_result.freezed.dart';
part 'target_result.g.dart';

@Freezed()
abstract class TargetResult with _$TargetResult {
  const factory TargetResult({
    @JsonKey(name: 'target_id') required String targetId,
    required String status,
  }) = _TargetResult;

  factory TargetResult.fromJson(Map<String, Object?> json) =>
      _$TargetResultFromJson(json);
}
