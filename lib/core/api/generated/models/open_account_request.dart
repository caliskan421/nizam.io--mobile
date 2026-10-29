// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'open_account_request.freezed.dart';
part 'open_account_request.g.dart';

@Freezed(toStringOverride: false)
abstract class OpenAccountRequest with _$OpenAccountRequest {
  const factory OpenAccountRequest({
    required String email,
    required String password,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'force_password_change') bool? forcePasswordChange,
  }) = _OpenAccountRequest;

  factory OpenAccountRequest.fromJson(Map<String, Object?> json) =>
      _$OpenAccountRequestFromJson(json);
}
