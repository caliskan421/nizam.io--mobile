// Takvim kuralları: ay ızgarası, hafta sırası, gün dizini (referans ekranın hücre sayıları),
// bölüm sırası, görevlerden türetilen kayıtlar.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/data/sample/sample_calendar_repository.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

/// Görevsiz katalog (görev örnek verisi kaldırıldı); takvim kaynakları modül örneğinden.
final _catalog = TaskCatalog(
  today: DateTime(2026, 10, 21),
  me: 'me',
  tasks: const [],
  people: const [],
  coordinatorships: const [],
);

Future<CalendarIndex> _index() async => CalendarIndex.build(
  await const SampleCalendarRepository().load(),
  _catalog,
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

  test('sezon günü: sezon şeridi ayrı, bölümlere girmez; boş gün', () async {
    final ix = await _index();
    final d = DateTime(2026, 10, 26);
    expect(ix.seasons(d).single.title, 'Saha teslimi');
    expect(ix.groups(d).every((g) => g.kind != CalendarKind.season), isTrue);
    expect(ix.kinds(d).first, CalendarKind.season);
    expect(ix.groups(DateTime(2026, 10, 6)), isEmpty);
    expect(ix.on(DateTime(2026, 10, 6)), isEmpty);
  });
}
