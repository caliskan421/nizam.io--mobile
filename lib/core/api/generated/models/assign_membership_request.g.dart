// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_membership_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignMembershipRequest _$AssignMembershipRequestFromJson(
  Map<String, dynamic> json,
) => _AssignMembershipRequest(
  accountId: json['account_id'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$AssignMembershipRequestToJson(
  _AssignMembershipRequest instance,
) => <String, dynamic>{'account_id': instance.accountId, 'role': instance.role};
