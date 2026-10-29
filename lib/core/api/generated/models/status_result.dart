// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_result.freezed.dart';
part 'status_result.g.dart';

@Freezed()
abstract class StatusResult with _$StatusResult {
  const factory StatusResult({
    /// İşlemin sonucu (ör. `deleted`, `claimed`, `unclaimed`, `updated`, `removed`).
    required String status,
  }) = _StatusResult;

  factory StatusResult.fromJson(Map<String, Object?> json) =>
      _$StatusResultFromJson(json);
}
