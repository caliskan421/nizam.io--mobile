// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthResponse _$HealthResponseFromJson(Map<String, dynamic> json) =>
    _HealthResponse(
      status: HealthResponseStatus.fromJson(json['status'] as String),
    );

Map<String, dynamic> _$HealthResponseToJson(_HealthResponse instance) =>
    <String, dynamic>{
      'status': _$HealthResponseStatusEnumMap[instance.status]!,
    };

const _$HealthResponseStatusEnumMap = {
  HealthResponseStatus.live: 'live',
  HealthResponseStatus.ready: 'ready',
  HealthResponseStatus.$unknown: r'$unknown',
};
