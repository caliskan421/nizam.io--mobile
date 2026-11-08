// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_group_chat_request_source.dart';

part 'create_group_chat_request.freezed.dart';
part 'create_group_chat_request.g.dart';

@Freezed()
abstract class CreateGroupChatRequest with _$CreateGroupChatRequest {
  const factory CreateGroupChatRequest({
    /// Tek satır, en çok 100 karakter.
    required String name,
    @JsonKey(name: 'member_account_ids') required List<String> memberAccountIds,
    CreateGroupChatRequestSource? source,

    /// `source=department` iken zorunlu; programa bağlı koordinatörlük.
    @JsonKey(name: 'source_department_id') String? sourceDepartmentId,
  }) = _CreateGroupChatRequest;

  factory CreateGroupChatRequest.fromJson(Map<String, Object?> json) =>
      _$CreateGroupChatRequestFromJson(json);
}
