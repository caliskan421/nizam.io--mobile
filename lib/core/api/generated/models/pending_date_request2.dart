// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'pending_date_request2.freezed.dart';
part 'pending_date_request2.g.dart';

@Freezed()
abstract class PendingDateRequest2 with _$PendingDateRequest2 {
  const factory PendingDateRequest2({
    /// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
    @JsonKey(name: 'request_id') required String requestId,
    @DateOnlyConverter()
    @JsonKey(name: 'new_start_on')
    required DateTime newStartOn,
    @DateOnlyConverter()
    @JsonKey(name: 'new_end_on')
    required DateTime newEndOn,
  }) = _PendingDateRequest2;

  factory PendingDateRequest2.fromJson(Map<String, Object?> json) =>
      _$PendingDateRequest2FromJson(json);
}
