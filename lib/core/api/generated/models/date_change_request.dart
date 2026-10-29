// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'date_change_request_status.dart';

part 'date_change_request.freezed.dart';
part 'date_change_request.g.dart';

@Freezed()
abstract class DateChangeRequest with _$DateChangeRequest {
  const factory DateChangeRequest({
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    required DateChangeRequestStatus status,
    @DateOnlyConverter()
    @JsonKey(name: 'old_start_on')
    required DateTime oldStartOn,
    @DateOnlyConverter()
    @JsonKey(name: 'new_start_on')
    required DateTime newStartOn,
    @DateOnlyConverter()
    @JsonKey(name: 'old_end_on')
    required DateTime oldEndOn,
    @DateOnlyConverter()
    @JsonKey(name: 'new_end_on')
    required DateTime newEndOn,
    String? reason,
  }) = _DateChangeRequest;

  factory DateChangeRequest.fromJson(Map<String, Object?> json) =>
      _$DateChangeRequestFromJson(json);
}
