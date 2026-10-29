// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency_edge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DependencyEdge _$DependencyEdgeFromJson(Map<String, dynamic> json) =>
    _DependencyEdge(
      dependencyId: json['dependency_id'] as String,
      workItemId: json['work_item_id'] as String,
      dependsOnWorkItemId: json['depends_on_work_item_id'] as String,
    );

Map<String, dynamic> _$DependencyEdgeToJson(_DependencyEdge instance) =>
    <String, dynamic>{
      'dependency_id': instance.dependencyId,
      'work_item_id': instance.workItemId,
      'depends_on_work_item_id': instance.dependsOnWorkItemId,
    };
