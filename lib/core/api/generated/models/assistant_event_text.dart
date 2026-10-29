// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_event_text.freezed.dart';
part 'assistant_event_text.g.dart';

@Freezed()
abstract class AssistantEventText with _$AssistantEventText {
  const factory AssistantEventText({
    /// Cevap metninin bir parçası.
    required String metin,
  }) = _AssistantEventText;

  factory AssistantEventText.fromJson(Map<String, Object?> json) =>
      _$AssistantEventTextFromJson(json);
}
