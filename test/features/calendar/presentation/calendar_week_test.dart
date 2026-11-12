// CalendarWeekAhead: yalnız kaydı olan günler, gün başına üç kayıt + "+N daha", gün bloğu
// günü seçer, boş haftada kısa metin.
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

// Çarşamba: hafta 21–25 Ekim.
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

CalendarIndex _index(List<TaskItem> tasks) => CalendarIndex.build(
  const [],
  TaskCatalog(
    today: _today,
    me: 'me',
    tasks: tasks,
    people: const [],
    coordinatorships: const [],
  ),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('kaydı olan günler; fazlası "+N daha"; gün bloğu günü seçer', (
    tester,
  ) async {
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    final fri = DateTime(2026, 10, 23);
    final ix = _index([
      for (final c in ['A', 'B', 'C', 'D'])
        _task(c, DateTime(2026, 10, 1), fri),
      // Haftanın dışında: görünmez.
      _task('X', DateTime(2026, 10, 1), DateTime(2026, 10, 28)),
    ]);
    await pumpScreen(
      tester,
      h,
      Scaffold(
        body: SingleChildScrollView(child: CalendarWeekAhead(index: ix)),
      ),
    );
    expect(find.text('${_l.uiCalendarWeekAhead} · 4'), findsOneWidget);
    expect(find.text('Görev A'), findsOneWidget);
    expect(find.text('Görev D'), findsNothing);
    expect(find.text('Görev X'), findsNothing);
    expect(find.text('+1 ${_l.uiCalendarMoreLc}'), findsOneWidget);
    await tester.tap(find.text('23'));
    expect(h.read(calendarControllerProvider).selectedOn(_today), fri);
  });

  testWidgets('boş hafta kısa metin', (tester) async {
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(
      tester,
      h,
      Scaffold(body: CalendarWeekAhead(index: _index(const []))),
    );
    expect(find.text(_l.uiCalendarWeekAheadEmpty), findsOneWidget);
  });
}
