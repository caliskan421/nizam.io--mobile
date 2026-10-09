// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_role_request.freezed.dart';
part 'change_role_request.g.dart';

@Freezed()
abstract class ChangeRoleRequest with _$ChangeRoleRequest {
  const factory ChangeRoleRequest({required String role, bool? confirm}) =
      _ChangeRoleRequest;

  factory ChangeRoleRequest.fromJson(Map<String, Object?> json) =>
      _$ChangeRoleRequestFromJson(json);
}
