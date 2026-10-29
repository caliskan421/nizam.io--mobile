// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_change_request_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateChangeRequestCreate _$DateChangeRequestCreateFromJson(
  Map<String, dynamic> json,
) => _DateChangeRequestCreate(
  workItemId: json['work_item_id'] as String,
  newStartOn: DateTime.parse(json['new_start_on'] as String),
  newEndOn: DateTime.parse(json['new_end_on'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DateChangeRequestCreateToJson(
  _DateChangeRequestCreate instance,
) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'new_start_on': instance.newStartOn.toIso8601String(),
  'new_end_on': instance.newEndOn.toIso8601String(),
  'reason': ?instance.reason,
};
