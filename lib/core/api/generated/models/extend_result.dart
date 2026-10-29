// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'extend_result.freezed.dart';
part 'extend_result.g.dart';

@Freezed()
abstract class ExtendResult with _$ExtendResult {
  const factory ExtendResult({
    @JsonKey(name: 'cascade_count') required int cascadeCount,
    @DateOnlyConverter()
    @JsonKey(name: 'new_end_on')
    required DateTime newEndOn,
  }) = _ExtendResult;

  factory ExtendResult.fromJson(Map<String, Object?> json) =>
      _$ExtendResultFromJson(json);
}
