// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_presence_request.freezed.dart';
part 'table_presence_request.g.dart';

/// Presence yenileme gövdesi (ADR-0040). `row_id` ve `column_id` birlikte dolu ya da birlikte boş/`null` olmalıdır; hücre değeri taşınmaz.
@Freezed()
abstract class TablePresenceRequest with _$TablePresenceRequest {
  const factory TablePresenceRequest({
    @JsonKey(name: 'row_id') String? rowId,
    @JsonKey(name: 'column_id') String? columnId,
  }) = _TablePresenceRequest;

  factory TablePresenceRequest.fromJson(Map<String, Object?> json) =>
      _$TablePresenceRequestFromJson(json);
}
