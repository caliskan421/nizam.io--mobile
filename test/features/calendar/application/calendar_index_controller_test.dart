// calendarIndexProvider: kaynaklar + görevler sayfasıyla aynı görev kataloğu; katalog
// komutları takvime yansır, kaynak bir kez yüklenir.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/application/calendar_index_controller.dart';
import 'package:nizamio/features/calendar/application/calendar_providers.dart';
import 'package:nizamio/features/calendar/data/sample/sample_calendar_repository.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/tasks/data/sample/sample_task_catalog_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

final class _Counting implements CalendarRepository {
  var loads = 0;

  @override
  Future<CalendarSources> load() {
    loads++;
    return const SampleCalendarRepository().load();
  }
}

void main() {
  late _Counting repo;
  late ProviderContainer c;
  setUp(() {
    repo = _Counting();
    c = ProviderContainer(
      overrides: [
        calendarRepositoryProvider.overrideWithValue(repo),
        taskCatalogRepositoryProvider.overrideWithValue(
          SampleTaskCatalogRepository(),
        ),
      ],
    );
  });
  tearDown(() => c.dispose());

  test('dizin kurulur; bugün kataloğun bugünü', () async {
    final ix = await c.read(calendarIndexProvider.future);
    expect(ix.today, DateTime(2026, 10, 21));
    expect(ix.count(DateTime(2026, 10, 29)), 5);
  });

  test(
    'görev kaldırılınca takvim güncellenir; kaynak yeniden yüklenmez',
    () async {
      c.listen(calendarIndexProvider, (_, _) {});
      await c.read(calendarIndexProvider.future);
      c.read(taskCatalogControllerProvider.notifier).remove('SİS-1');
      final ix = await c.read(calendarIndexProvider.future);
      expect(ix.count(DateTime(2026, 10, 29)), 4);
      expect(repo.loads, 1);
    },
  );
}
