// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'register_device_token_request_platform.dart';

part 'register_device_token_request.freezed.dart';
part 'register_device_token_request.g.dart';

@Freezed(toStringOverride: false)
abstract class RegisterDeviceTokenRequest with _$RegisterDeviceTokenRequest {
  const factory RegisterDeviceTokenRequest({
    /// FCM kayıt belirteci (sır; hiçbir cevapta dönmez).
    required String token,
    required RegisterDeviceTokenRequestPlatform platform,
  }) = _RegisterDeviceTokenRequest;

  factory RegisterDeviceTokenRequest.fromJson(Map<String, Object?> json) =>
      _$RegisterDeviceTokenRequestFromJson(json);
}
