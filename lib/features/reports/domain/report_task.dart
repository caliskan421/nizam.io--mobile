import 'package:meta/meta.dart';

import 'report_common.dart';

/// Rapor görev satırı (sunucu `ReportTask`).
@immutable
final class ReportTask {
  const ReportTask({
    required this.workItemId,
    required this.title,
    required this.departmentId,
    required this.departmentName,
    required this.status,
    required this.priority,
    required this.startOn,
    required this.endOn,
    required this.createdBy,
    required this.assignees,
    required this.isOverdue,
    required this.daysOverdue,
    required this.isCompletedLate,
    required this.daysLate,
    required this.isCompletedEarly,
    required this.daysEarly,
    required this.hasPendingDependency,
    required this.dependencyCount,
    required this.noteCount,
    required this.createdAt,
    this.plannedEndOn,
    this.completedOn,
  });

  final String workItemId;
  final String title;
  final String departmentId;
  final String departmentName;
  final ReportTaskStatus status;
  final ReportPriority priority;
  final DateTime startOn;
  final DateTime endOn;
  final DateTime? plannedEndOn;
  final DateTime? completedOn;
  final ReportPerson createdBy;
  final List<ReportPerson> assignees;
  final bool isOverdue;
  final int daysOverdue;
  final bool isCompletedLate;
  final int daysLate;
  final bool isCompletedEarly;
  final int daysEarly;
  final bool hasPendingDependency;
  final int dependencyCount;
  final int noteCount;
  final DateTime createdAt;
}

/// Pano görev listesi (`GET /v1/reports/dashboard/tasks`): sayfasız, en çok 200 satır.
/// [total] sunucunun toplam sayısıdır (kesilmede satır sayısından büyük olabilir);
/// [truncated] `X-Result-Truncated` başlığından.
@immutable
final class ReportTaskList {
  const ReportTaskList({
    required this.tasks,
    required this.total,
    this.truncated = false,
  });

  final List<ReportTask> tasks;
  final int total;
  final bool truncated;
}

/// Bağımlılık satırı (sunucu `ReportTaskRef`).
@immutable
final class ReportTaskRef {
  const ReportTaskRef({
    required this.workItemId,
    required this.title,
    required this.status,
    required this.departmentName,
  });

  final String workItemId;
  final String title;
  final ReportTaskStatus status;
  final String departmentName;
}

/// Görev notu (sunucu `ReportTaskNote`).
@immutable
final class ReportTaskNote {
  const ReportTaskNote({
    required this.content,
    required this.author,
    required this.createdAt,
  });

  final String content;
  final ReportPerson author;
  final DateTime createdAt;
}

/// Görev detay raporu (`GET /v1/reports/tasks/{id}`); [recentNotes] en çok son 20 not
/// (REPORTING-K04).
@immutable
final class ReportTaskDetail {
  const ReportTaskDetail({
    required this.task,
    required this.description,
    required this.dependencies,
    required this.recentNotes,
  });

  final ReportTask task;
  final String description;
  final List<ReportTaskRef> dependencies;
  final List<ReportTaskNote> recentNotes;
}
