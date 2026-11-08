// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_chat_members_request.freezed.dart';
part 'add_chat_members_request.g.dart';

@Freezed()
abstract class AddChatMembersRequest with _$AddChatMembersRequest {
  const factory AddChatMembersRequest({
    @JsonKey(name: 'account_ids') required List<String> accountIds,
  }) = _AddChatMembersRequest;

  factory AddChatMembersRequest.fromJson(Map<String, Object?> json) =>
      _$AddChatMembersRequestFromJson(json);
}
