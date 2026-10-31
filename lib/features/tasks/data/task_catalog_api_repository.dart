import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/organization_client.dart';
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
/// Departman bağlamı (istemci akışları, F56 M-5):
/// - kapsamda departman seçiliyse ([departmentId]) yalnız o departman;
/// - değilse hesabın bu programdaki ekip satırları (`GET /v1/me/departments`);
/// - şirket yöneticisinde ek olarak şirketin departmanları (`GET /v1/departments`, yönetim
///   yüzü); programa bağlı olmayan departman `work.program_scope_invalid` (404) döner ve
///   atlanır (programın departman listesini veren okuma ucu yok — P1b/backend adayı).
///
/// Rol `/v1/me` + `/v1/me/departments`'tan [TaskAccess]'te türetilir ve katalogla taşınır
/// (ayrıntı ekranı tarih talebi yüzünü buradan seçer). Yönetici rapor/kullanıcı uçları ve
/// `adminGantt` kullanılmaz. Liste dosya sayısı, not sayısı, açıklama ve adlar taşımaz.
class ApiTaskCatalogRepository implements TaskCatalogRepository {
  ApiTaskCatalogRepository(
    Dio dio, {
    required this.programId,
    String? Function()? departmentId,
    DateTime Function()? now,
  }) : _identity = IdentityClient(dio),
       _work = WorkClient(dio),
       _organization = OrganizationClient(dio),
       departmentId = departmentId ?? _none,
       _now = now ?? DateTime.now;

  static String? _none() => null;

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;

  /// Kapsamda seçili departman (yoksa null; istek anında okunur).
  final String? Function() departmentId;
  final IdentityClient _identity;
  final WorkClient _work;
  final OrganizationClient _organization;
  final DateTime Function() _now;

  /// Liste sayfa boyu (sunucu tavanı) ve departman başına en çok sayfa (döngü koruması).
  static const pageSize = 200;
  static const maxPages = 20;

  /// Programa bağlı olmayan departmanın liste hatası (yöneticinin şirket listesinde atlanır).
  static const _notInProgram = 'work.program_scope_invalid';

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

    final today = _now();
    final day = DateTime(today.year, today.month, today.day);
    final departments = await _departments(access, program);
    final tasks = <TaskItem>[];
    for (final d in departments) {
      final items = await _items(d.id, optional: d.optional);
      if (items == null) continue;
      tasks.addAll(items.map((w) => _task(w, d.shortCode, day)));
    }

    return TaskCatalog(
      today: day,
      me: access.accountId,
      access: access,
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
          if (!d.optional || tasks.any((t) => t.departmentId == d.id))
            CoordinatorshipRef(
              code: d.id,
              name: d.name,
              leads: const [],
              members: const [],
            ),
      ],
    );
  }

  /// Listesi okunacak departmanlar (sıra: seçili ya da ekip satırları, sonra yönetici ekleri).
  Future<List<_Department>> _departments(
    TaskAccess access,
    String program,
  ) async {
    final seats = access.seatsIn(program);
    final selected = departmentId();
    if (selected != null && selected.isNotEmpty) {
      final seat = seats.where((s) => s.departmentId == selected).firstOrNull;
      return [
        _Department(
          selected,
          seat?.departmentName ?? selected,
          optional: false,
        ),
      ];
    }
    final out = [
      for (final s in seats)
        _Department(s.departmentId, s.departmentName, optional: false),
    ];
    if (!access.companyAdmin) return out;
    final known = {for (final d in out) d.id};
    final all = await apiCall(_organization.listDepartments);
    final codes = {
      for (final d in all.data.departments)
        if (d.code case final c? when c.isNotEmpty) d.departmentId: c,
    };
    return [
      for (final d in out) d.withCode(codes[d.id]),
      for (final d in all.data.departments)
        if (!known.contains(d.departmentId))
          _Department(
            d.departmentId,
            d.name,
            optional: true,
            shortCode: codes[d.departmentId],
          ),
    ];
  }

  /// Departmanın bütün sayfaları; [optional] departman programda değilse null.
  Future<List<WorkItem>?> _items(
    String department, {
    bool optional = false,
  }) async {
    final all = <WorkItem>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      try {
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
      } on ApiError catch (e) {
        if (optional && page == 0 && e.code == _notInProgram) return null;
        rethrow;
      }
      if (cursor == null || cursor.isEmpty) break;
    }
    return all;
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

  /// [day]: GEÇİCİ (P1b) — v0.5.0 `WorkItem` başlangıç/bitiş taşımaz; görev tarihleri katalog
  /// günüyle doldurulur. v0.6.0 pin'inde `start_on`/`end_on` burada eşlenir.
  static TaskItem _task(WorkItem w, String? shortCode, DateTime day) {
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
      start: day,
      due: day,
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

/// Listesi okunacak departman: kimlik, ad, kısa kod; [optional] → yöneticinin şirket
/// listesinden (programa bağlı olmayabilir).
final class _Department {
  const _Department(
    this.id,
    this.name, {
    required this.optional,
    this.shortCode,
  });

  final String id;
  final String name;
  final bool optional;
  final String? shortCode;

  _Department withCode(String? code) =>
      _Department(id, name, optional: optional, shortCode: code ?? shortCode);
}
