// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_assignee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemAssignee _$WorkItemAssigneeFromJson(Map<String, dynamic> json) =>
    _WorkItemAssignee(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String?,
    );

Map<String, dynamic> _$WorkItemAssigneeToJson(_WorkItemAssignee instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': ?instance.fullName,
    };
