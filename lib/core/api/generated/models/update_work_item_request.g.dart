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
  startOn: json['start_on'] == null
      ? null
      : DateTime.parse(json['start_on'] as String),
  endOn: json['end_on'] == null
      ? null
      : DateTime.parse(json['end_on'] as String),
  plannedEndOn: json['planned_end_on'] == null
      ? null
      : DateTime.parse(json['planned_end_on'] as String),
  completedOn: json['completed_on'] as String?,
  submittedOn: json['submitted_on'] as String?,
);

Map<String, dynamic> _$UpdateWorkItemRequestToJson(
  _UpdateWorkItemRequest instance,
) => <String, dynamic>{
  'title': ?instance.title,
  'description': ?instance.description,
  'priority': ?_$UpdateWorkItemRequestPriorityEnumMap[instance.priority],
  'start_on': ?instance.startOn?.toIso8601String(),
  'end_on': ?instance.endOn?.toIso8601String(),
  'planned_end_on': ?instance.plannedEndOn?.toIso8601String(),
  'completed_on': ?instance.completedOn,
  'submitted_on': ?instance.submittedOn,
};

const _$UpdateWorkItemRequestPriorityEnumMap = {
  UpdateWorkItemRequestPriority.dusuk: 'dusuk',
  UpdateWorkItemRequestPriority.orta: 'orta',
  UpdateWorkItemRequestPriority.yuksek: 'yuksek',
  UpdateWorkItemRequestPriority.acil: 'acil',
  UpdateWorkItemRequestPriority.$unknown: r'$unknown',
};
