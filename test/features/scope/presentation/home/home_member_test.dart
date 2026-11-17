import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting_board.dart';
import 'package:nizamio/features/scope/application/member_home.dart';
import 'package:nizamio/features/scope/presentation/home/home_member.dart';
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

  testScreens('üye ana sayfası taşmadan çizilir; özet kutusu listeyi açar', (
    tester,
    screen,
  ) async {
    final home = memberHome([
      _task('a', TaskStatus.review),
      _task('b', TaskStatus.inProgress),
      _task('r', TaskStatus.returned),
      _task('d', TaskStatus.done),
    ]);
    final nav = RecordingAppNav();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionGenerationProvider.overrideWithValue(1),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p'),
          ),
          taskCatalogRepositoryProvider.overrideWithValue(_Catalog(_catalog)),
          memberHomeProvider.overrideWith((ref) => home),
          meetingsBoardControllerProvider.overrideWith(_NoMeetings.new),
        ],
        child: testApp(
          NzAppNavScope(
            nav: nav,
            child: SingleChildScrollView(
              child: HomeMemberFeed(
                wide: screen.size.width >= homeWideMinWidth,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Nokta çipleri yok; dört özet kutusu var.
    final l = AppLocalizationsTr();
    for (final (label, view) in [
      (l.uiHomeKpiLate, 'late'),
      (l.uiHomeKpiReview, 'review'),
      (l.uiTasksViewReturned, 'returned'),
      (l.uiHomeKpiDone, 'done'),
    ]) {
      final tile = find.bySemanticsLabel(RegExp('^${RegExp.escape(label)}:'));
      expect(tile, findsOneWidget);
      await tester.ensureVisible(tile);
      await tester.pumpAndSettle();
      await tester.tap(tile);
      expect(nav.calls.last, 'tasks:$view');
    }
    final allMeetings = find.text(l.uiHomeSeeAll);
    await tester.ensureVisible(allMeetings);
    await tester.pumpAndSettle();
    await tester.tap(allMeetings);
    expect(nav.calls.last, 'meetings');
    expect(tester.takeException(), isNull);
  });
}
