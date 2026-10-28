import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';
import 'activity_log.dart';

/// İşlem geçmişi süzgeci: tür, arama, yapan kişiler, koordinatörlük ve gösterilen kayıt sınırı.
@immutable
final class ActivityQuery {
  const ActivityQuery({
    this.kind,
    this.search = '',
    this.people = const {},
    this.coordinatorship,
    this.limit = pageSize,
  });

  /// İlk sayfa (prototip 30); "Daha fazla göster" [moreStep] ekler.
  static const pageSize = 30;
  static const moreStep = 12;

  /// null → Tümü.
  final ActivityKind? kind;
  final String search;
  final Set<String> people;

  /// Koordinatörlük kodu; null → hepsi.
  final String? coordinatorship;
  final int limit;

  /// Kişi ya da koordinatörlük süzgeci etkin (filtre dairesindeki nokta).
  bool get hasExtra => people.isNotEmpty || coordinatorship != null;

  bool get isEmpty => kind == null && !hasExtra && search.trim().isEmpty;

  ActivityQuery copyWith({
    ActivityKind? Function()? kind,
    String? search,
    Set<String>? people,
    String? Function()? coordinatorship,
    int? limit,
  }) => ActivityQuery(
    kind: kind == null ? this.kind : kind(),
    search: search ?? this.search,
    people: people ?? this.people,
    coordinatorship: coordinatorship == null
        ? this.coordinatorship
        : coordinatorship(),
    limit: limit ?? this.limit,
  );

  @override
  bool operator ==(Object other) =>
      other is ActivityQuery &&
      other.kind == kind &&
      other.search == search &&
      other.coordinatorship == coordinatorship &&
      other.limit == limit &&
      other.people.length == people.length &&
      other.people.containsAll(people);

  @override
  int get hashCode => Object.hash(
    kind,
    search,
    coordinatorship,
    limit,
    Object.hashAllUnordered(people),
  );
}

/// Bir günün kayıtları (sayaç süzülmüş toplamdır; [entries] sınıra göre kırpılmış olabilir).
@immutable
final class ActivityDay {
  const ActivityDay({
    required this.day,
    required this.count,
    required this.entries,
  });

  final DateTime day;
  final int count;
  final List<ActivityEntry> entries;
}

/// Süzgecin uygulanmış hâli: gün grupları, tür sayıları, toplam ve gösterilen.
@immutable
final class ActivityView {
  const ActivityView({
    required this.days,
    required this.kindCounts,
    required this.allCount,
    required this.total,
    required this.shown,
  });

  final List<ActivityDay> days;

  /// Kişi/koordinatörlük/arama süzgeciyle tür başına sayı.
  final Map<ActivityKind, int> kindCounts;

  /// Kişi/koordinatörlük/arama süzgeciyle tüm türler.
  final int allCount;

  /// Tür dahil bütün süzgeçlerle eşleşen.
  final int total;
  final int shown;

  bool get canShowMore => total > shown;
}

/// Kişinin bağlı olduğu ilk koordinatörlük (katalog sırası; koordinatör ya da üye).
String? coordinatorshipOf(TaskCatalog catalog, String personId) => catalog
    .coordinatorships
    .where((c) => c.leads.contains(personId) || c.members.contains(personId))
    .firstOrNull
    ?.code;

/// [query]'yi [log]'a uygular (gün sırası kayıt sırasıdır).
ActivityView applyActivityQuery(
  ActivityLog log,
  TaskCatalog catalog,
  ActivityQuery query,
) {
  final needle = query.search.trim().toLowerCase();
  bool extra(ActivityEntry e) =>
      (query.people.isEmpty || query.people.contains(e.actorId)) &&
      (query.coordinatorship == null ||
          coordinatorshipOf(catalog, e.actorId) == query.coordinatorship) &&
      (needle.isEmpty ||
          [
            e.action,
            e.detail,
            e.target,
            e.actorName,
          ].any((s) => s.toLowerCase().contains(needle)));
  final byExtra = log.entries.where(extra).toList();
  final matched = [
    for (final e in byExtra)
      if (query.kind == null || e.kind == query.kind) e,
  ];
  final days = <ActivityDay>[];
  var left = query.limit;
  DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);
  final grouped = <DateTime, List<ActivityEntry>>{};
  for (final e in matched) {
    grouped.putIfAbsent(dayOf(e.at), () => []).add(e);
  }
  for (final MapEntry(key: day, value: list) in grouped.entries) {
    if (left <= 0) break;
    final take = list.take(left).toList();
    days.add(ActivityDay(day: day, count: list.length, entries: take));
    left -= take.length;
  }
  return ActivityView(
    days: days,
    kindCounts: {
      for (final k in ActivityKind.values)
        k: byExtra.where((e) => e.kind == k).length,
    },
    allCount: byExtra.length,
    total: matched.length,
    shown: matched.length < query.limit ? matched.length : query.limit,
  );
}

final _taskCode = RegExp(r'^([A-ZÇĞİÖŞÜ]{3}-\d+)');

/// Kaydın hedefi bir görevse kodu ("ALT-16 · Hidrofor…" → "ALT-16"); değilse null.
String? taskCodeOf(ActivityEntry e) => _taskCode.firstMatch(e.target)?.group(1);
