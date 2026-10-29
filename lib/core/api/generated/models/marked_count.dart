// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'marked_count.freezed.dart';
part 'marked_count.g.dart';

@Freezed()
abstract class MarkedCount with _$MarkedCount {
  const factory MarkedCount({
    @JsonKey(name: 'marked_count') required int markedCount,
  }) = _MarkedCount;

  factory MarkedCount.fromJson(Map<String, Object?> json) =>
      _$MarkedCountFromJson(json);
}
