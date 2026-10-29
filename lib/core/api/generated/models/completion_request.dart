// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'completion_request.freezed.dart';
part 'completion_request.g.dart';

@Freezed()
abstract class CompletionRequest with _$CompletionRequest {
  const factory CompletionRequest({
    @JsonKey(name: 'completed_on') required DateTime completedOn,
  }) = _CompletionRequest;

  factory CompletionRequest.fromJson(Map<String, Object?> json) =>
      _$CompletionRequestFromJson(json);
}
