// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_date_request2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingDateRequest2 _$PendingDateRequest2FromJson(Map<String, dynamic> json) =>
    _PendingDateRequest2(
      requestId: json['request_id'] as String,
      newStartOn: const DateOnlyConverter().fromJson(
        json['new_start_on'] as String,
      ),
      newEndOn: const DateOnlyConverter().fromJson(
        json['new_end_on'] as String,
      ),
    );

Map<String, dynamic> _$PendingDateRequest2ToJson(
  _PendingDateRequest2 instance,
) => <String, dynamic>{
  'request_id': instance.requestId,
  'new_start_on': const DateOnlyConverter().toJson(instance.newStartOn),
  'new_end_on': const DateOnlyConverter().toJson(instance.newEndOn),
};
