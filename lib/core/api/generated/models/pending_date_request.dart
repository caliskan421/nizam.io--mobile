// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'pending_date_request.freezed.dart';
part 'pending_date_request.g.dart';

@Freezed()
abstract class PendingDateRequest with _$PendingDateRequest {
  const factory PendingDateRequest({
    /// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
    @JsonKey(name: 'request_id') required String requestId,
    @DateOnlyConverter()
    @JsonKey(name: 'new_start_on')
    required DateTime newStartOn,
    @DateOnlyConverter()
    @JsonKey(name: 'new_end_on')
    required DateTime newEndOn,
  }) = _PendingDateRequest;

  factory PendingDateRequest.fromJson(Map<String, Object?> json) =>
      _$PendingDateRequestFromJson(json);
}
