// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../date_only.dart';

import 'update_work_item_request_priority.dart';

part 'update_work_item_request.freezed.dart';
part 'update_work_item_request.g.dart';

@Freezed()
abstract class UpdateWorkItemRequest with _$UpdateWorkItemRequest {
  const factory UpdateWorkItemRequest({
    String? title,
    String? description,
    UpdateWorkItemRequestPriority? priority,
    @DateOnlyConverter() @JsonKey(name: 'start_on') DateTime? startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') DateTime? endOn,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,

    /// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
    @JsonKey(name: 'completed_on') String? completedOn,

    /// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
    @JsonKey(name: 'submitted_on') String? submittedOn,
  }) = _UpdateWorkItemRequest;

  factory UpdateWorkItemRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateWorkItemRequestFromJson(json);
}
