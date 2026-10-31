// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_work_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateWorkItemRequest _$UpdateWorkItemRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkItemRequest(
  title: json['title'] as String?,
  description: json['description'] as String?,
  priority: json['priority'] == null
      ? null
      : UpdateWorkItemRequestPriority.fromJson(json['priority'] as String),
  startOn: _$JsonConverterFromJson<String, DateTime>(
    json['start_on'],
    const DateOnlyConverter().fromJson,
  ),
  endOn: _$JsonConverterFromJson<String, DateTime>(
    json['end_on'],
    const DateOnlyConverter().fromJson,
  ),
  plannedEndOn: _$JsonConverterFromJson<String, DateTime>(
    json['planned_end_on'],
    const DateOnlyConverter().fromJson,
  ),
  completionEvidenceRequired: json['completion_evidence_required'] as bool?,
  completedOn: json['completed_on'] as String?,
  submittedOn: json['submitted_on'] as String?,
);

Map<String, dynamic> _$UpdateWorkItemRequestToJson(
  _UpdateWorkItemRequest instance,
) => <String, dynamic>{
  'title': ?instance.title,
  'description': ?instance.description,
  'priority': ?_$UpdateWorkItemRequestPriorityEnumMap[instance.priority],
  'start_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.startOn,
    const DateOnlyConverter().toJson,
  ),
  'end_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.endOn,
    const DateOnlyConverter().toJson,
  ),
  'planned_end_on': ?_$JsonConverterToJson<String, DateTime>(
    instance.plannedEndOn,
    const DateOnlyConverter().toJson,
  ),
  'completion_evidence_required': ?instance.completionEvidenceRequired,
  'completed_on': ?instance.completedOn,
  'submitted_on': ?instance.submittedOn,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$UpdateWorkItemRequestPriorityEnumMap = {
  UpdateWorkItemRequestPriority.dusuk: 'dusuk',
  UpdateWorkItemRequestPriority.orta: 'orta',
  UpdateWorkItemRequestPriority.yuksek: 'yuksek',
  UpdateWorkItemRequestPriority.acil: 'acil',
  UpdateWorkItemRequestPriority.$unknown: r'$unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
