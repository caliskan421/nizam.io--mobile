// calendarIndexProvider: takvim kaynakları + görevler sayfasıyla AYNI görev kataloğu. Katalog
// komutu (görev tamamlandı) takvime yansır; kaynaklar yalnız bir kez yüklenir.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/calendar/application/calendar_index_controller.dart';
import 'package:nizamio/features/calendar/application/calendar_providers.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/tasks/tasks.dart';

final _startsFrom = DateTime(2026, 11);

TaskItem _task(String code, {required DateTime start, TaskStatus? status}) =>
    TaskItem(
      code: code,
      title: 'Görev $code',
      coordinatorship: 'd1',
      status: status ?? TaskStatus.inProgress,
      priority: TaskPriority.medium,
      start: start,
      due: DateTime(2026, 11, 10),
      assignees: const [],
    );

final class _Sources implements CalendarRepository {
  var loads = 0;

  @override
  Future<CalendarSources> load() async {
    loads++;
    return CalendarSources(
      seasons: const [],
      meetings: const [],
      requests: const [],
      sheets: const [],
      taskStartsFrom: _startsFrom,
    );
  }
}

final class _Catalog implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: DateTime(2026, 11, 5, 14),
    me: 'me',
    tasks: [
      _task('w1', start: DateTime(2026, 11, 2)),
      // Başlangıcı kaynak sınırından önce: yalnız bitişi düşer.
      _task('w2', start: DateTime(2026, 10, 1)),
      // Tamamlanmış görev takvime düşmez.
      _task('w3', start: DateTime(2026, 11, 3), status: TaskStatus.done),
    ],
    people: const [],
    coordinatorships: const [],
  );
}

void main() {
  late _Sources sources;
  late ProviderContainer c;
  setUp(() {
    sources = _Sources();
    c = ProviderContainer(
      overrides: [
        calendarRepositoryProvider.overrideWithValue(sources),
        taskCatalogRepositoryProvider.overrideWithValue(_Catalog()),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'p1'),
        ),
      ],
    );
  });
  tearDown(() => c.dispose());

  test('dizin kaynaklar + katalogdan kurulur; bugün kataloğun günü', () async {
    final ix = await c.read(calendarIndexProvider.future);
    expect(ix.today, DateTime(2026, 11, 5));
    expect(ix.count(DateTime(2026, 11, 10)), 2, reason: 'w1 + w2 bitişi');
    expect(ix.count(DateTime(2026, 11, 2)), 1, reason: 'w1 başlangıcı');
    expect(
      ix.count(DateTime(2026, 10)),
      0,
      reason: 'sınırdan önceki başlangıç',
    );
    expect(ix.count(DateTime(2026, 11, 3)), 0, reason: 'biten görev yok');
  });

  test(
    'katalogda görev tamamlanınca takvim güncellenir; kaynak yeniden yüklenmez',
    () async {
      c.listen(calendarIndexProvider, (_, _) {});
      await c.read(calendarIndexProvider.future);
      final w1 = c.read(taskCatalogControllerProvider).value!.task('w1')!;
      c
          .read(taskCatalogControllerProvider.notifier)
          .applyItem('w1', w1.copyWith(status: TaskStatus.done));
      final ix = await c.read(calendarIndexProvider.future);
      expect(ix.count(DateTime(2026, 11, 10)), 1, reason: 'yalnız w2 bitişi');
      expect(ix.count(DateTime(2026, 11, 2)), 0);
      expect(sources.loads, 1);
    },
  );
}
