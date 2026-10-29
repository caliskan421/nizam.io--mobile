// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'keys.dart';

part 'register_target_request.freezed.dart';
part 'register_target_request.g.dart';

@Freezed()
abstract class RegisterTargetRequest with _$RegisterTargetRequest {
  const factory RegisterTargetRequest({
    /// Push servisinin https uç noktası (izin listesindeki ana makine).
    required String endpoint,
    required Keys keys,
    @JsonKey(name: 'user_agent') String? userAgent,
  }) = _RegisterTargetRequest;

  factory RegisterTargetRequest.fromJson(Map<String, Object?> json) =>
      _$RegisterTargetRequestFromJson(json);
}
