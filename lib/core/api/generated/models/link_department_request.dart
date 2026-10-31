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

    /// Departmanın bu programdaki adı; verilmezse katalog adı kopyalanır.
    @JsonKey(name: 'display_name') String? displayName,

    /// Verilirse bu programdaki aynı departmanın ekibi rolleriyle kopyalanır.
    @JsonKey(name: 'copy_members_from_program_id')
    String? copyMembersFromProgramId,
  }) = _LinkDepartmentRequest;

  factory LinkDepartmentRequest.fromJson(Map<String, Object?> json) =>
      _$LinkDepartmentRequestFromJson(json);
}
