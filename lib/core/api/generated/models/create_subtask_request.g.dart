// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_subtask_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateSubtaskRequest _$CreateSubtaskRequestFromJson(
  Map<String, dynamic> json,
) => _CreateSubtaskRequest(
  title: json['title'] as String,
  assigneeAccountId: json['assignee_account_id'] as String?,
  startOn: _$JsonConverterFromJson<String, DateTime>(
    json['start_on'],
    const DateOnlyConverter().fromJson,
  ),
  endOn: _$JsonConverterFromJson<String, DateTime>(
    json['end_on'],
    const DateOnlyConverter().fromJson,
  ),
);

Map<String, dynamic> _$CreateSubtaskRequestToJson(
  _CreateSubtaskRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'assignee_account_id': ?instance.assigneeAccountId,
  'start_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.startOn,
    const DateOnlyConverter().toJson,
  ),
  'end_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.endOn,
    const DateOnlyConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
