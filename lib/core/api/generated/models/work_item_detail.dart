// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'subtask_counts.dart';
import 'work_item_assignee.dart';
import 'work_item_priority.dart';
import 'work_item_status.dart';

part 'work_item_detail.freezed.dart';
part 'work_item_detail.g.dart';

/// Tekil görev cevabı: `WorkItem` alanları ve zorunlu açıklama (boş dize olabilir). Açıklama listede taşınmaz.
@Freezed()
abstract class WorkItemDetail with _$WorkItemDetail {
  const factory WorkItemDetail({
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'department_id') required String departmentId,
    required String title,
    required WorkItemPriority priority,
    required WorkItemStatus status,
    @JsonKey(name: 'assignee_account_ids')
    required List<String> assigneeAccountIds,

    /// Atananlar görünen adlarıyla; sıra `assignee_account_ids` ile aynıdır. `assignee_account_ids` geriye uyum için korunur.
    required List<WorkItemAssignee> assignees,

    /// Planlanan başlangıç günü (tarih kaydından; liste, oluşturma, güncelleme ve tekil uçta dolu).
    @DateOnlyConverter() @JsonKey(name: 'start_on') required DateTime startOn,

    /// Bitiş günü (tarih kaydından). Geç tamamlamada tamamlanma gününe itilmiş olabilir; özgün plan `planned_end_on`dadır.
    @DateOnlyConverter() @JsonKey(name: 'end_on') required DateTime endOn,
    @JsonKey(name: 'is_overdue') required bool isOverdue,
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'is_completed_late') required bool isCompletedLate,
    @JsonKey(name: 'days_late') required int daysLate,
    @JsonKey(name: 'is_completed_early') required bool isCompletedEarly,
    @JsonKey(name: 'days_early') required int daysEarly,

    /// Tamamlanma kanıtı bayrağı (ADR-0024): açıkken onaya sunma, doğrudan tamamlama ve onay en az bir ek dosya ister.
    @JsonKey(name: 'completion_evidence_required')
    required bool completionEvidenceRequired,
    @JsonKey(name: 'subtask_counts') required SubtaskCounts subtaskCounts,
    required String description,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,
    @DateOnlyConverter() @JsonKey(name: 'completed_on') DateTime? completedOn,
  }) = _WorkItemDetail;

  factory WorkItemDetail.fromJson(Map<String, Object?> json) =>
      _$WorkItemDetailFromJson(json);
}
