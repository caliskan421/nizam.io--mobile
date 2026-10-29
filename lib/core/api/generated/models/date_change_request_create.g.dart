// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_change_request_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateChangeRequestCreate _$DateChangeRequestCreateFromJson(
  Map<String, dynamic> json,
) => _DateChangeRequestCreate(
  workItemId: json['work_item_id'] as String,
  newStartOn: const DateOnlyConverter().fromJson(
    json['new_start_on'] as String,
  ),
  newEndOn: const DateOnlyConverter().fromJson(json['new_end_on'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DateChangeRequestCreateToJson(
  _DateChangeRequestCreate instance,
) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'new_start_on': const DateOnlyConverter().toJson(instance.newStartOn),
  'new_end_on': const DateOnlyConverter().toJson(instance.newEndOn),
  'reason': ?instance.reason,
};
