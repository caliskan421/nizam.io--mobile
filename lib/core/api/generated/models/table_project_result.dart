// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_project_result.freezed.dart';
part 'table_project_result.g.dart';

@Freezed()
abstract class TableProjectResult with _$TableProjectResult {
  const factory TableProjectResult({
    /// Proje kimliği.
    required String id,

    /// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı (audit yazılmaz).
    required bool replayed,
  }) = _TableProjectResult;

  factory TableProjectResult.fromJson(Map<String, Object?> json) =>
      _$TableProjectResultFromJson(json);
}
