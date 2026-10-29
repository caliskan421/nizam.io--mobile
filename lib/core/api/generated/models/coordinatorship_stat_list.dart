// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinatorship_stat.dart';

part 'coordinatorship_stat_list.freezed.dart';
part 'coordinatorship_stat_list.g.dart';

@Freezed()
abstract class CoordinatorshipStatList with _$CoordinatorshipStatList {
  const factory CoordinatorshipStatList({
    required List<CoordinatorshipStat> coordinatorships,
  }) = _CoordinatorshipStatList;

  factory CoordinatorshipStatList.fromJson(Map<String, Object?> json) =>
      _$CoordinatorshipStatListFromJson(json);
}
