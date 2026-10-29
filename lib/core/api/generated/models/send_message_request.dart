// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_request.freezed.dart';
part 'send_message_request.g.dart';

@Freezed()
abstract class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    @JsonKey(name: 'receiver_account_id') required String receiverAccountId,
    required String subject,
    required String content,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, Object?> json) =>
      _$SendMessageRequestFromJson(json);
}
