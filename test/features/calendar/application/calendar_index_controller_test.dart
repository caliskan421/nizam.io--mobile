// calendarIndexProvider: toplantılar sayfasıyla AYNI toplantı listesi (bütün sayfalar) +
// görevler sayfasıyla AYNI görev kataloğu. Katalog komutu takvime yansır; toplantı listesi
// yalnız bir kez okunur; kaynaklardan biri hata verirse dizin de hata verir (kısmi veri yok).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/calendar/application/calendar_index_controller.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meetings_repository.dart';
import 'package:nizamio/features/meetings/meetings.dart';
import 'package:nizamio/features/tasks/tasks.dart';

Meeting _meeting(String id, DateTime at) => Meeting(
  id: id,
  programId: 'p1',
  ownerDepartmentId: 'd1',
  title: 'Toplantı $id',
  meetingDate: at,
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.admin,
  createdAt: at,
  updatedAt: at,
  departments: const [MeetingDepartment(id: 'd1', name: 'Altyapı')],
);

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

/// `listMeetings` sayfaları (imleç sayfa sırası); [error] doluysa her çağrı düşer.
final class _Meetings implements MeetingsRepository {
  _Meetings(this.pages);

  final List<List<Meeting>> pages;
  ApiError? error;
  var calls = 0;

  @override
  Future<PageSlice<Meeting>> listMeetings([
    PageRequest page = const PageRequest(),
  ]) async {
    calls++;
    if (error case final e?) throw e;
    final i = int.parse(page.cursor ?? '0');
    return PageSlice(
      items: pages[i],
      nextCursor: i + 1 < pages.length ? '${i + 1}' : null,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('${invocation.memberName}');
}

final class _Catalog implements TaskCatalogRepository {
  _Catalog({this.truncated = false});

  final bool truncated;

  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    truncated: truncated,
    today: DateTime(2026, 11, 5, 14),
    me: 'me',
    tasks: [
      _task('w1', start: DateTime(2026, 11, 2)),
      _task('w2', start: DateTime(2026, 10, 1)),
      // Tamamlanmış görev takvime düşmez.
      _task('w3', start: DateTime(2026, 11, 3), status: TaskStatus.done),
    ],
    people: const [],
    coordinatorships: const [],
  );
}

ProviderContainer _container(_Meetings meetings, _Catalog catalog) =>
    ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        meetingsRepositoryProvider.overrideWithValue(meetings),
        taskCatalogRepositoryProvider.overrideWithValue(catalog),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'p1'),
        ),
      ],
    );

void main() {
  late _Meetings meetings;
  late ProviderContainer c;
  setUp(() {
    meetings = _Meetings([
      [_meeting('m1', DateTime(2026, 11, 2, 9))],
      [_meeting('m2', DateTime(2026, 11, 10, 14))],
    ]);
    c = _container(meetings, _Catalog());
  });
  tearDown(() => c.dispose());

  test('dizin bütün toplantı sayfaları + katalogdan kurulur', () async {
    final ix = await c.read(calendarIndexProvider.future);
    expect(meetings.calls, 2, reason: 'iki sayfa');
    expect(ix.today, DateTime(2026, 11, 5));
    expect(ix.count(DateTime(2026, 11, 10)), 3, reason: 'm2 + w1/w2 bitişi');
    expect(ix.count(DateTime(2026, 11, 2)), 2, reason: 'm1 + w1 başlangıcı');
    expect(ix.count(DateTime(2026, 10)), 1, reason: 'w2 başlangıcı (eşik yok)');
    expect(ix.count(DateTime(2026, 11, 3)), 0, reason: 'biten görev yok');
    expect(ix.truncated, isFalse);
    expect(
      ix.groups(DateTime(2026, 11, 2)).first.entries.single,
      isA<MeetingEntry>().having((m) => m.id, 'id', 'm1'),
    );
  });

  test('katalogda görev tamamlanınca takvim güncellenir; toplantılar yeniden okunmaz', () async {
    c.listen(calendarIndexProvider, (_, _) {});
    await c.read(calendarIndexProvider.future);
    final w1 = c.read(taskCatalogControllerProvider).value!.task('w1')!;
    c
        .read(taskCatalogControllerProvider.notifier)
        .applyItem('w1', w1.copyWith(status: TaskStatus.done));
    final ix = await c.read(calendarIndexProvider.future);
    expect(ix.count(DateTime(2026, 11, 10)), 2, reason: 'm2 + w2 bitişi');
    expect(ix.count(DateTime(2026, 11, 2)), 1, reason: 'yalnız m1');
    expect(meetings.calls, 2);
  });

  test('toplantı listesi hata verirse dizin hata verir (kısmi veri yok)', () async {
    meetings.error = ApiError('platform.internal', status: 500);
    c.listen(calendarIndexProvider, (_, _) {});
    await expectLater(
      c.read(calendarIndexProvider.future),
      throwsA(isA<ApiError>()),
    );
    expect(c.read(calendarIndexProvider).hasError, isTrue);

    // Yeniden deneme: hata veren kaynak geçersizlenince dizin yeniden kurulur.
    meetings.error = null;
    c.invalidate(meetingsBoardControllerProvider);
    final ix = await c.read(calendarIndexProvider.future);
    expect(ix.count(DateTime(2026, 11, 2)), 2);
  });

  // Codex tur 1 / 8: kesik kaynak takvimde sessizce tam veri gibi görünmez.
  test('kesilme bilgisi takvim durumuna geçer (toplantı listesi ya da katalog)', () async {
    final cat = _container(meetings, _Catalog(truncated: true));
    addTearDown(cat.dispose);
    expect((await cat.read(calendarIndexProvider.future)).truncated, isTrue);

    // Toplantı listesi sayfa tavanında kesildi (her sayfa devam imleci taşır).
    final capped = _Meetings([
      for (var i = 0; i <= MeetingsBoardController.maxPages; i++)
        [_meeting('m$i', DateTime(2026, 11, 2, 9))],
    ]);
    final mc = _container(capped, _Catalog());
    addTearDown(mc.dispose);
    final ix = await mc.read(calendarIndexProvider.future);
    expect(capped.calls, MeetingsBoardController.maxPages);
    expect(ix.truncated, isTrue);
  });
}
