// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateChangeRequest _$DateChangeRequestFromJson(Map<String, dynamic> json) =>
    _DateChangeRequest(
      requestId: json['request_id'] as String,
      workItemId: json['work_item_id'] as String,
      status: DateChangeRequestStatus.fromJson(json['status'] as String),
      oldStartOn: DateTime.parse(json['old_start_on'] as String),
      newStartOn: DateTime.parse(json['new_start_on'] as String),
      oldEndOn: DateTime.parse(json['old_end_on'] as String),
      newEndOn: DateTime.parse(json['new_end_on'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$DateChangeRequestToJson(_DateChangeRequest instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'work_item_id': instance.workItemId,
      'status': _$DateChangeRequestStatusEnumMap[instance.status]!,
      'old_start_on': instance.oldStartOn.toIso8601String(),
      'new_start_on': instance.newStartOn.toIso8601String(),
      'old_end_on': instance.oldEndOn.toIso8601String(),
      'new_end_on': instance.newEndOn.toIso8601String(),
      'reason': ?instance.reason,
    };

const _$DateChangeRequestStatusEnumMap = {
  DateChangeRequestStatus.pending: 'pending',
  DateChangeRequestStatus.approved: 'approved',
  DateChangeRequestStatus.rejected: 'rejected',
  DateChangeRequestStatus.$unknown: r'$unknown',
};
