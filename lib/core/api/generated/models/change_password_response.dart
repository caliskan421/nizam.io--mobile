// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_response.freezed.dart';
part 'change_password_response.g.dart';

@Freezed()
abstract class ChangePasswordResponse with _$ChangePasswordResponse {
  const factory ChangePasswordResponse({
    @JsonKey(name: 'revoked_sessions') required int revokedSessions,
  }) = _ChangePasswordResponse;

  factory ChangePasswordResponse.fromJson(Map<String, Object?> json) =>
      _$ChangePasswordResponseFromJson(json);
}
