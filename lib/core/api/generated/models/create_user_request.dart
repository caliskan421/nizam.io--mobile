// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_request.freezed.dart';
part 'create_user_request.g.dart';

@Freezed()
abstract class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String email,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'full_name') String? fullName,
    String? role,
    @JsonKey(name: 'transfer_account_id') String? transferAccountId,
    @JsonKey(name: 'company_admin') bool? companyAdmin,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, Object?> json) =>
      _$CreateUserRequestFromJson(json);
}
