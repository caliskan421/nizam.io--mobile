// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gantt_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GanttLink _$GanttLinkFromJson(Map<String, dynamic> json) => _GanttLink(
  dependencyId: json['dependency_id'] as String,
  source: json['source'] as String,
  target: json['target'] as String,
  crossDepartment: json['cross_department'] as bool,
);

Map<String, dynamic> _$GanttLinkToJson(_GanttLink instance) =>
    <String, dynamic>{
      'dependency_id': instance.dependencyId,
      'source': instance.source,
      'target': instance.target,
      'cross_department': instance.crossDepartment,
    };
