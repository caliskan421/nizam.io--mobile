// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gantt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Gantt _$GanttFromJson(Map<String, dynamic> json) => _Gantt(
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => GanttTask.fromJson(e as Map<String, dynamic>))
      .toList(),
  links: (json['links'] as List<dynamic>)
      .map((e) => GanttLink.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GanttToJson(_Gantt instance) => <String, dynamic>{
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
  'links': instance.links.map((e) => e.toJson()).toList(),
};
