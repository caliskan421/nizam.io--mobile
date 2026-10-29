// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_conversation.freezed.dart';
part 'assistant_conversation.g.dart';

@Freezed()
abstract class AssistantConversation with _$AssistantConversation {
  const factory AssistantConversation({
    required String id,
    required String baslik,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AssistantConversation;

  factory AssistantConversation.fromJson(Map<String, Object?> json) =>
      _$AssistantConversationFromJson(json);
}
