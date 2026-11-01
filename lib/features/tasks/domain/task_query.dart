import 'dart:collection';

import 'package:meta/meta.dart';

import 'task_catalog.dart';

/// Görev listesinin görünümleri (prototip `views`): sayılar katalogdan.
enum TaskView {
  all,
  late,
  inProgress,
  review,
  dateRequest,
  notStarted,
  done;

  bool matches(TaskItem t) => switch (this) {
    TaskView.all => true,
    TaskView.late => !t.isDone && t.isOverdue,
    TaskView.inProgress =>
      t.status == TaskStatus.inProgress || t.status == TaskStatus.returned,
    TaskView.review => t.status == TaskStatus.review,
    TaskView.dateRequest => t.hasPendingRequest,
    TaskView.notStarted => t.status == TaskStatus.todo,
    TaskView.done => t.isDone,
  };
}

/// Sıralama ölçütü; [defaultDescending] ölçüt seçildiğindeki yön.
enum TaskSort {
  created(defaultDescending: true),
  due(defaultDescending: false),
  start(defaultDescending: false),
  coordinatorship(defaultDescending: false);

  const TaskSort({required this.defaultDescending});

  final bool defaultDescending;

  /// Koordinatörlük sıralaması yönsüzdür (gruplu liste).
  bool get dated => this != TaskSort.coordinatorship;
}

/// Liste süzgeci (kişi, koordinatörlük, öncelik; aynı grupta "veya", gruplar arası "ve") ve
/// arama.
@immutable
final class TaskFilter {
  const TaskFilter({
    this.query = '',
    this.people = const {},
    this.coordinatorships = const {},
    this.priorities = const {},
  });

  final String query;
  final Set<String> people;
  final Set<String> coordinatorships;
  final Set<TaskPriority> priorities;

  bool get hasExtra =>
      people.isNotEmpty || coordinatorships.isNotEmpty || priorities.isNotEmpty;

  // Değer eşitliği: sonuç sağlayıcısı süzgeci `select` ile izler; aynı süzgeç yeniden
  // hesap tetiklemez.
  @override
  bool operator ==(Object other) =>
      other is TaskFilter &&
      other.query == query &&
      _sameSet(other.people, people) &&
      _sameSet(other.coordinatorships, coordinatorships) &&
      _sameSet(other.priorities, priorities);

  @override
  int get hashCode => Object.hash(
    query,
    Object.hashAllUnordered(people),
    Object.hashAllUnordered(coordinatorships),
    Object.hashAllUnordered(priorities),
  );

  static bool _sameSet<T>(Set<T> a, Set<T> b) =>
      identical(a, b) || (a.length == b.length && a.containsAll(b));

  bool matches(TaskItem t, TaskCatalog c) {
    if (coordinatorships.isNotEmpty &&
        !coordinatorships.contains(t.coordinatorship)) {
      return false;
    }
    if (priorities.isNotEmpty && !priorities.contains(t.priority)) {
      return false;
    }
    if (people.isNotEmpty && !t.assignees.any(people.contains)) return false;
    final q = trLower(query.trim());
    if (q.isEmpty) return true;
    final hay = trLower(
      [
        t.title,
        t.code,
        for (final a in t.assignees) c.nameOf(a) ?? '',
      ].join(' '),
    );
    return hay.contains(q);
  }
}

/// Koordinatörlük grubu (koordinatörlüğe göre sıralı liste).
@immutable
final class TaskGroup {
  const TaskGroup(this.coordinatorship, this.tasks);

  final String coordinatorship;
  final List<TaskItem> tasks;
}

/// Süzülmüş ve sıralanmış liste + görünüm sayıları.
@immutable
final class TaskQueryResult {
  const TaskQueryResult({
    required this.counts,
    required this.tasks,
    required this.groups,
  });

  /// Arama/süzgeç uygulanmış kümede her görünümün sayısı.
  final Map<TaskView, int> counts;

  /// Seçili görünümün görevleri (sıralı).
  final List<TaskItem> tasks;

  /// Koordinatörlüğe göre sıralamada gruplar (diğer sıralamalarda boş).
  final List<TaskGroup> groups;
}

/// Listeyi hesaplar (prototip `S_tasks.renderVals`).
TaskQueryResult queryTasks(
  TaskCatalog c, {
  required TaskView view,
  required TaskSort sort,
  required bool descending,
  required TaskFilter filter,
}) {
  final base = [
    for (final t in c.tasks)
      if (filter.matches(t, c)) t,
  ];
  final counts = {
    for (final v in TaskView.values) v: base.where(v.matches).length,
  };
  final k = descending ? -1 : 1;
  int doneLast(TaskItem a, TaskItem b) =>
      (a.isDone ? 1 : 0) - (b.isDone ? 1 : 0);
  String name(TaskItem t) =>
      c.coordinatorship(t.coordinatorship)?.name ?? t.coordinatorship;
  int cmp(TaskItem a, TaskItem b) => switch (sort) {
    TaskSort.created => _or(
      k * _compareNullable(a.createdAt, b.createdAt),
      () => a.due.compareTo(b.due),
    ),
    TaskSort.due => _or(doneLast(a, b), () => k * a.due.compareTo(b.due)),
    TaskSort.start => _or(
      k * a.start.compareTo(b.start),
      () => a.due.compareTo(b.due),
    ),
    TaskSort.coordinatorship => _or(
      trCompare(name(a), name(b)),
      () => _or(doneLast(a, b), () => a.due.compareTo(b.due)),
    ),
  };
  final list = _stableSort(base.where(view.matches).toList(), cmp);
  final groups = <TaskGroup>[];
  if (sort == TaskSort.coordinatorship) {
    var run = <TaskItem>[];
    for (var i = 0; i < list.length; i++) {
      run.add(list[i]);
      final last =
          i == list.length - 1 ||
          list[i + 1].coordinatorship != list[i].coordinatorship;
      if (last) {
        groups.add(TaskGroup(list[i].coordinatorship, run));
        run = <TaskItem>[];
      }
    }
  }
  return TaskQueryResult(counts: counts, tasks: list, groups: groups);
}

int _or(int a, int Function() b) => a != 0 ? a : b();

/// `null` (sunucunun taşımadığı oluşturma anı) en sona.
int _compareNullable(DateTime? a, DateTime? b) => a == null
    ? (b == null ? 0 : 1)
    : b == null
    ? -1
    : a.compareTo(b);

List<T> _stableSort<T>(List<T> list, int Function(T, T) cmp) {
  final indexed = [for (var i = 0; i < list.length; i++) (i, list[i])];
  indexed.sort((x, y) => _or(cmp(x.$2, y.$2), () => x.$1 - y.$1));
  return [for (final e in indexed) e.$2];
}

/// Türkçe küçük harf (`I` → `ı`, `İ` → `i`).
String trLower(String s) =>
    s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

const _trAlphabet = 'abcçdefgğhıijklmnoöprsştuüvwxyz';

/// Türkçe alfabe sırasıyla karşılaştırma (büyük/küçük harf duyarsız).
int trCompare(String a, String b) {
  final x = trLower(a);
  final y = trLower(b);
  final n = x.length < y.length ? x.length : y.length;
  for (var i = 0; i < n; i++) {
    if (x[i] == y[i]) continue;
    final p = _trAlphabet.indexOf(x[i]);
    final q = _trAlphabet.indexOf(y[i]);
    if (p >= 0 && q >= 0) return p - q;
    return x.codeUnitAt(i) - y.codeUnitAt(i);
  }
  return x.length - y.length;
}

/// Filtre alt sayfasının seçenekleri ve sayıları (prototip `G`): tüm görevler üzerinden;
/// kişiler görev sayısına göre azalan, görevi olmayan kişi/koordinatörlük düşer.
@immutable
final class TaskFilterOptions {
  const TaskFilterOptions({
    required this.people,
    required this.coordinatorships,
    required this.priorities,
  });

  final List<(Person, int)> people;
  final List<(CoordinatorshipRef, int)> coordinatorships;
  final Map<TaskPriority, int> priorities;
}

TaskFilterOptions filterOptions(TaskCatalog c) {
  final byPerson = HashMap<String, int>();
  final byCoord = HashMap<String, int>();
  final byPrio = {for (final p in TaskPriority.values) p: 0};
  for (final t in c.tasks) {
    for (final a in t.assignees) {
      byPerson[a] = (byPerson[a] ?? 0) + 1;
    }
    byCoord[t.coordinatorship] = (byCoord[t.coordinatorship] ?? 0) + 1;
    byPrio[t.priority] = byPrio[t.priority]! + 1;
  }
  final people = [
    for (final p in c.people)
      if ((byPerson[p.id] ?? 0) > 0) (p, byPerson[p.id]!),
  ];
  // Kararlı sıralama: eşit sayıda katalog sırası korunur.
  final indexed = [for (var i = 0; i < people.length; i++) (i, people[i])];
  indexed.sort((x, y) => _or(y.$2.$2 - x.$2.$2, () => x.$1 - y.$1));
  return TaskFilterOptions(
    people: [for (final e in indexed) e.$2],
    coordinatorships: [
      for (final co in c.coordinatorships)
        if ((byCoord[co.code] ?? 0) > 0) (co, byCoord[co.code]!),
    ],
    priorities: byPrio,
  );
}
