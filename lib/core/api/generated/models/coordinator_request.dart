// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinator_request.freezed.dart';
part 'coordinator_request.g.dart';

@Freezed()
abstract class CoordinatorRequest with _$CoordinatorRequest {
  const factory CoordinatorRequest({
    @JsonKey(name: 'account_id') required String accountId,
  }) = _CoordinatorRequest;

  factory CoordinatorRequest.fromJson(Map<String, Object?> json) =>
      _$CoordinatorRequestFromJson(json);
}
