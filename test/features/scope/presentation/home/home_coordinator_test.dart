import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting_board.dart';
import 'package:nizamio/features/scope/presentation/home/home_coordinator.dart';
import 'package:nizamio/features/scope/presentation/home/home_sections.dart';
import 'package:nizamio/features/scope/presentation/home/home_wide.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../../../support/recording_app_nav.dart';
import '../../../../support/screen_matrix.dart';

class _Catalog implements TaskCatalogRepository {
  _Catalog(this.catalog);
  final TaskCatalog catalog;
  @override
  Future<TaskCatalog> load() async => catalog;
}

class _NoMeetings extends MeetingsBoardController {
  @override
  Future<MeetingsBoard> build() async => MeetingsBoard(visible: const []);
}

final _today = DateTime(2026, 11, 14);

TaskItem _task(String code, TaskStatus status, {List<String>? to}) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: 'd1',
  departmentId: 'd1',
  status: status,
  priority: TaskPriority.medium,
  start: _today,
  due: _today.add(const Duration(days: 3)),
  assignees: to ?? const ['p1'],
);

final _catalog = TaskCatalog(
  today: _today,
  me: 'p1',
  people: const [Person(id: 'p1', name: 'Ayşe Kaya', role: PersonRole.member)],
  coordinatorships: const [
    CoordinatorshipRef(
      code: 'd1',
      name: 'Altyapı ve tesisat',
      leads: ['p1'],
      members: [],
    ),
  ],
  tasks: [
    _task('a', TaskStatus.review),
    _task('b', TaskStatus.inProgress),
    _task('c', TaskStatus.todo, to: const []),
    _task('d', TaskStatus.done),
  ],
);

void main() {
  setUpFonts();

  testScreens(
    'koordinatör ana sayfası taşmadan çizilir; bekleyen işler sekmeleri '
    'değişir',
    (tester, screen) async {
      final board = CoordinatorBoard(
        departmentId: 'd1',
        departmentName: 'Altyapı ve tesisat',
        tasks: _catalog.tasks,
        truncated: false,
      );
      final wide = screen.size.width >= homeWideMinWidth;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionGenerationProvider.overrideWithValue(1),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p'),
            ),
            taskCatalogRepositoryProvider.overrideWithValue(_Catalog(_catalog)),
            coordinatorBoardProvider.overrideWith((ref) => board),
            myDateRequestsProvider.overrideWith((ref) async => const []),
            meetingsBoardControllerProvider.overrideWith(_NoMeetings.new),
          ],
          child: testApp(
            NzAppNavScope(
              nav: RecordingAppNav(),
              child: SingleChildScrollView(
                child: HomeCoordinatorFeed(
                  wide: wide,
                  quick: HomeQuickActionsBar(
                    onAction: (_) {},
                    actions: const [
                      HomeQuickAction.newTask,
                      HomeQuickAction.meeting,
                      HomeQuickAction.member,
                      HomeQuickAction.report,
                    ],
                    title: wide ? 'Hızlı işlemler' : null,
                    columns: wide ? 2 : 0,
                    tileAspect: null,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Altyapı ve tesisat'), findsOneWidget);
      expect(find.text('Bekleyen işler'), findsOneWidget);
      expect(find.text('Görev a'), findsOneWidget);
      expect(find.text('Görev c'), findsNothing);
      await tester.tap(find.bySemanticsLabel('Atanmamış 1'));
      await tester.pumpAndSettle();
      expect(find.text('Görev c'), findsOneWidget);
      expect(find.text('Görev a'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
