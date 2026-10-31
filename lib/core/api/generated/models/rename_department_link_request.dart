// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'rename_department_link_request.freezed.dart';
part 'rename_department_link_request.g.dart';

@Freezed()
abstract class RenameDepartmentLinkRequest with _$RenameDepartmentLinkRequest {
  const factory RenameDepartmentLinkRequest({
    @JsonKey(name: 'display_name') required String displayName,
  }) = _RenameDepartmentLinkRequest;

  factory RenameDepartmentLinkRequest.fromJson(Map<String, Object?> json) =>
      _$RenameDepartmentLinkRequestFromJson(json);
}
