// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorEnvelope _$ErrorEnvelopeFromJson(Map<String, dynamic> json) =>
    _ErrorEnvelope(
      code: json['code'] as String,
      message: json['message'] as String,
      requestId: json['request_id'] as String,
      correlationId: json['correlation_id'] as String?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList(),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$ErrorEnvelopeToJson(_ErrorEnvelope instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'request_id': instance.requestId,
      'correlation_id': ?instance.correlationId,
      'fields': ?instance.fields?.map((e) => e.toJson()).toList(),
      'details': ?instance.details,
    };
