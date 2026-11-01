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
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import 'work_item_mapping.dart';

/// Görev kataloğunun sunucu kaynağı (seçili program). Herkes için aynı liste ucu:
/// `GET /v1/program/work-items` (S2, `listProgramWorkItems`) — yalnız `X-Nizamio-Program`,
/// departman başlığı GÖNDERİLMEZ (istemci akışları §2, `v0.7.0-api`). Görünürlük sunucudadır:
/// şirket yöneticisi programın tümünü, koordinatör koordinatörü olduğu departmanların tümünü,
/// üye yalnız kendisine atananları alır; birden çok rolde birleşim (aynı görev bir kez).
/// Departmanlar arası tarama (fan-out) yoktur: program görünümü tek akışın sayfalamasıdır
/// (imleç `next_cursor`, sayfa başına [pageSize]; imleç tekrarında durulur).
///
/// [load] paylaşılan kataloğu HER ZAMAN süzgeçsiz okur (ana sayfa, zaman çizelgesi, sayımlar).
/// Görevler ekranının departman süzgeci ayrı okumadır ([loadTasks]): `department_id` sorgu
/// parametresi (görünürlükle kesişir, yetki genişlemez); telefonda süzme yapılmaz. Süzgeç
/// seçenekleri ([TaskCatalog.departments]): şirket yöneticisinde `listProgramDepartments`
/// (`GET /v1/program/departments`, S2; `X-Result-Truncated` → [TaskCatalog.departmentsTruncated]),
/// koordinatör/üyede `GET /v1/me/departments`'ın bu programdaki satırları. Görünen kısa anahtar
/// departman kodu, kod yoksa programdaki ad ([TaskDepartment.label]). Program okuma sırasında
/// değişirse sayfa döngüsü durur (`client.scope_changed`).
///
/// Rol `/v1/me` + `/v1/me/departments`'tan [TaskAccess]'te türetilir ve katalogla taşınır.
/// Yönetici rapor/kullanıcı uçları ve `adminGantt` kullanılmaz. Liste dosya sayısı, not sayısı
/// ve açıklama taşımaz; atanan adları `assignees[].full_name`'den [TaskCatalog.names]'e girer.
/// Tek göreve ait istekler satırın kendi `program_id` + `department_id` değeriyle (`withScope`)
/// gider; bu sınıf yalnız listeyi okur.
class ApiTaskCatalogRepository
    implements TaskCatalogRepository, TaskListRepository {
  ApiTaskCatalogRepository(
    Dio dio, {
    required this.programId,
    DateTime Function()? now,
  }) : _identity = IdentityClient(dio),
       _work = WorkClient(dio),
       _organization = OrganizationClient(dio),
       _program = ProgramClient(dio),
       _now = now ?? DateTime.now;

  /// Kesilme başlığı (`listProgramDepartments`, openapi `ResultTruncated`).
  static const truncationHeader = 'X-Result-Truncated';

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;
  final IdentityClient _identity;
  final WorkClient _work;
  final OrganizationClient _organization;
  final ProgramClient _program;
  final DateTime Function() _now;

  /// Liste sayfa boyu (sunucu tavanı) ve en çok sayfa (imleç tekrarına ek döngü tavanı).
  static const pageSize = 200;
  static const maxPages = 100;

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

    final (items, truncated) = await _items(program, null);

    final labels = {for (final d in departments) d.id: d.label};
    final tasks = [
      for (final w in items) _task(w, labels[w.departmentId] ?? w.departmentId),
    ];

    final today = _now();
    return TaskCatalog(
      today: DateTime(today.year, today.month, today.day),
      me: access.accountId,
      access: access,
      truncated: truncated,
      departments: departments,
      departmentsTruncated: departmentsTruncated,
      names: _names(items),
      tasks: tasks,
      people: [
        Person(
          id: access.accountId,
          name: me.fullName,
          role: access.personRoleIn(program),
        ),
      ],
      coordinatorships: [
        for (final d in departments)
          CoordinatorshipRef(
            code: d.id,
            name: d.name,
            leads: const [],
            members: const [],
          ),
      ],
    );
  }

  /// Görevler ekranının departman süzgeci: yalnız görev sayfaları (`department_id` her
  /// sayfada; departman başlığı yok). Kimlik/ekip/departman seçenekleri yeniden okunmaz;
  /// geçersiz süzgeç (404 `work.program_scope_invalid`) dahil hata fırlar (süzgeci çağıran
  /// temizler). Kısa anahtar [departments]'tan (katalogdaki departman etiketi), yoksa kimlik.
  @override
  Future<TaskListPage> loadTasks(
    String departmentId, {
    bool Function()? isCurrent,
    List<TaskDepartment> departments = const [],
  }) async {
    final program = programId() ?? '';
    final (items, truncated) = await _items(
      program,
      departmentId,
      isCurrent: isCurrent,
    );
    final labels = {for (final d in departments) d.id: d.label};
    return TaskListPage(
      tasks: [
        for (final w in items)
          _task(w, labels[w.departmentId] ?? w.departmentId),
      ],
      names: _names(items),
      truncated: truncated,
    );
  }

  static List<PersonName> _names(List<WorkItem> items) => [
    for (final w in items)
      for (final a in w.assignees)
        if (a.fullName case final name?) PersonName(a.accountId, name),
  ];

  /// Şirket yöneticisinin süzgeç seçenekleri (programa bağlı canlı departmanlar, ada göre
  /// sıralı) ve kesilme bayrağı.
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

  /// Programın görünür görevleri: tek akış, imleçle bütün sayfalar. Program her sayfada
  /// açıkça sabitlenir ([withProgram]); departman başlığı yok (S2). İmleç tekrar ederse ya da [maxPages] dolarsa durulur ve
  /// ikinci değer `true` (liste kesildi — sessiz kesilme yok).
  Future<(List<WorkItem>, bool)> _items(
    String program,
    String? department, {
    bool Function()? isCurrent,
  }) async {
    final all = <WorkItem>[];
    final seen = <String>{};
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      // Sayfa aralarında: okuma eskidiyse (süzgeç/program değişti) döngü durur.
      if (page > 0 &&
          (programId() != program || !(isCurrent?.call() ?? true))) {
        throw ApiError(ClientErrorCode.scopeChanged);
      }
      final r = await apiCall(
        () => _work.listProgramWorkItems(
          departmentId: department,
          limit: pageSize,
          cursor: cursor,
          extras: withProgram(
            WorkClient.listProgramWorkItemsOpenapiExtras,
            program,
          ),
        ),
      );
      all.addAll(r.items);
      cursor = r.nextCursor;
      if (cursor == null || cursor.isEmpty) return (all, false);
      if (!seen.add(cursor)) return (all, true);
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
