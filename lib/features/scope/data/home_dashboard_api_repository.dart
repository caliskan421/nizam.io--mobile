import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/collaboration_client.dart';
import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/count_result.dart';
import '../../../core/api/generated/models/date_change_request.dart';
import '../../../core/api/generated/models/date_change_request_list.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/api/generated/models/report_task.dart';
import '../../../core/api/generated/models/report_task_list.dart';
import '../../../core/errors/api_error.dart';
import '../domain/home_dashboard.dart';
import '../domain/home_dashboard_report.dart';
import '../domain/home_dashboard_report_repository.dart';
import '../domain/home_dashboard_repository.dart';
import 'dashboard_report_api_repository.dart';

/// Ana sayfa özetinin sunucu kaynağı (S2; program başlığını ara katman ekler). Özet tek uçtan
/// gelmez, beş uç paralel okunur:
/// - `GET /v1/me` → karşılama adı, e-posta, yönetici rolü;
/// - `GET /v1/reports/dashboard` → görev/ekip sayıları, koordinatörlükler;
/// - `GET /v1/reports/dashboard/tasks` → bekleyen onayların ve tarih taleplerinin görev adları,
///   zamanında ilerleyen görev sayısı;
/// - `GET /v1/date-change-requests?status=pending` → bekleyen tarih talepleri;
/// - `GET /v1/messages/unread-count` → okunmamış mesaj rozeti.
///
/// Pano uçları yalnız şirket yöneticisine açıktır; diğer roller `reporting.not_authorized`
/// alır ve hata olduğu gibi fırlar (istemci rol kuralı türetmez). Uçlardan biri hata verirse
/// özet kurulmaz. İşlem geçmişi ucu sunucuda yok: [HomeDashboard.lastActivity] null.
class ApiHomeDashboardRepository implements HomeDashboardRepository {
  ApiHomeDashboardRepository(Dio dio)
    : _report = ApiDashboardReportRepository(dio),
      _identity = IdentityClient(dio),
      _reporting = ReportingClient(dio),
      _work = WorkClient(dio),
      _messages = CollaborationClient(dio);

  final DashboardReportRepository _report;
  final IdentityClient _identity;
  final ReportingClient _reporting;
  final WorkClient _work;
  final CollaborationClient _messages;

  static const _submitted = 'onaya_sunuldu';
  static const _inProgress = 'devam_ediyor';

  @override
  Future<HomeDashboard> load() async {
    // eagerError: ilk hata fırlar, diğerleri yutulur (işlenmemiş hata kalmaz).
    final r = await Future.wait<Object>([
      apiCall(_identity.me),
      _report.load(),
      apiCall(_reporting.reportDashboardTasks),
      apiCall(() => _work.listDateChangeRequests(status: 'pending')),
      apiCall(_messages.countUnreadMessages),
    ], eagerError: true);
    final me = r[0] as MeResponse;
    final report = r[1] as DashboardReport;
    final taskList = r[2] as HttpResponse<ReportTaskList>;
    final dateChanges = (r[3] as DateChangeRequestList).requests;
    final unread = (r[4] as CountResult).count;

    final tasks = taskList.data.tasks;
    final truncated = _truncated(taskList);
    final byId = {for (final t in tasks) t.workItemId: t};
    final t = report.tasks;
    return HomeDashboard(
      greetingName: me.fullName,
      greetingRole: me.companyAdmin ? TeamRole.admin : null,
      greetingEmail: me.email,
      tasks: TaskTotals(
        total: t.total,
        done: t.done,
        inProgress: t.inProgress,
        // Kesik listede eksik sayılır; o zaman bilinmiyor.
        inProgressOnTime: truncated
            ? null
            : tasks
                  .where((t) => t.status == _inProgress && !t.isOverdue)
                  .length,
        late: t.late,
        awaitingApproval: t.awaitingApproval,
      ),
      team: report.team,
      coordinatorships: report.coordinatorships,
      pending: [
        for (final d in dateChanges)
          if (byId[d.workItemId] case final task?) _dateChange(d, task),
        for (final task in tasks)
          if (task.status == _submitted)
            PendingItem(
              taskCode: task.workItemId,
              label: task.departmentName,
              title: task.title,
              kind: PendingKind.approval,
            ),
      ],
      counts: ModuleCounts(
        lateTasks: t.late,
        tasksAwaitingApproval: t.awaitingApproval,
        unreadMessages: unread,
        pendingRequests: report.pendingDateChanges,
      ),
    );
  }

  /// Bitiş kaydırması gün olarak; bitiş değişmediyse (yalnız başlangıç) yeni bitiş tarihi.
  static PendingItem _dateChange(DateChangeRequest d, ReportTask task) {
    final shift = d.newEndOn.difference(d.oldEndOn).inDays;
    return PendingItem(
      taskCode: task.workItemId,
      label: task.departmentName,
      title: task.title,
      kind: PendingKind.dateChange,
      requestedDate: d.newEndOn,
      requestedShiftDays: shift == 0 ? null : shift,
    );
  }

  static bool _truncated(HttpResponse<Object?> r) {
    final values =
        r.response.headers[ApiDashboardReportRepository.truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }
}
