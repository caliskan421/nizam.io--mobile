// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_account_request.freezed.dart';
part 'update_account_request.g.dart';

@Freezed(toStringOverride: false)
abstract class UpdateAccountRequest with _$UpdateAccountRequest {
  const factory UpdateAccountRequest({
    String? email,
    @JsonKey(name: 'full_name') String? fullName,
    String? password,
    @JsonKey(name: 'force_password_change') bool? forcePasswordChange,
  }) = _UpdateAccountRequest;

  factory UpdateAccountRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateAccountRequestFromJson(json);
}
