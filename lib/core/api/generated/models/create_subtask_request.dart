// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'create_subtask_request.freezed.dart';
part 'create_subtask_request.g.dart';

@Freezed()
abstract class CreateSubtaskRequest with _$CreateSubtaskRequest {
  const factory CreateSubtaskRequest({
    /// 1–300 karakter (kırpılarak), kontrol karakteri yok.
    required String title,

    /// Opsiyonel; yalnız ana göreve atanmış hesap (aksi 422 `work.subtask_assignee_not_assigned`).
    @JsonKey(name: 'assignee_account_id') String? assigneeAccountId,

    /// Opsiyonel; `end_on` ile birlikte verilir. Yalnız bilgidir (Gantt, bağımlılık ve gecikmeye girmez).
    @DateOnlyConverter() @JsonKey(name: 'start_on') DateTime? startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') DateTime? endOn,

    /// Opsiyonel (varsayılan false). Açıksa alt görev, kendisine bağlı en az bir dosya olmadan kapatılamaz (422 `work.subtask_attachment_required`; WORK-K70).
    @JsonKey(name: 'evidence_required') bool? evidenceRequired,
  }) = _CreateSubtaskRequest;

  factory CreateSubtaskRequest.fromJson(Map<String, Object?> json) =>
      _$CreateSubtaskRequestFromJson(json);
}
