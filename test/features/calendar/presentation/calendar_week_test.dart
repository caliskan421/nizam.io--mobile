// CalendarThisWeek: sayaçlar haftanın sayılarını verir ve süzgeçtir ("Devam" varsayılan
// kapalı, gün listesiyle ortak); bölümler gün sırasıyla, gecikende "gecikti".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/calendar/application/calendar_controller.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/calendar/presentation/calendar/calendar_week.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

// Çarşamba: hafta 19–25 Ekim.
final _today = DateTime(2026, 10, 21);

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
    'sayaçlar, bölümler, gecikti; "Devam" sayacı süren görevleri açar',
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
            _task('LATE', DateTime(2026, 10, 1), DateTime(2026, 10, 20)),
            _task('FRI', DateTime(2026, 10, 1), DateTime(2026, 10, 23)),
            _task('SPAN', DateTime(2026, 10, 1), DateTime(2026, 11, 20)),
          ],
          people: const [],
          coordinatorships: const [],
        ),
      );
      await pumpScreen(
        tester,
        h,
        Scaffold(
          body: SingleChildScrollView(child: CalendarThisWeek(index: ix)),
        ),
      );
      expect(find.text('19–25 Eki'), findsOneWidget);
      expect(
        find.bySemanticsLabel('${_l.uiCalendarFilterEnds}, 2'),
        findsOneWidget,
      );
      expect(find.text('${_l.uiCalendarWeekEnds} · 2'), findsOneWidget);
      expect(find.text('Görev LATE'), findsOneWidget);
      expect(find.text(_l.uiCalendarLateLc), findsOneWidget);
      expect(find.text('Görev SPAN'), findsNothing);
      await tester.tap(find.text(_l.uiCalendarStatOngoing));
      await tester.pumpAndSettle();
      expect(find.text('Görev SPAN'), findsOneWidget);
      expect(
        h.read(calendarControllerProvider).taskEdges,
        contains(TaskEdge.ongoing),
      );
      await tester.tap(find.text(_l.uiCalendarFilterEnds));
      await tester.pumpAndSettle();
      expect(find.text('Görev LATE'), findsNothing);
    },
  );

  testWidgets('geniş alanda bölümler yan yana sütunlarda', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1100, 900);
    addTearDown(tester.view.reset);
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
          _task('FRI', DateTime(2026, 10, 1), DateTime(2026, 10, 23)),
          _task('NEW', DateTime(2026, 10, 22), DateTime(2026, 11, 20)),
        ],
        people: const [],
        coordinatorships: const [],
      ),
    );
    await pumpScreen(
      tester,
      h,
      Scaffold(
        body: SingleChildScrollView(child: CalendarThisWeek(index: ix)),
      ),
    );
    final ends = tester.getTopLeft(find.text('${_l.uiCalendarWeekEnds} · 1'));
    final starts = tester.getTopLeft(
      find.text('${_l.uiCalendarWeekStarts} · 1'),
    );
    expect(starts.dx, greaterThan(ends.dx));
    expect(starts.dy, ends.dy);
  });
}
