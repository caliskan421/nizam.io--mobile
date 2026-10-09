// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'roster_member_status.dart';

part 'roster_member.freezed.dart';
part 'roster_member.g.dart';

@Freezed()
abstract class RosterMember with _$RosterMember {
  const factory RosterMember({
    @JsonKey(name: 'membership_id') required String membershipId,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
    required RosterMemberStatus status,
  }) = _RosterMember;

  factory RosterMember.fromJson(Map<String, Object?> json) =>
      _$RosterMemberFromJson(json);
}
