import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';

/// Üye ana sayfasının görev özeti (tasarım §4.1): odak görevi, en yakın iade, sayılar, ilk açık
/// satırlar. Görev kümesi görev listesiyle aynıdır ([scopedTasks]; yalnız etkin koordinatörlükte
/// üyeye atananlar). Saf türetme [memberHome]; ekran [memberHomeProvider] üzerinden okur.
@immutable
final class MemberHome {
  const MemberHome({
    required this.tasks,
    required this.focus,
    required this.returned,
    required this.stats,
    required this.open,
    required this.truncated,
  });

  /// Üyenin görünen görevleri (yaklaşanlar bunun bitişlerinden).
  final List<TaskItem> tasks;

  /// "Sıradaki işin": başlamadı ya da devam eden; geciken önce, sonra bitişi yakın.
  final TaskItem? focus;

  /// Bitişi en yakın iade edilmiş görev (yoksa kart çizilmez).
  final TaskItem? returned;

  /// Toplam · geciken · onayda · biten (görev listesi kutucuklarıyla aynı sayım).
  final CoordinatorSummary stats;

  /// Açık görevler (bitmemiş), geciken önce sonra bitişe göre; ekran ilk [rows] satırı çizer.
  final List<TaskItem> open;

  /// Kaynak katalog kesik (sayılar eksik olabilir).
  final bool truncated;

  /// Görevlerim bölümünde gösterilen satır.
  static const rows = 5;
}

/// [tasks] (üyenin görev kümesi) için ana sayfa özeti. Sıralamada eşitlikte giriş sırası korunur.
MemberHome memberHome(Iterable<TaskItem> tasks, {bool truncated = false}) {
  final list = List<TaskItem>.unmodifiable(tasks);
  final open = _urgentFirst([
    for (final t in list)
      if (!t.isDone && t.status != TaskStatus.unknown) t,
  ]);
  TaskItem? first(bool Function(TaskItem t) test) {
    for (final t in open) {
      if (test(t)) return t;
    }
    return null;
  }

  final returned = _byDue([
    for (final t in list)
      if (t.status == TaskStatus.returned) t,
  ]);
  return MemberHome(
    tasks: list,
    focus: first(
      (t) => t.status == TaskStatus.todo || t.status == TaskStatus.inProgress,
    ),
    returned: returned.isEmpty ? null : returned.first,
    stats: summarizeTasks(list),
    open: open,
    truncated: truncated,
  );
}

/// Yaklaşan öğe: toplantı ya da kendi görevinin son tarihi.
@immutable
final class UpcomingItem {
  const UpcomingItem.meeting(Meeting this.meeting, this.at) : task = null;
  const UpcomingItem.due(TaskItem this.task, this.at) : meeting = null;

  final Meeting? meeting;
  final TaskItem? task;

  /// Sıralama anı (toplantıda başlangıç; görevde bitiş günü).
  final DateTime at;
}

/// Önümüzdeki [days] günün (bugün dahil) toplantıları ve bitmemiş görev bitişleri, zamana göre;
/// en çok [limit]. Bugünün saati geçmiş toplantısı da kalır (toplantılar sayfasının "Yaklaşan"
/// sekmesi gibi: başlamamışsa "bekliyor"); önceki günün toplantısı yalnız [live] ise. Geçmiş bitişler
/// (gecikenler) yaklaşan değildir; odak ve Görevlerim bölümünde görünür.
List<UpcomingItem> memberUpcoming(
  Iterable<TaskItem> tasks,
  Iterable<Meeting> meetings, {
  required DateTime today,
  required DateTime now,
  bool Function(Meeting m)? live,
  int days = 7,
  int limit = 4,
}) {
  final start = _day(today);
  final end = start.add(Duration(days: days));
  final items = <UpcomingItem>[
    for (final m in meetings)
      if (m.meetingDate.toLocal() case final at
          when (!at.isBefore(start) || (live?.call(m) ?? false)) &&
              at.isBefore(end))
        UpcomingItem.meeting(m, at),
    for (final t in tasks)
      if (!t.isDone && t.status != TaskStatus.unknown)
        if (_day(t.due) case final d when !d.isBefore(start) && d.isBefore(end))
          UpcomingItem.due(t, d),
  ];
  final indexed = [for (final (i, x) in items.indexed) (i, x)]
    ..sort((a, b) {
      final o = a.$2.at.compareTo(b.$2.at);
      return o != 0 ? o : a.$1 - b.$1;
    });
  return [for (final e in indexed.take(limit)) e.$2];
}

/// Üye görünümünde ana sayfa özeti; başka görünümde ya da katalog yokken null.
final memberHomeProvider = Provider.autoDispose<MemberHome?>((ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  final view = ref.watch(effectiveAccessProvider);
  if (catalog == null || !view.isMemberView) return null;
  return memberHome(
    scopedTasks(
      catalog.tasks,
      role: view.role,
      departmentId: view.departmentId,
      me: catalog.me,
    ),
    truncated: catalog.truncated,
  );
});

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

List<TaskItem> _byDue(List<TaskItem> tasks) {
  final indexed = [for (final (i, t) in tasks.indexed) (i, t)]
    ..sort((a, b) {
      final o = _day(a.$2.due).compareTo(_day(b.$2.due));
      return o != 0 ? o : a.$1 - b.$1;
    });
  return [for (final e in indexed) e.$2];
}

/// Geciken önce (en eski bitiş başta), sonra bitişi yakın olan.
List<TaskItem> _urgentFirst(List<TaskItem> tasks) => [
  ..._byDue([
    for (final t in tasks)
      if (isTaskLate(t)) t,
  ]),
  ..._byDue([
    for (final t in tasks)
      if (!isTaskLate(t)) t,
  ]),
];
