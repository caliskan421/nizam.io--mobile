// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'review_request_decision.dart';

part 'review_request.freezed.dart';
part 'review_request.g.dart';

@Freezed()
abstract class ReviewRequest with _$ReviewRequest {
  const factory ReviewRequest({
    /// `approved` ya da `rejected`.
    required ReviewRequestDecision decision,
  }) = _ReviewRequest;

  factory ReviewRequest.fromJson(Map<String, Object?> json) =>
      _$ReviewRequestFromJson(json);
}
