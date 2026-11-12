import 'package:meta/meta.dart';

import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';

/// Takvim kaydı türü; sıra hücre noktalarının ve gün listesinin sırasıdır (toplantı, görev,
/// tarih talebi).
enum CalendarKind { meeting, task, request }

/// Görev kaydının o günle ilişkisi: bitiş ya da başlangıç o gün, ya da görev o gün sürüyor
/// (başlangıçtan sonra, bitişten önce; yalnız istenince listelenir, hücre noktası olmaz).
enum TaskEdge { end, start, ongoing }

/// Ay ızgarası ya da yalnız seçili günün haftası.
enum CalendarMode { month, week }

/// Saatsiz gün (yerel takvim günü).
DateTime calendarDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Ayın ilk günü.
DateTime calendarMonth(DateTime d) => DateTime(d.year, d.month);

/// İki gün arasındaki gün farkı ([a] − [b]); yaz saati kaymasından etkilenmez.
int calendarDiff(DateTime a, DateTime b) => DateTime.utc(
  a.year,
  a.month,
  a.day,
).difference(DateTime.utc(b.year, b.month, b.day)).inDays;

/// Takvimde bir güne düşen kayıt.
@immutable
sealed class CalendarEntry {
  const CalendarEntry();

  DateTime get date;
  CalendarKind get kind;
}

/// Toplantı (`listMeetings` satırı): yerel gün ve saat, başlık, bağlı departman adları.
/// Liste ucu yer, katılımcı ve gündem taşımaz; ayrıntı toplantı sayfasındadır.
final class MeetingEntry extends CalendarEntry {
  const MeetingEntry({
    required this.id,
    required this.date,
    required this.hour,
    required this.minute,
    required this.title,
    required this.departments,
  });

  /// Toplantı anını ([Meeting.meetingDate], UTC) yerel güne ve saate çevirir.
  factory MeetingEntry.of(Meeting m) {
    final at = m.meetingDate.toLocal();
    return MeetingEntry(
      id: m.id,
      date: calendarDay(at),
      hour: at.hour,
      minute: at.minute,
      title: m.title,
      departments: [for (final d in m.departments) d.name],
    );
  }

  final String id;
  @override
  final DateTime date;
  final int hour;
  final int minute;
  final String title;

  /// Bağlı departman adları (sahip departman ilk).
  final List<String> departments;

  /// Gün içi sıralama anahtarı (dakika).
  int get minuteOfDay => hour * 60 + minute;

  @override
  CalendarKind get kind => CalendarKind.meeting;
}

/// Görev başlangıcı ya da bitişi (görev kataloğundan türetilir).
final class TaskEntry extends CalendarEntry {
  const TaskEntry({
    required this.date,
    required this.code,
    required this.title,
    required this.coordinatorship,
    required this.edge,
    required this.assignees,
    required this.late,
    this.status,
    this.due,
  });

  @override
  final DateTime date;

  /// Görevin bitiş günü (süren görev satırında gösterilir).
  final DateTime? due;
  final String code;
  final String title;
  final String coordinatorship;
  final TaskEdge edge;
  final TaskStatus? status;

  /// Atanan kişi kimlikleri.
  final List<String> assignees;

  /// Bitiş bugünden önce ve görev bitmemiş.
  final bool late;

  @override
  CalendarKind get kind => CalendarKind.task;
}

/// Görevin bekleyen tarih değişikliği talebi (görev satırının `pending_date_request`'i);
/// talep edilen yeni bitiş gününe ([date]) düşer.
final class RequestEntry extends CalendarEntry {
  const RequestEntry({
    required this.code,
    required this.title,
    required this.start,
    required this.date,
  });

  /// Görev kodu.
  final String code;

  /// Görev başlığı.
  final String title;

  /// Talep edilen başlangıç.
  final DateTime start;

  /// Talep edilen bitiş.
  @override
  final DateTime date;

  @override
  CalendarKind get kind => CalendarKind.request;
}

/// Haftanın özeti: bitecek / başlayacak görevler (o hafta uçları), hafta boyunca süren
/// görevler (hafta öncesi başlamış, hafta sonrası bitecek) ve toplantılar; gün sırasıyla.
typedef CalendarWeek = ({
  List<TaskEntry> ends,
  List<TaskEntry> starts,
  List<TaskEntry> ongoing,
  List<MeetingEntry> meetings,
});

/// Bir dönemin sayıları ([CalendarIndex.period]): bitişi düşen görev ([due]; [done] tamamlanan,
/// [late] bitmemiş ve bugünden önce), başlangıcı düşen görev ([starts]), toplantı.
typedef CalendarPeriod = ({
  int due,
  int done,
  int late,
  int starts,
  int meetings,
});

/// Gün listesinin bir bölümü (toplantılar, görevler, talepler).
typedef CalendarGroup = ({CalendarKind kind, List<CalendarEntry> entries});

/// Günlere dağıtılmış kayıtlar ve verinin "bugün"ü.
@immutable
final class CalendarIndex {
  const CalendarIndex._(
    this.today,
    this._catalog,
    this._byDay,
    this.truncated,
    this._tasks,
  );

  /// Görünür toplantılar + görev kataloğu: bitmemiş her görevin başlangıcı ve bitişi, bekleyen
  /// her tarih talebinin yeni bitişi. [meetingsTruncated]: toplantı listesi sayfa tavanında
  /// kesildi; katalog kesilmesi [TaskCatalog.truncated]'dan okunur (ikisi [truncated]'da birleşir).
  factory CalendarIndex.build(
    List<Meeting> meetings,
    TaskCatalog catalog, {
    bool meetingsTruncated = false,
    String? accountId,
    String? coordinatorship,
  }) {
    final today = calendarDay(catalog.today);
    final by = <DateTime, List<CalendarEntry>>{};
    final filtered = <TaskItem>[];
    void add(CalendarEntry e) =>
        (by[calendarDay(e.date)] ??= <CalendarEntry>[]).add(e);
    meetings
        .where(
          (m) =>
              coordinatorship == null ||
              m.departments.any((d) => d.id == coordinatorship),
        )
        .map(MeetingEntry.of)
        .forEach(add);
    for (final t in catalog.tasks) {
      if (coordinatorship != null && t.coordinatorship != coordinatorship) {
        continue;
      }
      if (accountId != null && !t.assignees.contains(accountId)) continue;
      filtered.add(t);
      if (t.dateRequest case final r? when r.isPending) {
        add(
          RequestEntry(
            code: t.code,
            title: t.title,
            start: calendarDay(r.start),
            date: calendarDay(r.due),
          ),
        );
      }
      if (t.isDone) continue;
      final due = calendarDay(t.due);
      for (final (edge, day) in [
        (TaskEdge.end, due),
        (TaskEdge.start, calendarDay(t.start)),
      ]) {
        add(
          TaskEntry(
            date: day,
            code: t.code,
            title: t.title,
            coordinatorship: t.coordinatorship,
            edge: edge,
            assignees: t.assignees,
            late: edge == TaskEdge.end && due.isBefore(today),
          ),
        );
      }
    }
    return CalendarIndex._(
      today,
      catalog,
      by,
      meetingsTruncated || catalog.truncated,
      filtered,
    );
  }

  /// Kişi profili: gerçek başlangıç/bitişler, tamamlananlar dahil; aynı gün tek bitiş
  /// kaydı. Gecikme sunucunun olgusudur, yerel saatten yetki veya gecikme türetilmez.
  factory CalendarIndex.personTasks(TaskCatalog catalog, String accountId) {
    final by = <DateTime, List<CalendarEntry>>{};
    final mine = [
      for (final t in catalog.tasks)
        if (t.assignees.contains(accountId)) t,
    ];
    for (final task in mine) {
      final start = calendarDay(task.start);
      final due = calendarDay(task.due);
      for (final (edge, date) in [
        (TaskEdge.end, due),
        if (start != due) (TaskEdge.start, start),
      ]) {
        (by[date] ??= []).add(
          TaskEntry(
            date: date,
            code: task.code,
            title: task.title,
            coordinatorship: task.coordinatorship,
            edge: edge,
            assignees: task.assignees,
            late: edge == TaskEdge.end && !task.isDone && task.isOverdue,
            status: task.status,
          ),
        );
      }
    }
    return CalendarIndex._(
      calendarDay(catalog.today),
      catalog,
      by,
      catalog.truncated,
      mine,
    );
  }

  final DateTime today;

  /// Kaynaklardan biri (toplantı listesi ya da görev kataloğu) kesik: boş görünen gün gerçekte
  /// boş olmayabilir; arayüz kısa uyarı gösterir.
  final bool truncated;
  final TaskCatalog _catalog;
  final Map<DateTime, List<CalendarEntry>> _byDay;

  /// Dizinin süzgecinden geçen bütün görevler (tamamlananlar dahil): hafta boyu süren
  /// görevlerin ve dönem özetinin kaynağı.
  final List<TaskItem> _tasks;

  /// [from]–[to] (dahil) özeti: bitişi düşen görevler (tamamlanan ve gecikmiş olanlarıyla),
  /// başlangıcı düşen görevler ve toplantılar.
  CalendarPeriod period(DateTime from, DateTime to) {
    final a = calendarDay(from);
    final b = calendarDay(to);
    bool inRange(DateTime d) {
      final x = calendarDay(d);
      return !x.isBefore(a) && !x.isAfter(b);
    }

    final due = [
      for (final t in _tasks)
        if (inRange(t.due)) t,
    ];
    var meetings = 0;
    for (final MapEntry(:key, :value) in _byDay.entries) {
      if (inRange(key)) meetings += value.whereType<MeetingEntry>().length;
    }
    return (
      due: due.length,
      done: due.where((t) => t.isDone).length,
      late: due
          .where((t) => !t.isDone && calendarDay(t.due).isBefore(today))
          .length,
      starts: _tasks.where((t) => inRange(t.start)).length,
      meetings: meetings,
    );
  }

  /// Koordinatörlük adı (görev satırında kimlik yerine); bilinmiyorsa null.
  String? coordinatorshipName(String code) =>
      _catalog.coordinatorship(code)?.name;

  /// Kişi adı (sunucunun verdiği ad dahil); bilinmiyorsa null (arayüz nötr etiket gösterir).
  String? personName(String id) => _catalog.nameOf(id);

  /// [day]'in haftası (pazartesi–pazar): uçlar gün sırasıyla, toplantılar gün + saatle, süren
  /// görevler bitişe göre.
  CalendarWeek week(DateTime day) {
    final days = weekOf(day);
    final first = days.first;
    final last = days.last;
    final all = [for (final d in days) ...on(d)];
    final tasks = all.whereType<TaskEntry>();
    final meetings = all.whereType<MeetingEntry>().toList()
      ..sort(
        (a, b) => a.date == b.date
            ? a.minuteOfDay.compareTo(b.minuteOfDay)
            : a.date.compareTo(b.date),
      );
    final ongoing = [
      for (final t in _tasks)
        if (!t.isDone &&
            calendarDay(t.start).isBefore(first) &&
            last.isBefore(calendarDay(t.due)))
          TaskEntry(
            date: calendarDay(t.due),
            code: t.code,
            title: t.title,
            coordinatorship: t.coordinatorship,
            edge: TaskEdge.ongoing,
            assignees: t.assignees,
            late: false,
            due: calendarDay(t.due),
          ),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return (
      ends: [...tasks.where((t) => t.edge == TaskEdge.end)],
      starts: [...tasks.where((t) => t.edge == TaskEdge.start)],
      ongoing: ongoing,
      meetings: meetings,
    );
  }

  /// Günün bütün kayıtları.
  List<CalendarEntry> on(DateTime day) =>
      _byDay[calendarDay(day)] ?? const <CalendarEntry>[];

  /// Hücredeki kayıt sayısı.
  int count(DateTime day) => on(day).length;

  /// Günün türleri, [CalendarKind] sırasıyla, yinelenmeden (hücre noktaları).
  List<CalendarKind> kinds(DateTime day) {
    final set = {for (final e in on(day)) e.kind};
    return [
      for (final k in CalendarKind.values)
        if (set.contains(k)) k,
    ];
  }

  /// Bölümler (boşlar atlanır): toplantılar saate göre, görevlerde bitenler önce.
  List<CalendarGroup> groups(DateTime day) {
    final list = on(day);
    final meetings = list.whereType<MeetingEntry>().toList()
      ..sort((a, b) => a.minuteOfDay.compareTo(b.minuteOfDay));
    final tasks = [
      ...list.whereType<TaskEntry>().where((t) => t.edge == TaskEdge.end),
      ...list.whereType<TaskEntry>().where((t) => t.edge == TaskEdge.start),
    ];
    return [
      for (final g in <CalendarGroup>[
        (kind: CalendarKind.meeting, entries: meetings),
        (kind: CalendarKind.task, entries: tasks),
        (
          kind: CalendarKind.request,
          entries: list.whereType<RequestEntry>().toList(),
        ),
      ])
        if (g.entries.isNotEmpty) g,
    ];
  }
}

/// [day]'in haftası: pazartesiden pazara yedi gün.
List<DateTime> weekOf(DateTime day) {
  final d = calendarDay(day);
  final monday = DateTime(
    d.year,
    d.month,
    d.day - (d.weekday - DateTime.monday),
  );
  return [
    for (var i = 0; i < 7; i++)
      DateTime(monday.year, monday.month, monday.day + i),
  ];
}

/// [month] ayının ızgarası: pazartesi başlayan haftalar, ayın dışındaki günler dahil
/// (4–6 satır).
List<List<DateTime>> monthWeeks(DateTime month) {
  final first = calendarMonth(month);
  final lead = (first.weekday - DateTime.monday) % 7;
  final days = DateTime(first.year, first.month + 1, 0).day;
  final rows = ((lead + days) / 7).ceil();
  return [
    for (var w = 0; w < rows; w++)
      [
        for (var k = 0; k < 7; k++)
          DateTime(first.year, first.month, 1 - lead + w * 7 + k),
      ],
  ];
}

/// [day]'in [month] ızgarasındaki hafta sırası (0'dan).
int weekIndexOf(DateTime day, DateTime month) {
  final first = calendarMonth(month);
  final lead = (first.weekday - DateTime.monday) % 7;
  return (calendarDiff(day, first) + lead) ~/ 7;
}
