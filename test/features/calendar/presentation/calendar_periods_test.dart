// CalendarPeriods: geçen hafta tamamlanan/bitişi düşen, bugün ve gelecek hafta toplamı;
// dokunuş dönemin kayıtlarını pencerede açar (tamamlandı/gecikti rozeti, satır kaydı açar).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/calendar/presentation/calendar/calendar_periods.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

// Çarşamba 21 Ekim: geçen hafta 12–18, gelecek hafta 26 Eki – 1 Kas.
final _today = DateTime(2026, 10, 21);

TaskItem _task(
  String code,
  DateTime start,
  DateTime due, {
  TaskStatus status = TaskStatus.inProgress,
}) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: 'd1',
  status: status,
  priority: TaskPriority.medium,
  start: start,
  due: due,
  assignees: const [],
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('sayılar; dokunuş dönem penceresini açar', (tester) async {
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
          _task(
            'D',
            DateTime(2026, 10, 1),
            DateTime(2026, 10, 14),
            status: TaskStatus.done,
          ),
          _task('L', DateTime(2026, 10, 1), DateTime(2026, 10, 16)),
          _task('T', DateTime(2026, 10, 1), _today),
          _task('N', DateTime(2026, 10, 27), DateTime(2026, 11, 20)),
        ],
        people: const [],
        coordinatorships: const [],
      ),
    );
    await pumpScreen(
      tester,
      h,
      Scaffold(
        body: SingleChildScrollView(child: CalendarPeriods(index: ix)),
      ),
    );
    expect(find.text('1/2'), findsOneWidget);
    expect(
      find.text(
        '1 ${_l.uiCalendarDoneLc} · 1 ${_l.uiCalendarLateLc} · '
        '0 ${_l.uiCalendarMeetingLc}',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        '1 ${_l.uiCalendarLeadEnd} · 0 ${_l.uiCalendarLeadStart} · '
        '0 ${_l.uiCalendarMeetingLc}',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text(_l.uiCalendarLastWeek));
    await tester.pumpAndSettle();
    expect(find.text('${_l.uiCalendarSecEnds} · 2'), findsOneWidget);
    expect(find.text('Görev D'), findsOneWidget);
    expect(find.text(_l.uiCalendarDoneLc), findsOneWidget);
    expect(find.text('Görev L'), findsOneWidget);
    expect(find.text(_l.uiCalendarLateLc), findsOneWidget);
    // Bu dönemin dışındaki görev pencerede yok.
    expect(find.text('Görev N'), findsNothing);
  });
}
