// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'vote_chat_poll_request.freezed.dart';
part 'vote_chat_poll_request.g.dart';

@Freezed()
abstract class VoteChatPollRequest with _$VoteChatPollRequest {
  const factory VoteChatPollRequest({
    @JsonKey(name: 'option_indexes') required List<int> optionIndexes,
  }) = _VoteChatPollRequest;

  factory VoteChatPollRequest.fromJson(Map<String, Object?> json) =>
      _$VoteChatPollRequestFromJson(json);
}
