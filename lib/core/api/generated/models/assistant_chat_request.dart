// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_chat_request.freezed.dart';
part 'assistant_chat_request.g.dart';

@Freezed()
abstract class AssistantChatRequest with _$AssistantChatRequest {
  const factory AssistantChatRequest({
    /// Soru metni (boş olamaz; uzunluk sınırı domain kuralıdır).
    required String soru,

    /// Devam ettirilecek sohbet; boşsa yeni sohbet açılır.
    @JsonKey(name: 'sohbet_id') String? sohbetId,
  }) = _AssistantChatRequest;

  factory AssistantChatRequest.fromJson(Map<String, Object?> json) =>
      _$AssistantChatRequestFromJson(json);
}
