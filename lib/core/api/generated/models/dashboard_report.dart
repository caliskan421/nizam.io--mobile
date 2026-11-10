// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinatorship_stat.dart';
import 'overdue_task.dart';

part 'dashboard_report.freezed.dart';
part 'dashboard_report.g.dart';

/// Seçili programın yönetici özeti (REPORTING-K02). Görev sayaçları ve dağılımlar.
/// programın silinmemiş görevlerinden, YALNIZ programa katılan canlı (silinmemiş).
/// departmanlarınkinden sayılır; silinmiş departmandaki canlı görev sayılmaz (bu yüzden.
/// `countProgramWorkItems`'ın yönetici sayaçlarından farklı olabilir).
///
@Freezed()
abstract class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,

    /// Programa katılan canlı departman sayısı.
    @JsonKey(name: 'total_coordinatorships') required int totalCoordinatorships,

    /// Canlı katılan departmanlardaki silinmemiş görev sayısı.
    @JsonKey(name: 'total_tasks') required int totalTasks,

    /// `total_tasks − completed_tasks` (tamamlanmamış her durum).
    @JsonKey(name: 'active_tasks') required int activeTasks,

    /// Durumu `tamamlandi` olan görev sayısı.
    @JsonKey(name: 'completed_tasks') required int completedTasks,

    /// Tamamlanmamış ve `end_on` günü bugünden (kurulum saat dilimi) önce olan görev sayısı; `overdue_tasks_list` ile aynı kümedir.
    @JsonKey(name: 'overdue_tasks') required int overdueTasks,

    /// Durumu `onaya_sunuldu` olan görev sayısı.
    @JsonKey(name: 'pending_approvals') required int pendingApprovals,

    /// Canlı katılan departmanlardaki silinmemiş görevlerin bekleyen (`pending`) tarih talebi sayısı; diğer görev sayaçlarıyla aynı kapsam (silinmiş departmanda kalan canlı görevin talebi sayılmaz, `countProgramWorkItems` ise sayar).
    @JsonKey(name: 'pending_date_changes') required int pendingDateChanges,
    @JsonKey(name: 'task_status_distribution')
    required Map<String, int> taskStatusDistribution,
    @JsonKey(name: 'priority_distribution')
    required Map<String, int> priorityDistribution,

    /// Tekil hesap sayısı: canlı katılan departmanların bu programdaki ekibi + şirket geneli yöneticiler; silinmiş hesap sayılmaz.
    @JsonKey(name: 'total_users') required int totalUsers,

    /// Şirket geneli yönetici sayısı (programa bağlı değildir); silinmiş hesap sayılmaz.
    @JsonKey(name: 'total_admins') required int totalAdmins,

    /// Bu programda en az bir canlı departmanda koordinatör olan tekil hesap sayısı.
    @JsonKey(name: 'total_coordinators') required int totalCoordinators,

    /// Bu programda en az bir canlı departmanda `uye` olan tekil hesap sayısı. Rol sayaçları örtüşebilir: bir departmanda koordinatör, başka birinde üye olan hesap iki sayaçta da, ekipteki yönetici hem `total_admins`'ta hem rol sayacında sayılır; tekil toplam `total_users`'tır.
    @JsonKey(name: 'total_members') required int totalMembers,

    /// Toplam: programın silinmiş görevleri + programın silinmiş toplantıları + programa bağlı silinmiş departmanlar + ŞİRKET GENELİNDEKİ silinmiş hesaplar (hesaplar programa bağlı değildir).
    @JsonKey(name: 'deleted_records') required int deletedRecords,

    /// Canlı katılan her departman için bir satır; departmanın programdaki adına göre büyük/küçük harf duyarsız bayt sırasıyla (Türkçe alfabe sırası uygulanmaz). Kesilmez.
    @JsonKey(name: 'coordinatorship_stats')
    required List<CoordinatorshipStat> coordinatorshipStats,

    /// Geciken görevlerin tamamı (canlı katılan departmanlar), en yeni oluşturulan önce; atananlarda silinmiş hesap listelenmez. Kesilmez.
    @JsonKey(name: 'overdue_tasks_list')
    required List<OverdueTask> overdueTasksList,

    /// Değerlerin hesaplandığı an (UTC); önbellek yoktur.
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
  }) = _DashboardReport;

  factory DashboardReport.fromJson(Map<String, Object?> json) =>
      _$DashboardReportFromJson(json);
}
