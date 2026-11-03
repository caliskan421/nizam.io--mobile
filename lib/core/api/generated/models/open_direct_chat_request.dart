// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'open_direct_chat_request.freezed.dart';
part 'open_direct_chat_request.g.dart';

@Freezed()
abstract class OpenDirectChatRequest with _$OpenDirectChatRequest {
  const factory OpenDirectChatRequest({
    @JsonKey(name: 'account_id') required String accountId,
  }) = _OpenDirectChatRequest;

  factory OpenDirectChatRequest.fromJson(Map<String, Object?> json) =>
      _$OpenDirectChatRequestFromJson(json);
}
