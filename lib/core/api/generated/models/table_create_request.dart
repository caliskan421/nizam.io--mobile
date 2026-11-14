// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_create_request_kind.dart';

part 'table_create_request.freezed.dart';
part 'table_create_request.g.dart';

@Freezed()
abstract class TableCreateRequest with _$TableCreateRequest {
  const factory TableCreateRequest({
    /// Kırpılmış, satır sonu ve NUL içermeyen ad (en çok 200 Unicode karakter).
    required String name,

    /// İsteğe bağlı; verilirse `create_table` olmalıdır.
    TableCreateRequestKind? kind,
  }) = _TableCreateRequest;

  factory TableCreateRequest.fromJson(Map<String, Object?> json) =>
      _$TableCreateRequestFromJson(json);
}
