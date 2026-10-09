// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assign_membership_request.freezed.dart';
part 'assign_membership_request.g.dart';

@Freezed()
abstract class AssignMembershipRequest with _$AssignMembershipRequest {
  const factory AssignMembershipRequest({
    @JsonKey(name: 'account_id') required String accountId,
    required String role,
  }) = _AssignMembershipRequest;

  factory AssignMembershipRequest.fromJson(Map<String, Object?> json) =>
      _$AssignMembershipRequestFromJson(json);
}
