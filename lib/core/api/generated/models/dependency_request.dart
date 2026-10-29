// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependency_request.freezed.dart';
part 'dependency_request.g.dart';

@Freezed()
abstract class DependencyRequest with _$DependencyRequest {
  const factory DependencyRequest({
    @JsonKey(name: 'depends_on_work_item_id')
    required String dependsOnWorkItemId,
  }) = _DependencyRequest;

  factory DependencyRequest.fromJson(Map<String, Object?> json) =>
      _$DependencyRequestFromJson(json);
}
