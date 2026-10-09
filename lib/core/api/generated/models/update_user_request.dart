// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_request.freezed.dart';
part 'update_user_request.g.dart';

@Freezed()
abstract class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    String? email,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'reset_password') bool? resetPassword,
    @JsonKey(name: 'force_password_change') bool? forcePasswordChange,
    @JsonKey(name: 'company_admin') bool? companyAdmin,
  }) = _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateUserRequestFromJson(json);
}
