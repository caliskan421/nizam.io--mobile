// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'removed_count.freezed.dart';
part 'removed_count.g.dart';

@Freezed()
abstract class RemovedCount with _$RemovedCount {
  const factory RemovedCount({required int removed}) = _RemovedCount;

  factory RemovedCount.fromJson(Map<String, Object?> json) =>
      _$RemovedCountFromJson(json);
}
