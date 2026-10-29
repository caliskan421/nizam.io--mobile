// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'extend_request.freezed.dart';
part 'extend_request.g.dart';

@Freezed()
abstract class ExtendRequest with _$ExtendRequest {
  const factory ExtendRequest({
    /// Ek gün sayısı, 1–90 (aksi 422 `work.input_invalid`).
    required int days,
  }) = _ExtendRequest;

  factory ExtendRequest.fromJson(Map<String, Object?> json) =>
      _$ExtendRequestFromJson(json);
}
