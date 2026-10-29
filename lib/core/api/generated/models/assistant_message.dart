// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assistant_message_rol.dart';

part 'assistant_message.freezed.dart';
part 'assistant_message.g.dart';

@Freezed()
abstract class AssistantMessage with _$AssistantMessage {
  const factory AssistantMessage({
    required int sira,
    required AssistantMessageRol rol,
    required String icerik,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AssistantMessage;

  factory AssistantMessage.fromJson(Map<String, Object?> json) =>
      _$AssistantMessageFromJson(json);
}
