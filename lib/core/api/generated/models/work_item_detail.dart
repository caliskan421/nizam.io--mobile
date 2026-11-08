// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

import 'pending_date_request.dart';
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

    /// Görevin bekleyen tarih talebi (WORK-K82). Her cevapta bulunur; `null` "bekleyen talep.
    /// yok ya da çağıran görmeye yetkili değil" demektir ve her uçta aynı anlamı taşır.
    /// Görev listeleri (`listProgramWorkItems`, `listWorkItems`), `getWorkItem`, oluşturma.
    /// ve güncelleme cevapları aynı kuralla doldurur: şirket yöneticisine her görevde,.
    /// koordinatöre yalnız **bu programda** koordinatörü olduğu departmanın görevinde.
    /// Üyeye (birleşik rolde yalnız üye olduğu departmanın görevinde de) `null`.
    /// Onaylanmış ya da reddedilmiş talep görünmez. Yeni oluşturulan görevin bekleyen.
    /// talebi olamayacağından oluşturma cevabında her zaman `null`'dır.
    ///
    @JsonKey(name: 'pending_date_request')
    required PendingDateRequest? pendingDateRequest,

    /// Görevin oluşturulma zamanı (UTC, RFC 3339; WORK-K83). Görev listeleri, `getWorkItem`,.
    /// oluşturma ve güncelleme cevaplarında aynı değerdir; güncelleme değiştirmez. İstemci.
    /// "tanımlanma tarihine göre" sıralamayı bu alanla yapar.
    ///
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// Görevi oluşturan hesabın kimliği (WORK-K83). Satırı görebilen herkes görür.
    @JsonKey(name: 'created_by_account_id') required String createdByAccountId,

    /// Oluşturanın görünen adı (WORK-K83); `WorkItemAssignee.full_name` ile aynı kural: hesabın satırı yoksa ya da ad okuması o an başarısızsa `null` (yanıt yine başarılıdır); silinmiş (geri yüklenebilir) hesabın adı döner.
    @JsonKey(name: 'created_by_full_name') required String? createdByFullName,

    /// Görev alanları grubunun (başlık, açıklama, öncelik, kanıt bayrağı) düzenleme sürümü (ADR-0027); PATCH gövdesinde `expected_revision` olarak geri gönderilir. Durum, atama, aktarım ve silme artırmaz.
    @JsonKey(name: 'edit_revision') required int editRevision,

    /// Tarih grubunun (başlangıç, bitiş, planlanan bitiş) düzenleme sürümü (ADR-0027); PATCH gövdesinde `expected_dates_revision` olarak geri gönderilir. Bu üç değeri ya da tamamlanma gününü değiştiren her yol artırır (form, tarih talebi onayı, uzatma, iki çekme, yönetici ayarı, tamamlanmaya geçiş, bağımlılık zinciri); gönderim çıpası artırmaz.
    @JsonKey(name: 'dates_revision') required int datesRevision,
    required String description,
    @DateOnlyConverter()
    @JsonKey(name: 'planned_end_on')
    DateTime? plannedEndOn,
    @DateOnlyConverter() @JsonKey(name: 'completed_on') DateTime? completedOn,
  }) = _WorkItemDetail;

  factory WorkItemDetail.fromJson(Map<String, Object?> json) =>
      _$WorkItemDetailFromJson(json);
}
