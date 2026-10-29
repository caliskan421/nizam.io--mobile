// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignmentsRequest _$AssignmentsRequestFromJson(Map<String, dynamic> json) =>
    _AssignmentsRequest(
      accountIds: (json['account_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssignmentsRequestToJson(_AssignmentsRequest instance) =>
    <String, dynamic>{'account_ids': ?instance.accountIds};
