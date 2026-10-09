// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_department_request.freezed.dart';
part 'create_department_request.g.dart';

@Freezed()
abstract class CreateDepartmentRequest with _$CreateDepartmentRequest {
  const factory CreateDepartmentRequest({
    required String name,
    required String kind,
    String? code,
    String? description,
  }) = _CreateDepartmentRequest;

  factory CreateDepartmentRequest.fromJson(Map<String, Object?> json) =>
      _$CreateDepartmentRequestFromJson(json);
}
