import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/api/generated/models/my_department.dart' as api;
import '../../../core/api/generated/models/my_department_list.dart';
import '../../../core/api/generated/models/work_item.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import 'work_item_mapping.dart';

/// Görev kataloğunun sunucu kaynağı (seçili program). Herkes için aynı liste ucu:
/// `GET /v1/work-items` (S3, `listWorkItems`) departman başına, imleçle (`next_cursor`).
/// Görünürlük sunucudadır: koordinatör ve şirket yöneticisi departmanın tümünü, üye yalnız
/// kendine atananları alır.
///
/// Departman bağlamı TEKTİR (istemci akışları §2; departmanlar arası tarama yok). Seçilebilir
/// departmanlar ([TaskCatalog.departments]): şirket yöneticisinde `listProgramDepartments`
/// (`GET /v1/program/departments`, S2; `X-Result-Truncated` → [TaskCatalog.departmentsTruncated]),
/// diğerlerinde `GET /v1/me/departments`'ın bu programdaki satırları. Liste departmanı: kapsamda
/// seçili ([departmentId]; değiştirme `ScopeController.selectDepartment`) seçilebilirler
/// arasındaysa o, değilse ilk seçilebilir (eskimiş seçim [correctDepartment] ile düzeltilir).
/// Departman yoksa liste isteği gönderilmez ([TaskCatalog.departmentRequired]). Görünen kısa
/// anahtar departman kodu, kod yoksa programdaki ad ([TaskDepartment.label]).
///
/// Rol `/v1/me` + `/v1/me/departments`'tan [TaskAccess]'te türetilir ve katalogla taşınır.
/// Yönetici rapor/kullanıcı uçları ve `adminGantt` kullanılmaz. Liste dosya sayısı, not sayısı
/// ve açıklama taşımaz; atanan adları `assignees[].full_name`'den [TaskCatalog.names]'e girer.
class ApiTaskCatalogRepository implements TaskCatalogRepository {
  ApiTaskCatalogRepository(
    Dio dio, {
    required this.programId,
    String? Function()? departmentId,
    void Function(String departmentId)? correctDepartment,
    DateTime Function()? now,
  }) : _identity = IdentityClient(dio),
       _work = WorkClient(dio),
       _organization = OrganizationClient(dio),
       _program = ProgramClient(dio),
       departmentId = departmentId ?? _none,
       correctDepartment = correctDepartment ?? _ignore,
       _now = now ?? DateTime.now;

  static String? _none() => null;
  static void _ignore(String _) {}

  /// Kesilme başlığı (`listProgramDepartments`, openapi `ResultTruncated`).
  static const truncationHeader = 'X-Result-Truncated';

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;

  /// Kapsamda seçili departman (yoksa null; istek anında okunur).
  final String? Function() departmentId;

  /// Kapsamdaki kalıcı departman seçimi seçilebilirler arasında yoksa liste ilk seçilebilire
  /// düşer ve seçim bununla düzeltilir (`ScopeController.selectDepartment`).
  final void Function(String departmentId) correctDepartment;
  final IdentityClient _identity;
  final WorkClient _work;
  final OrganizationClient _organization;
  final ProgramClient _program;
  final DateTime Function() _now;

  /// Liste sayfa boyu (sunucu tavanı) ve departman başına en çok sayfa (döngü koruması).
  static const pageSize = 200;
  static const maxPages = 20;

  @override
  Future<TaskCatalog> load() async {
    final program = programId() ?? '';
    // eagerError: ilk hata fırlar, diğerleri yutulur (işlenmemiş hata kalmaz).
    final r = await Future.wait<Object>([
      apiCall(_identity.me),
      apiCall(_organization.myDepartments),
    ], eagerError: true);
    final me = r[0] as MeResponse;
    final rows = (r[1] as HttpResponse<MyDepartmentList>).data.departments;
    final access = TaskAccess(
      accountId: me.accountId,
      companyAdmin: me.companyAdmin,
      seats: [for (final d in rows ?? const <api.MyDepartment>[]) _seat(d)],
    );

    final (departments, departmentsTruncated) = access.companyAdmin
        ? await _programDepartments()
        : (
            [
              for (final s in access.seatsIn(program))
                TaskDepartment(id: s.departmentId, name: s.departmentName),
            ],
            false,
          );
    final department = _department(departments, departmentsTruncated);
    final (items, truncated) = department == null
        ? (const <WorkItem>[], false)
        : await _items(department.id);
    final tasks = [for (final w in items) _task(w, department!.label)];

    final today = _now();
    return TaskCatalog(
      today: DateTime(today.year, today.month, today.day),
      me: access.accountId,
      access: access,
      departmentId: department?.id,
      truncated: truncated,
      departments: departments,
      departmentsTruncated: departmentsTruncated,
      names: [
        for (final w in items)
          for (final a in w.assignees)
            if (a.fullName case final name?) PersonName(a.accountId, name),
      ],
      tasks: tasks,
      people: [
        Person(
          id: access.accountId,
          name: me.fullName,
          role: access.personRoleIn(program),
        ),
      ],
      coordinatorships: [
        if (department != null)
          CoordinatorshipRef(
            code: department.id,
            name: department.name,
            leads: const [],
            members: const [],
          ),
      ],
    );
  }

  /// Şirket yöneticisinin seçilebilir departmanları (programa bağlı canlı departmanlar, ada
  /// göre sıralı) ve kesilme bayrağı.
  Future<(List<TaskDepartment>, bool)> _programDepartments() async {
    final r = await apiCall(_program.listProgramDepartments);
    final values = r.response.headers[truncationHeader];
    return (
      [
        for (final d in r.data.departments)
          TaskDepartment(id: d.departmentId, name: d.displayName, code: d.code),
      ],
      values != null && values.length == 1 && values[0] == 'true',
    );
  }

  /// Listenin TEK departmanı: kapsamda seçili departman seçilebilirler arasındaysa o; değilse
  /// ilk seçilebilir ve eskimiş seçim [correctDepartment] ile düzeltilir. Kesik listede
  /// (yönetici) listede görünmeyen seçim korunur (ilk 200'ün dışında olabilir; ad = kimlik).
  /// Seçilebilir yoksa null → "departman seç" (istek gönderilmez).
  TaskDepartment? _department(List<TaskDepartment> options, bool truncated) {
    final first = options.firstOrNull;
    final selected = departmentId();
    if (selected != null && selected.isNotEmpty) {
      final match = options.where((d) => d.id == selected).firstOrNull;
      if (match != null) return match;
      if (truncated) return TaskDepartment(id: selected, name: selected);
      if (first != null) correctDepartment(first.id);
    }
    return first;
  }

  /// Departmanın sayfaları (tek akış, imleçle); [maxPages] dolduğunda imleç hâlâ varsa
  /// ikinci değer `true` (liste kesildi — sessiz kesilme yok).
  Future<(List<WorkItem>, bool)> _items(String department) async {
    final all = <WorkItem>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      final r = await apiCall(
        () => _work.listWorkItems(
          limit: pageSize,
          cursor: cursor,
          extras: withDepartment(
            WorkClient.listWorkItemsOpenapiExtras,
            department,
          ),
        ),
      );
      all.addAll(r.items);
      cursor = r.nextCursor;
      if (cursor == null || cursor.isEmpty) return (all, false);
    }
    return (all, true);
  }

  static TeamSeat _seat(api.MyDepartment d) => TeamSeat(
    programId: d.programId,
    departmentId: d.departmentId,
    departmentName: d.displayName,
    role: switch (d.role) {
      'koordinator' => SeatRole.coordinator,
      'uye' => SeatRole.member,
      _ => SeatRole.unknown,
    },
  );

  /// `WorkItem` → [TaskItem]; tarihler `start_on`/`end_on`, gecikme sunucu değerleri.
  static TaskItem _task(WorkItem w, String shortCode) {
    final lateness = TaskLateness(
      isOverdue: w.isOverdue,
      daysOverdue: w.daysOverdue,
      isCompletedLate: w.isCompletedLate,
      daysLate: w.daysLate,
      isCompletedEarly: w.isCompletedEarly,
      daysEarly: w.daysEarly,
    );
    return TaskItem(
      code: w.workItemId,
      id: w.workItemId,
      shortCode: shortCode,
      title: w.title,
      coordinatorship: w.departmentId,
      departmentId: w.departmentId,
      programId: w.programId,
      status: taskStatusFromWire(w.status.json),
      priority: taskPriorityFromWire(w.priority.json),
      start: day(w.startOn),
      due: day(w.endOn),
      plannedEnd: w.plannedEndOn,
      completedAt: w.completedOn,
      assignees: List.unmodifiable(w.assigneeAccountIds),
      lateness: lateness,
      overdueDays: lateness.daysOverdue,
      evidenceRequired: w.completionEvidenceRequired,
      subtaskCounts: (total: w.subtaskCounts.total, done: w.subtaskCounts.done),
    );
  }
}
