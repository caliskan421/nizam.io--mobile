// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@Freezed()
abstract class Membership with _$Membership {
  const factory Membership({
    @JsonKey(name: 'membership_id') required String membershipId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'account_id') required String accountId,
    required String role,
  }) = _Membership;

  factory Membership.fromJson(Map<String, Object?> json) =>
      _$MembershipFromJson(json);
}
