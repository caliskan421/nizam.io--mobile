import 'package:meta/meta.dart';

import '../../../core/domain/turkish_collation.dart';
import '../../tasks/tasks.dart';
import 'coordinatorship_profile.dart';

/// Koordinatörlük listesinin sıralama ölçütü (prototip kısayol menüsü: ad / gecikme /
/// ilerleme).
enum CoordinatorshipSort { name, late, progress }

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
  });

  final String code;
  final String name;
  final int done;
  final int total;

  /// Geciken (bitişi geçmiş, tamamlanmamış) görev sayısı.
  final int late;
  final List<Person> leads;

  /// Katalogdaki üye kişiler.
  final List<Person> members;

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
  CoordinatorshipSort sort,
) {
  int byName(CoordinatorshipStats a, CoordinatorshipStats b) =>
      compareTurkish(a.name, b.name);
  return [...list]..sort(
    (a, b) => switch (sort) {
      CoordinatorshipSort.name => byName(a, b),
      CoordinatorshipSort.late => _or(b.late.compareTo(a.late), a, b, byName),
      CoordinatorshipSort.progress => _or(
        b.ratio.compareTo(a.ratio),
        a,
        b,
        byName,
      ),
    },
  );
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
  });

  final String code;
  final String title;

  /// İlk atananın adı (yoksa null).
  final String? assignee;
  final int overdueDays;
}

/// Ekip satırı (koordinatör ya da üye) ve bağlı olduğu birim.
@immutable
final class TeamMember {
  const TeamMember({
    required this.name,
    required this.unit,
    required this.lead,
  });

  final String name;

  /// Alt birim adı (yoksa üst birim).
  final String unit;
  final bool lead;
}

/// Son etkinlik satırı (yapanın adı çözülmüş).
@immutable
final class FeedItem {
  const FeedItem({
    required this.who,
    required this.action,
    required this.target,
    required this.at,
  });

  final String who;
  final String action;
  final String target;
  final DateTime at;
}

/// Koordinatörlük ayrıntısı: katalog özeti + ek bilgiler + türetilmiş listeler.
@immutable
final class CoordinatorshipDetail {
  const CoordinatorshipDetail({
    required this.stats,
    required this.profile,
    required this.attention,
    required this.leads,
    required this.members,
    required this.feed,
    required this.seasonRatio,
    required this.others,
  });

  final CoordinatorshipStats stats;
  final CoordinatorshipProfile profile;

  /// Geciken görevler, en çok gecikenden.
  final List<AttentionItem> attention;
  final List<TeamMember> leads;
  final List<TeamMember> members;
  final List<FeedItem> feed;

  /// Tüm görevlerde tamamlanma oranı (sezon ortalaması).
  final double seasonRatio;

  /// Kısayol menüsü için bütün koordinatörlükler (ada göre).
  final List<CoordinatorshipStats> others;

  int get people => leads.length + members.length;

  /// [code] için ayrıntı; katalogda ya da ek bilgilerde yoksa null.
  static CoordinatorshipDetail? from(
    TaskCatalog catalog,
    List<CoordinatorshipProfile> profiles,
    String code,
  ) {
    final ref = catalog.coordinatorship(code);
    final profile = profiles.where((p) => p.code == code).firstOrNull;
    if (ref == null || profile == null) return null;
    final stats = _stats(catalog, ref);
    String unitOf(String? personId, int index) {
      final own = personId == null
          ? null
          : profile.units.where((u) => u.leadId == personId).firstOrNull;
      if (own != null) return own.name;
      if (profile.units.isEmpty) return profile.parent;
      return profile.units[index % profile.units.length].name;
    }

    final overdue = [
      for (final t in catalog.tasksOf(code))
        if (t.isOverdue) t,
    ]..sort((a, b) => b.overdueDays.compareTo(a.overdueDays));
    final all = catalog.tasks;
    return CoordinatorshipDetail(
      stats: stats,
      profile: profile,
      attention: [
        for (final t in overdue)
          AttentionItem(
            code: t.code,
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
        for (final p in stats.leads)
          TeamMember(
            name: p.name,
            unit:
                profile.units
                    .where((u) => u.leadId == p.id)
                    .firstOrNull
                    ?.name ??
                profile.parent,
            lead: true,
          ),
      ],
      members: [
        for (final (i, p) in stats.members.indexed)
          TeamMember(name: p.name, unit: unitOf(p.id, i), lead: false),
        for (final (i, n) in profile.extraMembers.indexed)
          TeamMember(
            name: n,
            unit: unitOf(null, i + stats.members.length),
            lead: false,
          ),
      ],
      feed: [
        for (final e in profile.events)
          FeedItem(
            who: catalog.person(e.actorId)?.name ?? e.actorId,
            action: e.action,
            target: e.target,
            at: e.at,
          ),
      ],
      seasonRatio: all.isEmpty
          ? 0
          : all.where((t) => t.status == TaskStatus.done).length / all.length,
      others: sortCoordinatorships(
        coordinatorshipStats(catalog),
        CoordinatorshipSort.name,
      ),
    );
  }
}
