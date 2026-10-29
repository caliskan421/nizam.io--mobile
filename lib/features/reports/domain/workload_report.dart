import 'package:meta/meta.dart';

import 'report_common.dart';

/// İş yükü görev satırı (sunucu `WorkloadTask`).
@immutable
final class WorkloadTask {
  const WorkloadTask({
    required this.workItemId,
    required this.title,
    required this.status,
    required this.priority,
    required this.startOn,
    required this.endOn,
    required this.departmentId,
    required this.departmentName,
    required this.isOverdue,
    required this.daysOverdue,
    required this.attachmentCount,
    required this.hasAttachment,
    this.completedOn,
    this.latestNote,
  });

  final String workItemId;
  final String title;
  final ReportTaskStatus status;
  final ReportPriority priority;
  final DateTime startOn;
  final DateTime endOn;
  final DateTime? completedOn;
  final String departmentId;
  final String departmentName;
  final bool isOverdue;
  final int daysOverdue;
  final int attachmentCount;
  final bool hasAttachment;

  /// Görevin son notu; not yoksa null.
  final String? latestNote;
}

/// Üye başına iş yükü satırı (sunucu `WorkloadMember`).
@immutable
final class WorkloadMember {
  const WorkloadMember({
    required this.accountId,
    required this.fullName,
    required this.coordinatorships,
    required this.tasks,
  });

  final String accountId;
  final String fullName;
  final List<ReportDepartment> coordinatorships;
  final List<WorkloadTask> tasks;
}

/// İş yükü raporu (`GET /v1/reports/workload`): üye başına satır + programın
/// koordinatörlük listesi; departmana göre gruplama yalnız PDF'tedir (REPORTING-K05).
@immutable
final class WorkloadReport {
  const WorkloadReport({
    required this.programId,
    required this.programName,
    required this.members,
    required this.coordinatorships,
    required this.total,
    required this.generatedAt,
  });

  final String programId;
  final String programName;
  final List<WorkloadMember> members;
  final List<ReportDepartment> coordinatorships;

  /// Sunucunun toplam sayısı (sözleşmede anlamı açıklanmamış).
  final int total;
  final DateTime generatedAt;
}
