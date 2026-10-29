// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_target_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterTargetRequest _$RegisterTargetRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterTargetRequest(
  endpoint: json['endpoint'] as String,
  keys: Keys.fromJson(json['keys'] as Map<String, dynamic>),
  userAgent: json['user_agent'] as String?,
);

Map<String, dynamic> _$RegisterTargetRequestToJson(
  _RegisterTargetRequest instance,
) => <String, dynamic>{
  'endpoint': instance.endpoint,
  'keys': instance.keys.toJson(),
  'user_agent': ?instance.userAgent,
};
