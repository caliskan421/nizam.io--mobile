// CalendarDay görev süzgeci: sayılı haplar, süren görevler yalnız istenince listelenir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/calendar/application/calendar_controller.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/calendar/presentation/calendar/calendar_day.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

final _l = AppLocalizationsTr();
final _today = DateTime(2026, 11, 5);

TaskItem _task(String code, DateTime start, DateTime due) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: start,
  due: due,
  assignees: const [],
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'süren görevler varsayılan gizli; "Devam eden" açınca listelenir',
    (tester) async {
      final h = await real(
        tester,
        () => pilotHarness(PilotBackend(), signedIn: true),
      );
      final ix = CalendarIndex.build(
        const [],
        TaskCatalog(
          today: _today,
          me: 'me',
          tasks: [
            _task('END', DateTime(2026, 11, 1), _today),
            _task('RUN', DateTime(2026, 11, 1), DateTime(2026, 11, 9)),
          ],
          people: const [],
          coordinatorships: const [],
        ),
      );
      await pumpScreen(
        tester,
        h,
        Scaffold(
          body: SingleChildScrollView(child: CalendarDay(index: ix)),
        ),
      );
      expect(find.text('Görev END'), findsOneWidget);
      expect(find.text('Görev RUN'), findsNothing);
      expect(
        find.bySemanticsLabel('${_l.uiCalendarFilterOngoing}, 1'),
        findsOneWidget,
      );
      await tester.tap(find.text(_l.uiCalendarFilterOngoing));
      await tester.pumpAndSettle();
      expect(find.text('Görev RUN'), findsOneWidget);
      expect(
        h.read(calendarControllerProvider).taskEdges,
        contains(TaskEdge.ongoing),
      );
      // "Bitecek" kapatılınca bitiş satırı gizlenir.
      await tester.tap(find.text(_l.uiCalendarFilterEnds));
      await tester.pumpAndSettle();
      expect(find.text('Görev END'), findsNothing);
    },
  );

  testWidgets('boş gün: metin yalnız verilirse; ekleme düğmesi yok', (
    tester,
  ) async {
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    final ix = CalendarIndex.build(
      const [],
      TaskCatalog(
        today: _today,
        me: 'me',
        tasks: const [],
        people: const [],
        coordinatorships: const [],
      ),
    );
    await pumpScreen(
      tester,
      h,
      Scaffold(
        body: SingleChildScrollView(child: CalendarDay(index: ix)),
      ),
    );
    expect(find.text(_l.uiCalendarEmpty), findsNothing);
    expect(find.text(_l.uiCalendarPlan), findsNothing);
    await pumpScreen(
      tester,
      h,
      Scaffold(
        body: SingleChildScrollView(
          child: CalendarDay(index: ix, emptyMessage: _l.uiCalendarEmpty),
        ),
      ),
    );
    expect(find.text(_l.uiCalendarEmpty), findsOneWidget);
  });
}
