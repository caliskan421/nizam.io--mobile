// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'added_count.freezed.dart';
part 'added_count.g.dart';

@Freezed()
abstract class AddedCount with _$AddedCount {
  const factory AddedCount({required int added}) = _AddedCount;

  factory AddedCount.fromJson(Map<String, Object?> json) =>
      _$AddedCountFromJson(json);
}
