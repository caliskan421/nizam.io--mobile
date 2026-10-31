import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';

/// Yönetici OLMAYAN hesabın ana sayfa özeti: zaten yüklenmiş görev kataloğundan (tek
/// departman, `listWorkItems`) istemcide sayılır — ek sunucu toplamı/istek yok (ürün kısıtı).
/// Koordinatör kapsamın tüm görevlerini, üye yalnız kendine atananları görür (sunucu süzer);
/// sayılar bu görünürlüğün sayımıdır. Ekip sayıları bilinmez ([HomeDashboard.team] null →
/// kutu gizli). Bekleyen işler: koordinatörde onaya sunulanlar ve kendi bekleyen tarih
/// talepleri; üyede yok. Gecikme sunucu bayrağıdır ([TaskItem.lateness]).
HomeDashboard teamDashboard(
  TaskCatalog catalog,
  TeamDashboardExtras extras, {
  required bool coordinator,
}) {
  final tasks = catalog.tasks;
  bool late(TaskItem t) => t.lateness?.isOverdue ?? t.isOverdue;
  int count(bool Function(TaskItem t) test) => tasks.where(test).length;

  final done = count((t) => t.status == TaskStatus.done);
  final inProgress = count((t) => t.status == TaskStatus.inProgress);
  final review = count((t) => t.status == TaskStatus.review);
  final lateCount = count(late);
  final byId = {for (final t in tasks) t.id: t};
  final dept = catalog.departmentId;
  final deptName = dept == null ? null : catalog.coordinatorship(dept)?.name;

  return HomeDashboard(
    greetingName: catalog.person(catalog.me)?.name ?? '',
    greetingRole: coordinator ? TeamRole.coordinator : TeamRole.member,
    tasks: TaskTotals(
      total: tasks.length,
      done: done,
      inProgress: inProgress,
      // Kesik listede eksik sayılır; o zaman bilinmiyor.
      inProgressOnTime: catalog.truncated
          ? null
          : count((t) => t.status == TaskStatus.inProgress && !late(t)),
      late: lateCount,
      awaitingApproval: review,
    ),
    coordinatorships: [
      if (dept != null && deptName != null)
        CoordinatorshipSummary(
          code: dept,
          name: deptName,
          leads: const [],
          todo: count((t) => t.status == TaskStatus.todo),
          inProgress: inProgress,
          inReview: count(
            (t) =>
                t.status == TaskStatus.review ||
                t.status == TaskStatus.returned,
          ),
          done: done,
          late: lateCount,
        ),
    ],
    pending: [
      if (coordinator) ...[
        for (final d in extras.pendingDateRequests)
          if (byId[d.workItemId] case final t?)
            PendingItem(
              taskCode: t.code,
              label: deptName,
              title: t.title,
              kind: PendingKind.dateChange,
              requestedDate: d.newEnd,
              requestedShiftDays: switch (d.newEnd
                  .difference(d.oldEnd)
                  .inDays) {
                0 => null,
                final n => n,
              },
            ),
        for (final t in tasks)
          if (t.status == TaskStatus.review)
            PendingItem(
              taskCode: t.code,
              label: deptName,
              title: t.title,
              kind: PendingKind.approval,
            ),
      ],
    ],
    counts: ModuleCounts(
      lateTasks: lateCount,
      tasksAwaitingApproval: coordinator ? review : 0,
      unreadMessages: extras.unreadMessages,
      pendingRequests: extras.pendingDateRequests.length,
    ),
  );
}
