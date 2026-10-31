import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/coordinatorship_stat_list.dart';
import '../../../core/api/generated/models/department_list.dart';
import '../../../core/api/generated/models/gantt.dart';
import '../../../core/api/generated/models/gantt_task.dart';
import '../../../core/api/generated/models/known_user.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/api/generated/models/report_task.dart';
import '../../../core/api/generated/models/report_task_list.dart';
import '../../../core/errors/api_error.dart';
import '../domain/task_catalog.dart';
import 'work_item_mapping.dart';

/// Görev kataloğunun sunucu kaynağı (seçili program, S2). Katalog tek uçtan gelmez; uçlar
/// paralel okunur:
/// - `GET /v1/me` → oturumdaki kişi ve yönetici bayrağı;
/// - `GET /v1/work-items/gantt/admin` → programın bütün görevleri (tarihli yüz);
/// - `GET /v1/reports/dashboard/tasks` → not sayısı, oluşturan ve oluşturma anı (en çok 200
///   satır; listede olmayan görevde bu alanlar boş kalır);
/// - `GET /v1/reports/dashboard/coordinatorships` → programın koordinatörlükleri (sıra, ad);
/// - `GET /v1/departments` → departmanların kısa kodu (`ALT`; görünen görev anahtarı);
/// - `GET /v1/admin/users` (imleçli) → kişiler ve `program:departman:rol` üyelikleri (seçili
///   programınkiler; program kimliği kapsamdan, [programId]).
///
/// Bu uçlar şirket yöneticisine açıktır; diğer roller sunucunun yetki hatasını alır
/// (istemci rol kuralı türetmez). Yönetici bayrağı yalnız oturumdaki kişi için bilinir
/// (kullanıcı listesi taşımaz); diğer kişiler üyeliğe göre koordinatör/üye görünür. Görev kodu sunucu kimliğidir (`work_item_id`; insan okunur
/// anahtar yok — backend adayı B-03); ekranda departman kodu gösterilir. Liste yüzleri dosya
/// sayısı, alt görev, açıklama ve kanıt bayrağı taşımaz: bunlar ayrıntıda yüklenir.
class ApiTaskCatalogRepository implements TaskCatalogRepository {
  ApiTaskCatalogRepository(
    Dio dio, {
    required this.programId,
    DateTime Function()? now,
  }) : _identity = IdentityClient(dio),
       _work = WorkClient(dio),
       _reporting = ReportingClient(dio),
       _organization = OrganizationClient(dio),
       _now = now ?? DateTime.now;

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;
  final IdentityClient _identity;
  final WorkClient _work;
  final ReportingClient _reporting;
  final OrganizationClient _organization;
  final DateTime Function() _now;

  /// Kullanıcı listesinin sayfa boyu ve en çok okunacak sayfa (döngü koruması).
  static const _userPage = 200;
  static const _maxUserPages = 20;

  static const _coordinatorRole = 'koordinator';
  static const _memberRole = 'uye';

  @override
  Future<TaskCatalog> load() async {
    // eagerError: ilk hata fırlar, diğerleri yutulur (işlenmemiş hata kalmaz).
    final program = programId();
    final r = await Future.wait<Object>([
      apiCall(_identity.me),
      apiCall(_work.adminGantt),
      apiCall(_reporting.reportDashboardTasks),
      apiCall(_reporting.reportDashboardCoordinatorships),
      apiCall(_organization.listDepartments),
      _users(),
    ], eagerError: true);
    final me = r[0] as MeResponse;
    final gantt = r[1] as Gantt;
    final reportTasks = (r[2] as HttpResponse<ReportTaskList>).data.tasks;
    final stats = (r[3] as HttpResponse<CoordinatorshipStatList>).data;
    final departments = (r[4] as HttpResponse<DepartmentList>).data;
    final users = r[5] as List<KnownUser>;

    final shortCodes = {
      for (final d in departments.departments)
        if (d.code case final code? when code.isNotEmpty) d.departmentId: code,
    };
    final reported = {for (final t in reportTasks) t.workItemId: t};

    // (departman, rol) → kişiler (yalnız bu programın üyelikleri).
    final roles = <(String, String), List<String>>{};
    final coordinatorAnywhere = <String>{};
    for (final u in users) {
      for (final tag in u.memberships ?? const <String>[]) {
        final parts = tag.split(':');
        if (parts.length != 3 || parts[0] != program) continue;
        final [_, department, role] = parts;
        (roles[(department, role)] ??= []).add(u.accountId);
        if (role == _coordinatorRole) coordinatorAnywhere.add(u.accountId);
      }
    }

    final today = _now();
    return TaskCatalog(
      today: DateTime(today.year, today.month, today.day),
      me: me.accountId,
      tasks: [
        for (final t in gantt.tasks)
          _task(t, reported[t.workItemId], shortCodes[t.departmentId]),
      ],
      people: [
        for (final u in users)
          Person(
            id: u.accountId,
            name: u.fullName,
            role: u.accountId == me.accountId && me.companyAdmin
                ? PersonRole.admin
                : coordinatorAnywhere.contains(u.accountId)
                ? PersonRole.coordinator
                : PersonRole.member,
          ),
      ],
      coordinatorships: [
        for (final c in stats.coordinatorships)
          CoordinatorshipRef(
            code: c.departmentId,
            name: c.name,
            leads: [
              for (final p in c.coordinators) p.accountId,
              for (final id
                  in roles[(c.departmentId, _coordinatorRole)] ??
                      const <String>[])
                if (!c.coordinators.any((p) => p.accountId == id)) id,
            ],
            members: roles[(c.departmentId, _memberRole)] ?? const [],
          ),
      ],
    );
  }

  /// Bütün kullanıcı sayfaları (imleç bitene ya da sayfa sınırına kadar).
  Future<List<KnownUser>> _users() async {
    final all = <KnownUser>[];
    String? cursor;
    for (var page = 0; page < _maxUserPages; page++) {
      final r = await apiCall(
        () => _organization.listUsers(limit: _userPage, cursor: cursor),
      );
      all.addAll(r.data.users ?? const []);
      cursor = r.data.nextCursor;
      if (cursor == null || cursor.isEmpty) break;
    }
    return all;
  }

  static TaskItem _task(GanttTask t, ReportTask? report, String? shortCode) {
    final lateness = TaskLateness(
      isOverdue: t.lateness.isOverdue,
      daysOverdue: t.lateness.daysOverdue,
      isCompletedLate: t.lateness.isCompletedLate,
      daysLate: t.lateness.daysLate,
      isCompletedEarly: t.lateness.isCompletedEarly,
      daysEarly: t.lateness.daysEarly,
    );
    return TaskItem(
      code: t.workItemId,
      id: t.workItemId,
      shortCode: shortCode,
      title: t.title,
      coordinatorship: t.departmentId,
      departmentId: t.departmentId,
      programId: t.programId,
      status: taskStatusFromWire(t.status),
      priority: taskPriorityFromWire(t.priority.json),
      start: DateTime.parse(t.startOn),
      due: DateTime.parse(t.endOn),
      plannedEnd: _optionalDay(t.plannedEndOn),
      completedAt: _optionalDay(t.completedOn),
      assignees: List.unmodifiable(t.assigneeAccountIds),
      creator: report?.createdBy.accountId,
      createdAt: report?.createdAt,
      lateness: lateness,
      notes: report?.noteCount ?? 0,
      overdueDays: lateness.daysOverdue,
    );
  }

  /// Gantt gün alanları dizgedir (`format: date` yok — backend adayı B-20); boş → yok.
  static DateTime? _optionalDay(String s) =>
      s.isEmpty ? null : DateTime.parse(s);
}
