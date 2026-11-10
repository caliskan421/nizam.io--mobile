import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/messaging_client.dart';
import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/chat_unread_overview.dart';
import '../../../core/api/generated/models/date_change_request.dart';
import '../../../core/api/generated/models/date_change_request_list.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/api/generated/models/report_task.dart';
import '../../../core/api/generated/models/report_task_list.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
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
/// - `GET /v1/me/chat-unread` → okunmamış sohbet rozeti (S1 uç programlar arası liste verir;
///   rozet seçili programın satırıdır, satır yoksa 0).
///
/// [load] yalnız şirket yöneticisi içindir (pano uçları yöneticiye açık); rol seçimi
/// application katmanında (`HomeDashboardController`, `TaskAccess`). Uçlardan biri hata
/// verirse özet kurulmaz. İşlem geçmişi ucu sunucuda yok: [HomeDashboard.lastActivity] null.
///
/// [loadTeamExtras] yönetici olmayan hesap içindir: yalnız okunmamış sayısı ve (koordinatörde)
/// `GET /v1/date-change-requests/mine` (S3, açık departman); rapor uçları çağrılmaz.
class ApiHomeDashboardRepository implements HomeDashboardRepository {
  /// İkinci argüman seçili programın kimliğini verir (okunmamış rozeti o programa iner).
  ApiHomeDashboardRepository(Dio dio, this._programId)
    : _report = ApiDashboardReportRepository(dio),
      _identity = IdentityClient(dio),
      _reporting = ReportingClient(dio),
      _work = WorkClient(dio),
      _messages = MessagingClient(dio);

  final DashboardReportRepository _report;
  final IdentityClient _identity;
  final ReportingClient _reporting;
  final WorkClient _work;
  final MessagingClient _messages;
  final String? Function() _programId;

  static const _submitted = 'onaya_sunuldu';

  @override
  Future<HomeDashboard> load() async {
    final r = await Future.wait<Object>([
      apiCall(_identity.me),
      _report.load(),
    ], eagerError: true);
    final me = r[0] as MeResponse;
    final report = r[1] as DashboardReport;
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
        inProgressOnTime: null,
        late: t.late,
        awaitingApproval: t.awaitingApproval,
      ),
      team: report.team,
      coordinatorships: report.coordinatorships,
      pending: const [],
      counts: ModuleCounts(
        lateTasks: t.late,
        tasksAwaitingApproval: t.awaitingApproval,
        unreadMessages: null,
      ),
    );
  }

  @override
  Future<PendingOverview> loadPending() async {
    final r = await Future.wait<Object>([
      apiCall(_reporting.reportDashboardTasks),
      apiCall(() => _work.listDateChangeRequests(status: 'pending')),
    ], eagerError: true);
    final response = r[0] as HttpResponse<ReportTaskList>;
    final tasks = response.data.tasks;
    final byId = {for (final t in tasks) t.workItemId: t};
    return PendingOverview(
      truncated:
          response.response.headers.value('x-result-truncated') == 'true',
      inProgressOnTime:
          response.response.headers.value('x-result-truncated') == 'true'
          ? null
          : tasks
                .where((t) => t.status == 'devam_ediyor' && !t.isOverdue)
                .length,
      items: [
        for (final d in (r[1] as DateChangeRequestList).requests)
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
    );
  }

  @override
  Future<int> loadUnread() async {
    final program = _programId();
    return _unread(
      await apiCall(_messages.getChatUnreadOverview),
      program: program,
    );
  }

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async {
    final mine = coordinator && departmentId != null;
    final r = await Future.wait<Object>([
      apiCall(_messages.getChatUnreadOverview),
      if (mine)
        apiCall(
          () => _work.myDateChangeRequests(
            extras: withDepartment(
              WorkClient.myDateChangeRequestsOpenapiExtras,
              departmentId,
            ),
          ),
        ),
    ], eagerError: true);
    return TeamDashboardExtras(
      unreadMessages: _unread(r[0] as ChatUnreadOverview),
      pendingDateRequests: [
        if (mine)
          for (final d in (r[1] as DateChangeRequestList).requests)
            if (d.status.json == 'pending')
              PendingDateRequest(
                workItemId: d.workItemId,
                oldEnd: d.oldEndOn,
                newEnd: d.newEndOn,
              ),
      ],
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

  /// Seçili programın okunmamış sohbet sayısı (`unread_chats`; programın satırı yoksa 0).
  int _unread(ChatUnreadOverview o, {String? program}) {
    program ??= _programId();
    return o.items
            .where((p) => p.programId == program)
            .firstOrNull
            ?.unreadChats ??
        0;
  }
}
