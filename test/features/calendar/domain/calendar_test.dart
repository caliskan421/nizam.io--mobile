// Takvim kuralları: ay ızgarası, hafta sırası, gün dizini (referans ekranın hücre sayıları),
// bölüm sırası, görevlerden türetilen kayıtlar.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/data/sample/sample_calendar_repository.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/tasks/data/sample/sample_task_catalog_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

Future<CalendarIndex> _index() async => CalendarIndex.build(
  await const SampleCalendarRepository().load(),
  await SampleTaskCatalogRepository().load(),
);

void main() {
  test('Ekim 2026 ızgarası 28 Eylül – 1 Kasım, 5 satır, pazartesi başlar', () {
    final w = monthWeeks(DateTime(2026, 10));
    expect(w, hasLength(5));
    expect(w.first.first, DateTime(2026, 9, 28));
    expect(w.last.last, DateTime(2026, 11));
    expect(w.every((r) => r.first.weekday == DateTime.monday), isTrue);
    // Şubat 2027 pazartesi başlar, 28 gün → 4 satır; Ağustos 2026 → 6 satır.
    expect(monthWeeks(DateTime(2027, 2)), hasLength(4));
    expect(monthWeeks(DateTime(2026, 8)), hasLength(6));
  });

  test('hafta sırası ve gün farkı', () {
    final m = DateTime(2026, 10);
    expect(weekIndexOf(DateTime(2026, 10, 21), m), 3);
    expect(weekIndexOf(DateTime(2026, 10), m), 0);
    expect(weekIndexOf(DateTime(2026, 10, 31), m), 4);
    expect(calendarDiff(DateTime(2026, 10, 29), DateTime(2026, 10, 21)), 8);
    expect(calendarDiff(DateTime(2026, 10, 19), DateTime(2026, 10, 21)), -2);
  });

  test('hücre sayıları referans ekranla aynı (calendar.ax)', () async {
    final ix = await _index();
    expect(ix.today, DateTime(2026, 10, 21));
    const expected = {
      '9-28': 0, '9-29': 0, '9-30': 1, '10-1': 4, '10-2': 0, '10-3': 0, //
      '10-4': 1, '10-5': 3, '10-6': 0, '10-7': 0, '10-8': 3, '10-9': 0,
      '10-10': 3, '10-11': 0, '10-12': 2, '10-13': 0, '10-14': 0,
      '10-15': 2, '10-16': 1, '10-17': 0, '10-18': 0, '10-19': 3,
      '10-20': 2, '10-21': 4, '10-22': 1, '10-23': 4, '10-24': 1,
      '10-25': 1, '10-26': 3, '10-27': 3, '10-28': 3, '10-29': 5,
      '10-30': 3, '10-31': 1, '11-1': 2,
    };
    for (final MapEntry(:key, :value) in expected.entries) {
      final [m, d] = key.split('-').map(int.parse).toList();
      expect(ix.count(DateTime(2026, m, d)), value, reason: key);
    }
  });

  test(
    '21 Ekim: toplantılar saate göre, talep, tablo kaydı; görev yok',
    () async {
      final ix = await _index();
      final g = ix.groups(DateTime(2026, 10, 21));
      expect(g.map((x) => x.kind), [
        CalendarKind.meeting,
        CalendarKind.request,
        CalendarKind.sheet,
      ]);
      final meetings = g.first.entries.cast<MeetingEntry>();
      expect(meetings.map((m) => m.title), [
        'Hidrofor teslim kontrolü',
        'Konaklama ve servis planı',
      ]);
      expect(meetings.first.coordinatorships, ['ALT']);
      expect(meetings.first.participants, 6);
      expect(meetings.first.agenda, hasLength(3));
      final req = g[1].entries.single as RequestEntry;
      expect(req.id, 'ST-107');
      expect(req.state, RequestState.delivered);
      expect(req.taskCode, 'ALT-7');
      final sheet = g[2].entries.single as SheetEntry;
      expect(sheet.label, 'Jeneratör yakıt dolumu');
      expect(ix.personName(sheet.person), isNotEmpty);
      expect(ix.coordinatorshipName('ELE'), 'Elektrik ve enerji');
      expect(ix.kinds(DateTime(2026, 10, 21)), [
        CalendarKind.meeting,
        CalendarKind.request,
        CalendarKind.sheet,
      ]);
    },
  );

  test('29 Ekim: görevlerde bitenler önce, başlayanlar sonra', () async {
    final ix = await _index();
    final tasks = ix
        .groups(DateTime(2026, 10, 29))
        .firstWhere((g) => g.kind == CalendarKind.task)
        .entries
        .cast<TaskEntry>()
        .toList();
    expect(tasks.map((t) => (t.code, t.edge)), [
      ('SİS-1', TaskEdge.end),
      ('SAT-6', TaskEdge.end),
      ('OPE-7', TaskEdge.start),
    ]);
    expect(tasks.every((t) => !t.late), isTrue);
  });

  test(
    'geçmişte biten görev "gecikti"; eylül öncesi başlangıç düşmez',
    () async {
      final ix = await _index();
      final sep30 = ix.on(DateTime(2026, 9, 30)).single as TaskEntry;
      expect(sep30.code, 'ALT-10');
      expect(sep30.edge, TaskEdge.end);
      expect(sep30.late, isTrue);
      // ALT-10 07-07'de başlar: başlangıcı takvimde yok.
      expect(
        ix
            .on(DateTime(2026, 7, 7))
            .whereType<TaskEntry>()
            .where((t) => t.code == 'ALT-10'),
        isEmpty,
      );
    },
  );

  test('sezon günü: sezon şeridi ayrı, bölümlere girmez; boş gün', () async {
    final ix = await _index();
    final d = DateTime(2026, 10, 26);
    expect(ix.seasons(d).single.title, 'Saha teslimi');
    expect(ix.groups(d).every((g) => g.kind != CalendarKind.season), isTrue);
    expect(ix.kinds(d).first, CalendarKind.season);
    expect(ix.groups(DateTime(2026, 10, 6)), isEmpty);
    expect(ix.on(DateTime(2026, 10, 6)), isEmpty);
  });

  test(
    'bitmiş görev takvime düşmez; katalog değişince dizin değişir',
    () async {
      final sources = await const SampleCalendarRepository().load();
      final catalog = await SampleTaskCatalogRepository().load();
      final done = catalog.task('SİS-1')!.copyWith(status: TaskStatus.done);
      final ix = CalendarIndex.build(
        sources,
        catalog.withTasks([
          for (final t in catalog.tasks) t.code == 'SİS-1' ? done : t,
        ]),
      );
      expect(ix.count(DateTime(2026, 10, 29)), 4);
    },
  );
}
