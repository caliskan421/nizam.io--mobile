import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';

/// Takvim kaydı türü; sıra hücre noktalarının ve gün listesinin sırasıdır (prototip
/// `ORDER`: sezon, toplantı, görev, talep, tablo kaydı).
enum CalendarKind { season, meeting, task, request, sheet }

/// Talep türü.
enum RequestType { purchase, quote, expense, budget }

/// Talep durumu.
enum RequestState { pending, approved, ordered, delivered }

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

/// Sezon tarihi (ör. "Saha teslimi").
final class SeasonEntry extends CalendarEntry {
  const SeasonEntry({required this.date, required this.title});

  @override
  final DateTime date;
  final String title;

  @override
  CalendarKind get kind => CalendarKind.season;
}

/// Toplantı; [coordinatorships] boşsa bütün koordinatörlükler davetlidir.
final class MeetingEntry extends CalendarEntry {
  const MeetingEntry({
    required this.date,
    required this.hour,
    required this.minute,
    required this.title,
    required this.coordinatorships,
    required this.participants,
    required this.place,
    required this.chatId,
    required this.agenda,
  });

  @override
  final DateTime date;
  final int hour;
  final int minute;
  final String title;

  /// Davetli koordinatörlük kodları; boş → tüm koordinatörlükler.
  final List<String> coordinatorships;
  final int participants;
  final String place;

  /// Toplantının sohbet kimliği ("Gruba yaz").
  final String chatId;
  final List<String> agenda;

  bool get allCoordinatorships => coordinatorships.isEmpty;

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

/// Satın alma / teklif / masraf / ek bütçe talebi; [date] ihtiyaç tarihidir.
final class RequestEntry extends CalendarEntry {
  const RequestEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.coordinatorship,
    required this.amount,
    required this.state,
    required this.date,
    this.taskCode,
  });

  final String id;
  final RequestType type;
  final String title;
  final String coordinatorship;

  /// Tutar (TL); 0 → teklif bekleniyor.
  final int amount;
  final RequestState state;
  @override
  final DateTime date;

  /// Bağlı görev kodu.
  final String? taskCode;

  @override
  CalendarKind get kind => CalendarKind.request;
}

/// Tablo kaydı (kontrol listesi / çizelge satırı).
final class SheetEntry extends CalendarEntry {
  const SheetEntry({
    required this.date,
    required this.label,
    required this.table,
    required this.person,
    required this.coordinatorship,
    required this.done,
  });

  @override
  final DateTime date;
  final String label;
  final String table;

  /// Kişi kimliği (görev kataloğundaki kişiler).
  final String person;
  final String coordinatorship;
  final bool done;

  @override
  CalendarKind get kind => CalendarKind.sheet;
}

/// Takvimin görev dışı kaynakları (görevler görev kataloğundan gelir).
@immutable
final class CalendarSources {
  const CalendarSources({
    required this.seasons,
    required this.meetings,
    required this.requests,
    required this.sheets,
    required this.taskStartsFrom,
  });

  final List<SeasonEntry> seasons;
  final List<MeetingEntry> meetings;
  final List<RequestEntry> requests;
  final List<SheetEntry> sheets;

  /// Bu günden önce başlayan görevlerin başlangıcı takvime düşmez (bitişi düşer).
  final DateTime taskStartsFrom;
}

/// Takvim kaynaklarının kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class CalendarRepository {
  Future<CalendarSources> load();
}

/// Gün listesinin bir bölümü (toplantılar, görevler, talepler, tablo kayıtları).
typedef CalendarGroup = ({CalendarKind kind, List<CalendarEntry> entries});

/// Günlere dağıtılmış kayıtlar ve verinin "bugün"ü.
@immutable
final class CalendarIndex {
  const CalendarIndex._(this.today, this._catalog, this._byDay);

  /// Kaynaklar + görev kataloğu: bitmemiş her görevin bitişi ve
  /// [CalendarSources.taskStartsFrom]'dan sonraki başlangıcı düşer.
  factory CalendarIndex.build(CalendarSources s, TaskCatalog catalog) {
    final today = calendarDay(catalog.today);
    final by = <DateTime, List<CalendarEntry>>{};
    void add(CalendarEntry e) =>
        (by[calendarDay(e.date)] ??= <CalendarEntry>[]).add(e);
    s.seasons.forEach(add);
    s.meetings.forEach(add);
    s.requests.forEach(add);
    s.sheets.forEach(add);
    for (final t in catalog.tasks) {
      if (t.isDone) continue;
      final due = calendarDay(t.due);
      add(
        TaskEntry(
          date: due,
          code: t.code,
          title: t.title,
          coordinatorship: t.coordinatorship,
          edge: TaskEdge.end,
          assignees: t.assignees,
          late: due.isBefore(today),
        ),
      );
      final start = calendarDay(t.start);
      if (!start.isBefore(calendarDay(s.taskStartsFrom))) {
        add(
          TaskEntry(
            date: start,
            code: t.code,
            title: t.title,
            coordinatorship: t.coordinatorship,
            edge: TaskEdge.start,
            assignees: t.assignees,
            late: false,
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

  /// Koordinatörlük adı (bilinmeyen kod olduğu gibi).
  String coordinatorshipName(String code) =>
      _catalog.coordinatorship(code)?.name ?? code;

  /// Günün bütün kayıtları (sezon dahil).
  List<CalendarEntry> on(DateTime day) =>
      _byDay[calendarDay(day)] ?? const <CalendarEntry>[];

  /// Hücredeki kayıt sayısı (sezon dahil; prototip `evOn(iso).length`).
  int count(DateTime day) => on(day).length;

  /// Günün türleri, [CalendarKind] sırasıyla, yinelenmeden (hücre noktaları).
  List<CalendarKind> kinds(DateTime day) {
    final set = {for (final e in on(day)) e.kind};
    return [
      for (final k in CalendarKind.values)
        if (set.contains(k)) k,
    ];
  }

  List<SeasonEntry> seasons(DateTime day) =>
      on(day).whereType<SeasonEntry>().toList();

  /// Sezon dışı bölümler (boşlar atlanır): toplantılar saate göre, görevlerde bitenler önce.
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
        (
          kind: CalendarKind.sheet,
          entries: list.whereType<SheetEntry>().toList(),
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
