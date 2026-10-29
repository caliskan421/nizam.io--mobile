// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_stats.freezed.dart';
part 'message_stats.g.dart';

@Freezed()
abstract class MessageStats with _$MessageStats {
  const factory MessageStats({
    required int total,
    @JsonKey(name: 'from_admins') required int fromAdmins,
    @JsonKey(name: 'from_others') required int fromOthers,
  }) = _MessageStats;

  factory MessageStats.fromJson(Map<String, Object?> json) =>
      _$MessageStatsFromJson(json);
}
