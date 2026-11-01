import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';

/// Yönetici OLMAYAN hesabın ana sayfa özeti: zaten yüklenmiş görev kataloğundan (program
/// bağlamı, `listProgramWorkItems`; liste süzgeci varsa o departman) istemcide sayılır — ek
/// sunucu toplamı/istek yok (ürün kısıtı). Koordinatör koordinatörü olduğu departmanların tüm
/// görevlerini, üye yalnız kendine atananları görür (sunucu süzer); toplamlar bu görünürlüğün
/// sayımıdır. Koordinatörlük kutusu [departmentId] departmanının görevlerinden sayılır. Ekip sayıları bilinmez ([HomeDashboard.team] null →
/// kutu gizli). Bekleyen işler: koordinatörde onaya sunulanlar ve kendi bekleyen tarih
/// talepleri; üyede yok. Gecikme sunucu bayrağıdır ([TaskItem.lateness]). Onay bekleyen sayısı
/// tek kaynaktır (görünen `review` görevleri) — KPI ve kısayol rozeti aynı sayıyı gösterir.
/// Kesik katalogda ([TaskCatalog.truncated]) özet uyarı bayrağını taşır.
HomeDashboard teamDashboard(
  TaskCatalog catalog,
  TeamDashboardExtras extras, {
  required bool coordinator,
  required String? departmentId,
}) {
  final tasks = catalog.tasks;
  bool late(TaskItem t) => t.lateness?.isOverdue ?? t.isOverdue;
  int count(bool Function(TaskItem t) test) => tasks.where(test).length;

  final done = count((t) => t.status == TaskStatus.done);
  final inProgress = count((t) => t.status == TaskStatus.inProgress);
  final review = count((t) => t.status == TaskStatus.review);
  final lateCount = count(late);
  final byId = {for (final t in tasks) t.id: t};
  final dept = departmentId;
  final deptName = dept == null ? null : catalog.coordinatorship(dept)?.name;
  final deptTasks = [
    for (final t in tasks)
      if (t.departmentId == dept) t,
  ];
  int countIn(bool Function(TaskItem t) test) => deptTasks.where(test).length;
  String? nameOf(TaskItem t) =>
      catalog.coordinatorship(t.coordinatorship)?.name;

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
          todo: countIn((t) => t.status == TaskStatus.todo),
          inProgress: countIn((t) => t.status == TaskStatus.inProgress),
          inReview: countIn(
            (t) =>
                t.status == TaskStatus.review ||
                t.status == TaskStatus.returned,
          ),
          done: countIn((t) => t.status == TaskStatus.done),
          late: countIn(late),
        ),
    ],
    pending: [
      if (coordinator) ...[
        for (final d in extras.pendingDateRequests)
          if (byId[d.workItemId] case final t?)
            PendingItem(
              taskCode: t.code,
              label: nameOf(t),
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
              label: nameOf(t),
              title: t.title,
              kind: PendingKind.approval,
            ),
      ],
    ],
    truncated: catalog.truncated,
    counts: ModuleCounts(
      lateTasks: lateCount,
      tasksAwaitingApproval: review,
      unreadMessages: extras.unreadMessages,
      pendingRequests: extras.pendingDateRequests.length,
    ),
  );
}
