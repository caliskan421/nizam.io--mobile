// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll.freezed.dart';
part 'poll.g.dart';

@Freezed()
abstract class Poll with _$Poll {
  const factory Poll({
    /// 2–10 tekil, tek satır seçenek (en çok 100 karakter).
    required List<String> options,
    bool? multi,

    /// Şimdiden sonra olmalıdır.
    @JsonKey(name: 'closes_at') DateTime? closesAt,
  }) = _Poll;

  factory Poll.fromJson(Map<String, Object?> json) => _$PollFromJson(json);
}
