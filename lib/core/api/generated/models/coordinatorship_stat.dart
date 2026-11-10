// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_person.dart';

part 'coordinatorship_stat.freezed.dart';
part 'coordinatorship_stat.g.dart';

/// Programa katılan canlı bir departmanın (arayüzde "koordinatörlük") istatistiği. Görev.
/// sayaçları programın silinmemiş görevlerindendir; departman adı programdaki addır.
///
@Freezed()
abstract class CoordinatorshipStat with _$CoordinatorshipStat {
  const factory CoordinatorshipStat({
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required String kind,

    /// Departmanın bu programdaki koordinatörleri; silinmiş hesap listelenmez.
    required List<ReportPerson> coordinators,

    /// Departmanın silinmemiş görev sayısı.
    @JsonKey(name: 'total_tasks') required int totalTasks,
    @JsonKey(name: 'completed_tasks') required int completedTasks,

    /// Durumu `devam_ediyor` olan görev sayısı (`onaya_sunuldu` ve `iade_edildi` bu üç sayaçtan hiçbirine girmez).
    @JsonKey(name: 'in_progress_tasks') required int inProgressTasks,

    /// Durumu `baslanmadi` olan görev sayısı.
    @JsonKey(name: 'not_started_tasks') required int notStartedTasks,

    /// Tamamlanmamış ve `end_on` günü bugünden (kurulum saat dilimi) önce olan görev sayısı.
    @JsonKey(name: 'overdue_tasks') required int overdueTasks,

    /// `completed_tasks / total_tasks × 100`; görev yoksa 0.
    @JsonKey(name: 'completion_rate') required double completionRate,

    /// Departmanın bu programdaki ekibinde `uye` rolündeki canlı hesap sayısı; koordinatörler DAHİL DEĞİLDİR (koordinatörler `coordinators` dizisindedir).
    @JsonKey(name: 'member_count') required int memberCount,

    /// `reportDashboard` ve `reportDashboardCoordinatorships` yanıtlarında doldurulmaz, her zaman 0'dır; departman başına toplantı sayısı yalnız dönem raporunda (`reportSeason`) hesaplanır ([GAP-221](../known-gaps.md#gap-221)).
    @JsonKey(name: 'meeting_count') required int meetingCount,

    /// Departmanın silinmemiş görevlerinin en son güncellenme anı (`updated_at` en büyüğü, UTC); görevi yoksa `null`. Toplantı, not ve mesaj etkinliği girmez.
    @JsonKey(name: 'last_activity_at') required String? lastActivityAt,
    String? description,
  }) = _CoordinatorshipStat;

  factory CoordinatorshipStat.fromJson(Map<String, Object?> json) =>
      _$CoordinatorshipStatFromJson(json);
}
