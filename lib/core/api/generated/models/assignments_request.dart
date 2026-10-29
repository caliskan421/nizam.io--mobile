// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignments_request.freezed.dart';
part 'assignments_request.g.dart';

@Freezed()
abstract class AssignmentsRequest with _$AssignmentsRequest {
  const factory AssignmentsRequest({
    @JsonKey(name: 'account_ids') List<String>? accountIds,
  }) = _AssignmentsRequest;

  factory AssignmentsRequest.fromJson(Map<String, Object?> json) =>
      _$AssignmentsRequestFromJson(json);
}
