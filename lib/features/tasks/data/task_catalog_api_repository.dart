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
/// Departman bağlamı TEKTİR (ürün kısıtı: departmanlar arası tarama yok — F57 koordinatör
/// düzeltmesi): kapsamda seçili departman ([departmentId]; değiştirme kancası
/// `ScopeController.selectDepartment`), yoksa hesabın bu programdaki ilk ekip satırı
/// (`GET /v1/me/departments`). Departman yoksa (ör. ekip satırı olmayan şirket yöneticisi)
/// liste isteği gönderilmez; katalog [TaskCatalog.departmentRequired] ile "departman seç"
/// durumunu taşır. Görünen kısa anahtar departmanın programdaki adıdır (kod P1b).
///
/// Rol `/v1/me` + `/v1/me/departments`'tan [TaskAccess]'te türetilir ve katalogla taşınır
/// (ayrıntı ekranı tarih talebi yüzünü buradan seçer). Yönetici rapor/kullanıcı uçları ve
/// `adminGantt` kullanılmaz. Liste dosya sayısı, not sayısı, açıklama ve adlar taşımaz.
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
       departmentId = departmentId ?? _none,
       correctDepartment = correctDepartment ?? _ignore,
       _now = now ?? DateTime.now;

  static String? _none() => null;
  static void _ignore(String _) {}

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;

  /// Kapsamda seçili departman (yoksa null; istek anında okunur).
  final String? Function() departmentId;

  /// Kapsamdaki kalıcı departman seçimi hesabın ekip satırlarında yoksa (yönetici değil)
  /// liste ilk satıra düşer ve seçim bununla düzeltilir (`ScopeController.selectDepartment`).
  final void Function(String departmentId) correctDepartment;
  final IdentityClient _identity;
  final WorkClient _work;
  final OrganizationClient _organization;
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

    final today = _now();
    final day = DateTime(today.year, today.month, today.day);
    final department = _department(access, program);
    final (items, truncated) = department == null
        ? (const <WorkItem>[], false)
        : await _items(department.$1);
    final tasks = [for (final w in items) _task(w, department!.$2, day)];

    return TaskCatalog(
      today: day,
      me: access.accountId,
      access: access,
      departmentId: department?.$1,
      truncated: truncated,
      tasks: tasks,
      people: [
        Person(
          id: access.accountId,
          name: me.fullName,
          role: access.personRoleIn(program),
        ),
      ],
      coordinatorships: [
        if (department case (final id, final name))
          CoordinatorshipRef(
            code: id,
            name: name,
            leads: const [],
            members: const [],
          ),
      ],
    );
  }

  /// Listenin TEK departmanı (kimlik, ad): kapsamda seçili departman; yoksa hesabın bu
  /// programdaki ilk ekip satırı. Seçili departman ekip satırlarında yoksa yönetici değilse
  /// ilk satıra düşülür ve seçim [correctDepartment] ile düzeltilir (eskimiş kalıcı seçim).
  /// Departman yoksa null → "departman seç" (istek gönderilmez). Şirket yöneticisinin
  /// programdaki departman listesi P1b'de (`listProgramDepartments`, v0.6.0).
  (String, String)? _department(TaskAccess access, String program) {
    final seats = access.seatsIn(program);
    final first = seats.firstOrNull;
    final selected = departmentId();
    if (selected != null && selected.isNotEmpty) {
      final seat = seats.where((s) => s.departmentId == selected).firstOrNull;
      if (seat != null) return (selected, seat.departmentName);
      if (access.companyAdmin) return (selected, selected);
      if (first != null) correctDepartment(first.departmentId);
    }
    return first == null ? null : (first.departmentId, first.departmentName);
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
