// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'count_result.freezed.dart';
part 'count_result.g.dart';

@Freezed()
abstract class CountResult with _$CountResult {
  const factory CountResult({required int count}) = _CountResult;

  factory CountResult.fromJson(Map<String, Object?> json) =>
      _$CountResultFromJson(json);
}
