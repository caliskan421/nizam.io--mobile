// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_change_request_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateChangeRequestList _$DateChangeRequestListFromJson(
  Map<String, dynamic> json,
) => _DateChangeRequestList(
  requests: (json['requests'] as List<dynamic>)
      .map((e) => DateChangeRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$DateChangeRequestListToJson(
  _DateChangeRequestList instance,
) => <String, dynamic>{
  'requests': instance.requests.map((e) => e.toJson()).toList(),
  'total': instance.total,
};
