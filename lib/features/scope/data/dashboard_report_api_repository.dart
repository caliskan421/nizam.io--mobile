import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/models/coordinatorship_stat.dart';
import '../../../core/api/generated/models/dashboard_report.dart' as api;
import '../../../core/api/generated/models/overdue_task.dart';
import '../../../core/api/generated/models/report_person.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/home_dashboard.dart';
import '../domain/home_dashboard_report.dart';
import '../domain/home_dashboard_report_repository.dart';

/// reporting panosu uçlarına üretilmiş istemciyle erişim. DTO'lar bu katmanda kalır;
/// dışarıya domain varlıkları döner (A1). Bütün hatalar [ApiError] olarak fırlar.
class ApiDashboardReportRepository implements DashboardReportRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (program kapsam başlığını ara katman ekler).
  ApiDashboardReportRepository(Dio dio) : _client = ReportingClient(dio);

  /// Sözleşmedeki kesilme başlığı; yalnız kesildiğinde ve yalnız `true` ile gönderilir.
  static const truncationHeader = 'X-Result-Truncated';

  final ReportingClient _client;

  @override
  Future<DashboardReport> load() async =>
      _report(await apiCall(_client.reportDashboard));

  @override
  Future<PageSlice<CoordinatorshipSummary>> coordinatorships() async {
    final r = await apiCall(_client.reportDashboardCoordinatorships);
    return PageSlice(
      items: r.data.coordinatorships.map(_coordinatorship).toList(),
      truncated: _truncated(r),
    );
  }

  static bool _truncated(HttpResponse<Object?> r) {
    final values = r.response.headers[truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }

  static DashboardTaskStatus _status(String wire) => switch (wire) {
    'baslanmadi' => DashboardTaskStatus.notStarted,
    'devam_ediyor' => DashboardTaskStatus.inProgress,
    'onaya_sunuldu' => DashboardTaskStatus.submitted,
    'iade_edildi' => DashboardTaskStatus.returned,
    'tamamlandi' => DashboardTaskStatus.completed,
    _ => DashboardTaskStatus.unknown,
  };

  static DashboardTaskPriority _priority(String wire) => switch (wire) {
    'dusuk' => DashboardTaskPriority.low,
    'orta' => DashboardTaskPriority.medium,
    'yuksek' => DashboardTaskPriority.high,
    'acil' => DashboardTaskPriority.urgent,
    _ => DashboardTaskPriority.unknown,
  };

  static CoordinatorshipKind _kind(String wire) => switch (wire) {
    'koordinatorluk' => CoordinatorshipKind.coordinatorship,
    'calisma_grubu' => CoordinatorshipKind.workingGroup,
    _ => CoordinatorshipKind.unknown,
  };

  /// Sözleşmenin tanımlamadığı anahtarlar `unknown` üyesi altında toplanır.
  static Map<E, int> _distribution<E extends Enum>(
    Iterable<MapEntry<String, int>> wire,
    E Function(String) parse,
  ) {
    final out = <E, int>{};
    for (final MapEntry(:key, :value) in wire) {
      final k = parse(key);
      out[k] = (out[k] ?? 0) + value;
    }
    return Map.unmodifiable(out);
  }

  static DashboardReport _report(api.DashboardReport r) {
    final statuses = _distribution(r.taskStatusDistribution.entries, _status);
    return DashboardReport(
      programId: r.programId,
      programName: r.programName,
      totalCoordinatorships: r.totalCoordinatorships,
      tasks: TaskTotals(
        total: r.totalTasks,
        done: r.completedTasks,
        inProgress: statuses[DashboardTaskStatus.inProgress] ?? 0,
        late: r.overdueTasks,
        awaitingApproval: r.pendingApprovals,
      ),
      activeTasks: r.activeTasks,
      pendingDateChanges: r.pendingDateChanges,
      statusDistribution: statuses,
      priorityDistribution: _distribution(
        r.priorityDistribution.entries,
        _priority,
      ),
      team: TeamTotals(
        admins: r.totalAdmins,
        coordinators: r.totalCoordinators,
        members: r.totalMembers,
        userCount: r.totalUsers,
      ),
      deletedRecords: r.deletedRecords,
      coordinatorships: r.coordinatorshipStats.map(_coordinatorship).toList(),
      overdueTasks: r.overdueTasksList.map(_overdue).toList(),
      generatedAt: r.generatedAt,
    );
  }

  /// `CoordinatorshipStat` → [CoordinatorshipSummary]. [CoordinatorshipSummary.inReview]
  /// sunucuda ayrı alan değildir: kalan sayıdır (negatif çıkmaz).
  static CoordinatorshipSummary _coordinatorship(CoordinatorshipStat s) {
    final rest =
        s.totalTasks - s.completedTasks - s.inProgressTasks - s.notStartedTasks;
    return CoordinatorshipSummary(
      code: s.departmentId,
      name: s.name,
      leads: [for (final p in s.coordinators) p.fullName],
      leadAccountIds: [for (final p in s.coordinators) p.accountId],
      todo: s.notStartedTasks,
      inProgress: s.inProgressTasks,
      inReview: rest < 0 ? 0 : rest,
      done: s.completedTasks,
      late: s.overdueTasks,
      kind: _kind(s.kind),
      serverTotal: s.totalTasks,
      completionRate: s.completionRate,
      memberCount: s.memberCount,
      meetingCount: s.meetingCount,
      lastActivityAt: s.lastActivityAt == null
          ? null
          : DateTime.tryParse(s.lastActivityAt!),
      description: s.description,
    );
  }

  static OverdueTaskSummary _overdue(OverdueTask t) => OverdueTaskSummary(
    workItemId: t.workItemId,
    title: t.title,
    departmentId: t.departmentId,
    departmentName: t.departmentName,
    assignees: t.assignees.map(_person).toList(),
    dueOn: t.dueOn,
    daysOverdue: t.daysOverdue,
  );

  static DashboardPerson _person(ReportPerson p) =>
      DashboardPerson(accountId: p.accountId, fullName: p.fullName);
}
