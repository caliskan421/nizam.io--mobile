import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_error_state.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_skeleton.dart';
import 'package:nizamio/features/scope/presentation/home/home_overview.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../../../support/recording_app_nav.dart';

class _Catalog implements TaskCatalogRepository {
  final pending = Completer<TaskCatalog>();
  @override
  Future<TaskCatalog> load() => pending.future;
}

TaskCatalog _empty({bool truncated = false}) => TaskCatalog(
  today: DateTime(2026),
  me: 'me',
  tasks: const [],
  people: const [],
  coordinatorships: const [],
  truncated: truncated,
);

TaskCatalog _populated() {
  final now = DateTime(2026);
  return TaskCatalog(
    today: now,
    me: 'me',
    people: const [],
    coordinatorships: const [],
    tasks: [
      for (final (i, status) in TaskStatus.values.indexed)
        TaskItem(
          code: '$i',
          title: '$i',
          coordinatorship: 'd',
          status: status,
          priority: TaskPriority.medium,
          start: now,
          due: now,
          assignees: const [],
        ),
    ],
  );
}

void main() {
  setUpFonts();
  test(
    'durumlar tek kez sayılır; bilinmeyen kaybolmaz ve boş toplam sıfırdır',
    () {
      final counts = homeOverviewCounts([
        TaskStatus.done,
        TaskStatus.review,
        TaskStatus.inProgress,
        TaskStatus.returned,
        TaskStatus.todo,
        TaskStatus.unknown,
        TaskStatus.done,
      ]);
      expect(counts[TaskStatus.done], 2);
      expect(counts[TaskStatus.inProgress], 2);
      expect(counts[TaskStatus.returned], 0);
      expect(counts.values.reduce((a, b) => a + b), 7);
      expect(homeOverviewCounts(const []).values.every((n) => n == 0), isTrue);
    },
  );

  testWidgets('yükleme ve boş kesik katalog gerçek değerleri gösterir', (
    tester,
  ) async {
    final repo = _Catalog();
    final nav = RecordingAppNav();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionGenerationProvider.overrideWithValue(1),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
          taskCatalogRepositoryProvider.overrideWithValue(repo),
        ],
        child: testApp(NzAppNavScope(nav: nav, child: const HomeOverview())),
      ),
    );
    expect(find.byType(NzSkeleton), findsOneWidget);
    repo.pending.complete(_empty(truncated: true));
    await tester.pumpAndSettle();
    expect(find.text('≥0'), findsOneWidget);
    expect(
      find.text('Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.'),
      findsOneWidget,
    );
    expect(find.text('Genel durum'), findsOneWidget);
    expect(find.text('Görevler'), findsNothing);
    await tester.tap(find.bySemanticsLabel(RegExp('≥0 görev')));
    expect(nav.calls, ['tasks']);
  });
  testWidgets(
    'gerçek durum dağılımı telefon ve tablette okunur ve halka gezinir',
    (tester) async {
      final repo = _Catalog()..pending.complete(_populated());
      final nav = RecordingAppNav();
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 800);
      addTearDown(tester.view.reset);
      Widget app(Size size) => ProviderScope(
        overrides: [
          sessionGenerationProvider.overrideWithValue(1),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
          taskCatalogRepositoryProvider.overrideWithValue(repo),
        ],
        child: testApp(
          NzAppNavScope(
            nav: nav,
            child: MediaQuery(
              data: MediaQueryData(
                size: size,
                textScaler: const TextScaler.linear(2),
              ),
              child: const HomeOverview(),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app(const Size(320, 800)));
      await tester.pumpAndSettle();
      expect(find.text('6'), findsOneWidget);
      expect(find.text('Tamamlandı'), findsOneWidget);
      expect(find.text('Diğer'), findsOneWidget);
      expect(find.text('Geri gönderildi'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Devam ediyor 2')), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('6 görev:.*Tamamlandı 1.*Diğer 1')),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel(RegExp('6 görev:.*Tamamlandı 1')));
      expect(nav.calls, ['tasks']);
      tester.view.physicalSize = const Size(760, 1000);
      await tester.pumpWidget(app(const Size(760, 1000)));
      await tester.pumpAndSettle();
      expect(find.text('Genel durum'), findsOneWidget);
      final done = tester.getTopLeft(find.text('Tamamlandı'));
      final doing = tester.getTopLeft(find.text('Devam ediyor'));
      expect(doing.dy, greaterThanOrEqualTo(done.dy));
      expect(find.text('Görevler'), findsNothing);
    },
  );
  testWidgets('katalog hatası durumunda eski sayı yerine hata görünür', (
    tester,
  ) async {
    final repo = _Catalog();
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          sessionGenerationProvider.overrideWithValue(1),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
          taskCatalogRepositoryProvider.overrideWithValue(repo),
        ],
        child: testApp(
          NzAppNavScope(nav: RecordingAppNav(), child: const HomeOverview()),
        ),
      ),
    );
    repo.pending.completeError(StateError('failed'));
    await tester.pumpAndSettle();
    expect(find.byType(NzErrorState), findsOneWidget);
    expect(find.text('Genel durum'), findsNothing);
  });
}
