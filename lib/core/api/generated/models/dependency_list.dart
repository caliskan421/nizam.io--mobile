// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'dependency_edge.dart';

part 'dependency_list.freezed.dart';
part 'dependency_list.g.dart';

@Freezed()
abstract class DependencyList with _$DependencyList {
  const factory DependencyList({
    /// Ön görevler.
    required List<DependencyEdge> dependencies,

    /// Bu göreve bağımlı görevler.
    required List<DependencyEdge> dependents,
  }) = _DependencyList;

  factory DependencyList.fromJson(Map<String, Object?> json) =>
      _$DependencyListFromJson(json);
}
