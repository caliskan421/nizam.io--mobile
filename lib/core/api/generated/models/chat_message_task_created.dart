// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message.dart';

part 'chat_message_task_created.freezed.dart';
part 'chat_message_task_created.g.dart';

@Freezed()
abstract class ChatMessageTaskCreated with _$ChatMessageTaskCreated {
  const factory ChatMessageTaskCreated({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required ChatMessage message,
  }) = _ChatMessageTaskCreated;

  factory ChatMessageTaskCreated.fromJson(Map<String, Object?> json) =>
      _$ChatMessageTaskCreatedFromJson(json);
}
