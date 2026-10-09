// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_department_request.freezed.dart';
part 'link_department_request.g.dart';

@Freezed()
abstract class LinkDepartmentRequest with _$LinkDepartmentRequest {
  const factory LinkDepartmentRequest({
    @JsonKey(name: 'department_id') required String departmentId,
  }) = _LinkDepartmentRequest;

  factory LinkDepartmentRequest.fromJson(Map<String, Object?> json) =>
      _$LinkDepartmentRequestFromJson(json);
}
