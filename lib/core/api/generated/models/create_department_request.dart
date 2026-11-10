// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_department_request_kind.dart';

part 'create_department_request.freezed.dart';
part 'create_department_request.g.dart';

@Freezed()
abstract class CreateDepartmentRequest with _$CreateDepartmentRequest {
  const factory CreateDepartmentRequest({
    required String name,
    required CreateDepartmentRequestKind kind,

    /// İsteğe bağlı kısa kod. Sunucu baş/son boşluğu kırpar ve büyük harfe çevirir; sonuç `^[A-Z0-9]{2,10}$` biçiminde olmalıdır (ORGANIZATION-K10), aksi 422 `organization.input_invalid` (alan kodu `organization.invalid_code`). Kod şirkette tekildir (silinmiş departmanlar dahil): 409 `organization.department_code_conflict`.
    String? code,
    String? description,
  }) = _CreateDepartmentRequest;

  factory CreateDepartmentRequest.fromJson(Map<String, Object?> json) =>
      _$CreateDepartmentRequestFromJson(json);
}
