// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipChange _$MembershipChangeFromJson(Map<String, dynamic> json) =>
    _MembershipChange(
      membershipId: json['membership_id'] as String,
      unassignedTasks: (json['unassigned_tasks'] as num).toInt(),
      warning: json['warning'] as bool,
    );

Map<String, dynamic> _$MembershipChangeToJson(_MembershipChange instance) =>
    <String, dynamic>{
      'membership_id': instance.membershipId,
      'unassigned_tasks': instance.unassignedTasks,
      'warning': instance.warning,
    };
