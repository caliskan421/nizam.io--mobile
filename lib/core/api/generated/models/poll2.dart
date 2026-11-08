// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'results.dart';

part 'poll2.freezed.dart';
part 'poll2.g.dart';

@Freezed()
abstract class Poll2 with _$Poll2 {
  const factory Poll2({
    required bool multi,
    @JsonKey(name: 'closes_at') required DateTime? closesAt,
    @JsonKey(name: 'closed_at') required DateTime? closedAt,
    required List<Results> results,
  }) = _Poll2;

  factory Poll2.fromJson(Map<String, Object?> json) => _$Poll2FromJson(json);
}
