import 'package:meta/meta.dart';

import '../../../core/domain/turkish_collation.dart';
import '../../scope/scope.dart' show DepartmentRole;
import '../../tasks/tasks.dart';
import 'department.dart' show Department, MemberStatus;

/// Koordinatörlük listesinin sıralama ölçütü (prototip kısayol menüsü: ad / gecikme /
/// ilerleme).
enum CoordinatorshipSort { name, tasks, members, progress, late }

/// Görev kataloğundan türetilmiş koordinatörlük özeti (liste kartı, ayrıntı özeti).
@immutable
final class CoordinatorshipStats {
  const CoordinatorshipStats({
    required this.code,
    required this.name,
    required this.done,
    required this.total,
    required this.late,
    required this.leads,
    required this.members,
    this.shortCode,
    this.memberCount,
  });

  /// Anahtar: `department_id` (kullanıcıya gösterilmez; ekranda [shortCode]).
  final String code;
  final String name;

  /// Ekrandaki kısa etiket: departman kodu ("ALT"); sunucu vermediyse null (gösterilmez).
  final String? shortCode;
  final int done;
  final int total;

  /// Geciken (bitişi geçmiş, tamamlanmamış) görev sayısı.
  final int late;
  final List<Person> leads;

  /// Katalogdaki üye kişiler.
  final List<Person> members;

  /// Sunucunun toplam üye sayısı; bilinmiyorsa katalogdaki kişiler kullanılır.
  final int? memberCount;
  int get totalMembers => memberCount ?? members.length;

  int get open => total - done;
  double get ratio => total == 0 ? 0 : done / total;
  bool get hasLead => leads.isNotEmpty;
}

/// Katalogdaki her koordinatörlüğün özeti (katalog sırasıyla).
List<CoordinatorshipStats> coordinatorshipStats(TaskCatalog catalog) => [
  for (final c in catalog.coordinatorships) _stats(catalog, c),
];

CoordinatorshipStats _stats(TaskCatalog catalog, CoordinatorshipRef c) {
  final tasks = catalog.tasksOf(c.code);
  return CoordinatorshipStats(
    code: c.code,
    name: c.name,
    shortCode: c.shortCode,
    done: tasks.where((t) => t.status == TaskStatus.done).length,
    total: tasks.length,
    late: tasks.where((t) => t.isOverdue).length,
    leads: [...c.leads.map(catalog.person).nonNulls],
    members: [...c.members.map(catalog.person).nonNulls],
  );
}

/// [sort] ölçütüyle sıralı kopya: ad Türkçe A→Z; gecikme çoktan aza (eşitlikte ad);
/// ilerleme yüksekten düşüğe (eşitlikte ad).
List<CoordinatorshipStats> sortCoordinatorships(
  List<CoordinatorshipStats> list,
  CoordinatorshipSort sort, {
  bool? descending,
}) {
  int byName(CoordinatorshipStats a, CoordinatorshipStats b) =>
      compareTurkish(a.name, b.name);
  final reverse = descending ?? sort != CoordinatorshipSort.name;
  return [...list]..sort((a, b) {
    final comparison = switch (sort) {
      CoordinatorshipSort.name => byName(a, b),
      CoordinatorshipSort.tasks => a.total.compareTo(b.total),
      CoordinatorshipSort.members => a.totalMembers.compareTo(b.totalMembers),
      CoordinatorshipSort.late => a.late.compareTo(b.late),
      CoordinatorshipSort.progress => a.ratio.compareTo(b.ratio),
    };
    return _or(reverse ? -comparison : comparison, a, b, byName);
  });
}

int _or<T>(int d, T a, T b, int Function(T, T) tie) => d != 0 ? d : tie(a, b);

/// Ayrıntıdaki "dikkat gerektirenler" satırı: geciken görev.
@immutable
final class AttentionItem {
  const AttentionItem({
    required this.code,
    required this.title,
    required this.assignee,
    required this.overdueDays,
    String? label,
  }) : label = label ?? code;

  /// Anahtar (görev kimliği; gezinme).
  final String code;

  /// Ekrandaki kısa anahtar ([TaskItem.displayCode]; kimlik gösterilmez).
  final String label;
  final String title;

  /// İlk atananın adı (yoksa null).
  final String? assignee;
  final int overdueDays;
}

/// Ekip satırı (koordinatör ya da üye). Sunucuda departman üye listesinin
/// (`GET /v1/departments/{id}/members`, `RosterMember`) satırıdır: [name] ↔ `full_name`,
/// [lead] ↔ `role == koordinator`; [accountId], [membershipId], [role] ve [status] yalnız
/// üye listesinden eşlenen satırda doludur (katalogdan türetilen ayrıntı satırında `null`).
@immutable
final class TeamMember {
  const TeamMember({
    required this.name,
    required this.lead,
    this.accountId,
    this.membershipId,
    this.role,
    this.status,
  });

  final String name;

  final bool lead;

  final String? accountId;
  final String? membershipId;
  final DepartmentRole? role;
  final MemberStatus? status;
}

/// Koordinatörlük ayrıntısı: katalog özeti + departman kaydı + türetilmiş listeler.
@immutable
final class CoordinatorshipDetail {
  const CoordinatorshipDetail({
    required this.stats,
    required this.attention,
    required this.leads,
    required this.members,
    required this.others,
    this.department,
  });

  final CoordinatorshipStats stats;

  /// Sunucunun departman kaydı (tür, açıklama). Yalnız şirket yöneticisi okuyabilir; diğer
  /// rollerde ya da kayıt listede yoksa null (ekranda tür gösterilmez).
  final Department? department;

  /// Geciken görevler, en çok gecikenden.
  final List<AttentionItem> attention;
  final List<TeamMember> leads;
  final List<TeamMember> members;

  /// Kısayol menüsü için bütün koordinatörlükler (ada göre).
  final List<CoordinatorshipStats> others;

  int get people => leads.length + members.length;

  /// [code] (`department_id`) için ayrıntı; katalogda yoksa null. [departments] departman
  /// kayıtlarıdır (yönetici dışında boş).
  static CoordinatorshipDetail? from(
    TaskCatalog catalog,
    List<Department> departments,
    String code,
  ) {
    final ref = catalog.coordinatorship(code);
    if (ref == null) return null;
    final stats = _stats(catalog, ref);
    final overdue = [
      for (final t in catalog.tasksOf(code))
        if (t.isOverdue) t,
    ]..sort((a, b) => b.overdueDays.compareTo(a.overdueDays));
    return CoordinatorshipDetail(
      stats: stats,
      department: departments.where((d) => d.id == code).firstOrNull,
      attention: [
        for (final t in overdue)
          AttentionItem(
            code: t.code,
            label: t.displayCode,
            title: t.title,
            assignee: t.assignees
                .map(catalog.person)
                .nonNulls
                .firstOrNull
                ?.name,
            overdueDays: t.overdueDays,
          ),
      ],
      leads: [
        for (final p in stats.leads) TeamMember(name: p.name, lead: true),
      ],
      members: [
        for (final p in stats.members) TeamMember(name: p.name, lead: false),
      ],
      others: sortCoordinatorships(
        coordinatorshipStats(catalog),
        CoordinatorshipSort.name,
      ),
    );
  }
}
