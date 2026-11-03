// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'create_task_from_chat_message_request.freezed.dart';
part 'create_task_from_chat_message_request.g.dart';

@Freezed()
abstract class CreateTaskFromChatMessageRequest
    with _$CreateTaskFromChatMessageRequest {
  const factory CreateTaskFromChatMessageRequest({
    @JsonKey(name: 'department_id') required String departmentId,
    @DateOnlyConverter()
    @JsonKey(name: 'start_date')
    required DateTime startDate,
    @DateOnlyConverter() @JsonKey(name: 'end_date') required DateTime endDate,
    String? title,
    String? priority,
    @JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds,
  }) = _CreateTaskFromChatMessageRequest;

  factory CreateTaskFromChatMessageRequest.fromJson(
    Map<String, Object?> json,
  ) => _$CreateTaskFromChatMessageRequestFromJson(json);
}
