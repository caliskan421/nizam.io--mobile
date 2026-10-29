import 'package:meta/meta.dart';

import 'home_dashboard.dart';

/// Görev durumu (sunucu `WorkItem.status`: `baslanmadi`, `devam_ediyor`, `onaya_sunuldu`,
/// `iade_edildi`, `tamamlandi`). Bilinmeyen değer [unknown] olur.
enum DashboardTaskStatus {
  notStarted,
  inProgress,
  submitted,
  returned,
  completed,
  unknown,
}

/// Görev önceliği (sunucu `dusuk`, `orta`, `yuksek`, `acil`).
enum DashboardTaskPriority { low, medium, high, urgent, unknown }

/// Rapordaki kişi (yalnız ad-soyad; raporlar e-posta taşımaz — REPORTING-K13).
@immutable
final class DashboardPerson {
  const DashboardPerson({required this.accountId, required this.fullName});

  final String accountId;
  final String fullName;
}

/// Gecikmiş görev satırı (`DashboardReport.overdue_tasks_list`).
@immutable
final class OverdueTaskSummary {
  const OverdueTaskSummary({
    required this.workItemId,
    required this.title,
    required this.departmentId,
    required this.departmentName,
    required this.assignees,
    required this.dueOn,
    required this.daysOverdue,
  });

  final String workItemId;
  final String title;
  final String departmentId;
  final String departmentName;
  final List<DashboardPerson> assignees;
  final DateTime dueOn;
  final int daysOverdue;
}

/// Yönetici panosu (`GET /v1/reports/dashboard`, S2, yalnız şirket yöneticisine açık —
/// diğer roller `reporting.not_authorized` alır; istemci bu kuralı türetmez, hatayı
/// gösterir). Ana sayfa varlıklarını ([TaskTotals], [TeamTotals],
/// [CoordinatorshipSummary]) yeniden kullanır; [HomeDashboard]'un karşılama, bekleyen işler
/// ve rozet alanları başka uçlardan gelir (`/v1/me`, mesaj ve tarih talebi sayıları).
@immutable
final class DashboardReport {
  const DashboardReport({
    required this.programId,
    required this.programName,
    required this.totalCoordinatorships,
    required this.tasks,
    required this.activeTasks,
    required this.pendingDateChanges,
    required this.statusDistribution,
    required this.priorityDistribution,
    required this.team,
    required this.deletedRecords,
    required this.coordinatorships,
    required this.overdueTasks,
    required this.generatedAt,
  });

  final String programId;
  final String programName;
  final int totalCoordinatorships;
  final TaskTotals tasks;

  /// Sunucu `active_tasks` = `total_tasks − completed_tasks` (başlanmamışlar dahil).
  final int activeTasks;
  final int pendingDateChanges;

  /// Duruma göre görev sayısı. Sözleşme anahtarları tanımlamaz; tanınmayan anahtarların
  /// toplamı [DashboardTaskStatus.unknown] altındadır.
  final Map<DashboardTaskStatus, int> statusDistribution;
  final Map<DashboardTaskPriority, int> priorityDistribution;

  /// `total_admins` şirket geneli sayılır (REPORTING-K02).
  final TeamTotals team;
  final int deletedRecords;

  /// Sunucu sırası: ada göre bayt sırası (Türkçe alfabe değil).
  final List<CoordinatorshipSummary> coordinatorships;
  final List<OverdueTaskSummary> overdueTasks;
  final DateTime generatedAt;
}
