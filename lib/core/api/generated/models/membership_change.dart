// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_change.freezed.dart';
part 'membership_change.g.dart';

@Freezed()
abstract class MembershipChange with _$MembershipChange {
  const factory MembershipChange({
    @JsonKey(name: 'membership_id') required String membershipId,
    @JsonKey(name: 'unassigned_tasks') required int unassignedTasks,
    required bool warning,
  }) = _MembershipChange;

  factory MembershipChange.fromJson(Map<String, Object?> json) =>
      _$MembershipChangeFromJson(json);
}
