// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DependencyList _$DependencyListFromJson(Map<String, dynamic> json) =>
    _DependencyList(
      dependencies: (json['dependencies'] as List<dynamic>)
          .map((e) => DependencyEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
      dependents: (json['dependents'] as List<dynamic>)
          .map((e) => DependencyEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DependencyListToJson(_DependencyList instance) =>
    <String, dynamic>{
      'dependencies': instance.dependencies.map((e) => e.toJson()).toList(),
      'dependents': instance.dependents.map((e) => e.toJson()).toList(),
    };
