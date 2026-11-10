// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'gantt_task_priority.dart';
import 'lateness.dart';
import 'pending_date_request2.dart';
import 'subtask_counts.dart';

part 'gantt_task.freezed.dart';
part 'gantt_task.g.dart';

@Freezed()
abstract class GanttTask with _$GanttTask {
  const factory GanttTask({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'department_id') required String departmentId,
    required GanttTaskPriority priority,
    required String status,
    @JsonKey(name: 'start_on') required String startOn,
    @JsonKey(name: 'end_on') required String endOn,

    /// Boşsa planlanan bitiş `end_on`'dur.
    @JsonKey(name: 'planned_end_on') required String plannedEndOn,

    /// Boşsa tamamlanmamış.
    @JsonKey(name: 'completed_on') required String completedOn,
    @JsonKey(name: 'assignee_account_ids')
    required List<String> assigneeAccountIds,
    required Lateness lateness,

    /// Görevin bekleyen tarih talebi (WORK-K82, WORK-K88); `WorkItem.pending_date_request` ile.
    /// aynı alan ve aynı kural. Her satırda bulunur; `null` "bekleyen talep yok ya da çağıran.
    /// görmeye yetkili değil" demektir. Yönetici ve koordinatör yüzünde her satırda doludur.
    /// (talep varsa); üye yüzünde (`memberGantt`) yalnız çağıran şirket yöneticisi ya da bu.
    /// departmanın koordinatörüyse dolar, yalnız üyede her satır `null`'dur. Değer aynı.
    /// çağıranın `getWorkItem` cevabındakiyle aynıdır. Onaylanmış ya da reddedilmiş talep.
    /// görünmez.
    ///
    @JsonKey(name: 'pending_date_request')
    required PendingDateRequest2? pendingDateRequest,

    /// Alt görev sayaçları (WORK-K88); görev listeleri ve `getWorkItem` ile aynı değer. Alt görevi olmayan görevde `{total: 0, done: 0}`.
    @JsonKey(name: 'subtask_counts') required SubtaskCounts subtaskCounts,

    /// Tarih grubunun düzenleme sürümü (ADR-0027; WORK-K88); `WorkItem.dates_revision` ile aynı değer. Gantt'tan sürükleyerek tarih yazan istemci bu değeri `updateWorkItem` gövdesinde `expected_dates_revision` olarak gönderir; arada tarih değiştiyse 409 `work.edit_conflict` alır ve Gantt'ı yeniden okur.
    @JsonKey(name: 'dates_revision') required int datesRevision,
  }) = _GanttTask;

  factory GanttTask.fromJson(Map<String, Object?> json) =>
      _$GanttTaskFromJson(json);
}
