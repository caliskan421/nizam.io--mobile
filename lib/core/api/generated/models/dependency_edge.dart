// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependency_edge.freezed.dart';
part 'dependency_edge.g.dart';

@Freezed()
abstract class DependencyEdge with _$DependencyEdge {
  const factory DependencyEdge({
    @JsonKey(name: 'dependency_id') required String dependencyId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'depends_on_work_item_id')
    required String dependsOnWorkItemId,
  }) = _DependencyEdge;

  factory DependencyEdge.fromJson(Map<String, Object?> json) =>
      _$DependencyEdgeFromJson(json);
}
