// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_change_stats.freezed.dart';
part 'date_change_stats.g.dart';

@Freezed()
abstract class DateChangeStats with _$DateChangeStats {
  const factory DateChangeStats({
    required int total,
    required int approved,
    required int rejected,
    required int pending,
  }) = _DateChangeStats;

  factory DateChangeStats.fromJson(Map<String, Object?> json) =>
      _$DateChangeStatsFromJson(json);
}
