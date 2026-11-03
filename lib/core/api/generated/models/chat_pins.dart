// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message.dart';

part 'chat_pins.freezed.dart';
part 'chat_pins.g.dart';

@Freezed()
abstract class ChatPins with _$ChatPins {
  const factory ChatPins({
    required List<ChatMessage> items,
    required bool truncated,
  }) = _ChatPins;

  factory ChatPins.fromJson(Map<String, Object?> json) =>
      _$ChatPinsFromJson(json);
}
