// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'granted_membership.freezed.dart';
part 'granted_membership.g.dart';

@Freezed()
abstract class GrantedMembership with _$GrantedMembership {
  const factory GrantedMembership({
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'account_id') required String accountId,
  }) = _GrantedMembership;

  factory GrantedMembership.fromJson(Map<String, Object?> json) =>
      _$GrantedMembershipFromJson(json);
}
