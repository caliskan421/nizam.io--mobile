import 'package:meta/meta.dart';

import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';

/// Takvim kaydı türü; sıra hücre noktalarının ve gün listesinin sırasıdır (toplantı, görev,
/// tarih talebi).
enum CalendarKind { meeting, task, request }

/// Görev kaydının hangi ucu o güne düşer.
enum TaskEdge { start, end }

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
  });

  @override
  final DateTime date;
  final String code;
  final String title;
  final String coordinatorship;
  final TaskEdge edge;

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

/// Gün listesinin bir bölümü (toplantılar, görevler, talepler).
typedef CalendarGroup = ({CalendarKind kind, List<CalendarEntry> entries});

/// Günlere dağıtılmış kayıtlar ve verinin "bugün"ü.
@immutable
final class CalendarIndex {
  const CalendarIndex._(this.today, this._catalog, this._byDay);

  /// Görünür toplantılar + görev kataloğu: bitmemiş her görevin başlangıcı ve bitişi, bekleyen
  /// her tarih talebinin yeni bitişi.
  factory CalendarIndex.build(List<Meeting> meetings, TaskCatalog catalog) {
    final today = calendarDay(catalog.today);
    final by = <DateTime, List<CalendarEntry>>{};
    void add(CalendarEntry e) =>
        (by[calendarDay(e.date)] ??= <CalendarEntry>[]).add(e);
    meetings.map(MeetingEntry.of).forEach(add);
    for (final t in catalog.tasks) {
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
    return CalendarIndex._(today, catalog, by);
  }

  final DateTime today;
  final TaskCatalog _catalog;
  final Map<DateTime, List<CalendarEntry>> _byDay;

  /// Kişi adı (sunucunun verdiği ad dahil); bilinmiyorsa null (arayüz nötr etiket gösterir).
  String? personName(String id) => _catalog.nameOf(id);

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
