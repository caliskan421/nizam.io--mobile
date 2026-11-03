// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'update_work_item_request_priority.dart';

part 'update_work_item_request.freezed.dart';
part 'update_work_item_request.g.dart';

@Freezed()
abstract class UpdateWorkItemRequest with _$UpdateWorkItemRequest {
  const factory UpdateWorkItemRequest({
    String? title,
    String? description,
    UpdateWorkItemRequestPriority? priority,
    @DateOnlyConverter() @JsonKey(name: 'start_on') DateTime? startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') DateTime? endOn,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,

    /// Tamamlanma kanıtı bayrağı (ADR-0024); verilmezse değişmez. Değişim audit ve olay yazar.
    @JsonKey(name: 'completion_evidence_required')
    bool? completionEvidenceRequired,

    /// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
    @JsonKey(name: 'completed_on') String? completedOn,

    /// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
    @JsonKey(name: 'submitted_on') String? submittedOn,

    /// İstemcinin gördüğü `edit_revision` (ADR-0027). Gövdede title, description, priority ya da completion_evidence_required varsa zorunludur: yoksa 422 `work.input_invalid` + alan kodu `work.revision_required`, pozitif değilse `work.revision_invalid`; bayatsa ve istenen değerler güncelden farklıysa 409 `work.edit_conflict` (alan `expected_revision`). Değerler zaten günceldeyse 200 ve değişiklik yok. Tamsayı olmayan değer 422 `platform.body_invalid` alır (alan bilgisi yok).
    @JsonKey(name: 'expected_revision') int? expectedRevision,

    /// İstemcinin gördüğü `dates_revision` (ADR-0027). Gövdede start_on, end_on ya da planned_end_on varsa zorunludur; kodlar `expected_revision` ile aynıdır, 409 zarfının alanı `expected_dates_revision`dır. İki grup tek transaction içindedir: biri çatışırsa hiçbiri yazılmaz.
    @JsonKey(name: 'expected_dates_revision') int? expectedDatesRevision,
  }) = _UpdateWorkItemRequest;

  factory UpdateWorkItemRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateWorkItemRequestFromJson(json);
}
