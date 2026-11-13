// CalendarPeriods: geçen hafta tamamlanan/bitişi düşen, bugün ve gelecek hafta toplamı;
// dokunuş dönemin kayıtlarını pencerede açar (tamamlandı/gecikti rozeti, satır kaydı açar).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/widgets/overlays/overlays.dart';
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

  testWidgets(
    'oran, sayı satırları (devam eden dahil); dokunuş pencereyi açar',
    (tester) async {
      final handle = tester.ensureSemantics();
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
            _task('S', DateTime(2026, 10, 1), DateTime(2026, 11, 20)),
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
      // Geçen hafta (12–18 Eki): bitişi düşen D (tamamlandı) ve L (gecikti) → %50; T ve S
      // hafta boyunca sürer. Bugün: T biter, S sürer. Gelecek hafta: N başlar, S sürer.
      expect(find.text('%50'), findsOneWidget);
      expect(find.text(_l.uiCalendarRingDone), findsOneWidget);
      String card(String label, List<(String, int)> rows) =>
          [label, for (final (k, n) in rows) '$k $n'].join('.*');
      expect(
        find.bySemanticsLabel(
          RegExp(
            card(_l.uiCalendarLastWeek, [
              (_l.uiCalendarLegendDone, 1),
              (_l.uiCalendarLegendLate, 1),
              (_l.uiCalendarLegendStarted, 0),
              (_l.uiCalendarLegendOngoing, 2),
            ]),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          RegExp(
            card(_l.uiCalendarToday, [
              (_l.uiCalendarLegendEnds, 1),
              (_l.uiCalendarLegendStarts, 0),
              (_l.uiCalendarLegendOngoing, 1),
            ]),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          RegExp(
            card(_l.uiCalendarNextWeekCard, [
              (_l.uiCalendarLegendEnds, 0),
              (_l.uiCalendarLegendStarts, 1),
              (_l.uiCalendarLegendOngoing, 1),
            ]),
          ),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(_l.uiCalendarLastWeek));
      await tester.pumpAndSettle();
      // Açılır satırlar: ilk bölüm (Bitiş) açık başlar, sağda sayısı.
      expect(find.text(_l.uiCalendarSecEnds), findsOneWidget);
      expect(find.text('Görev D'), findsOneWidget);
      // Karttaki halka da "tamamlandı" yazar; rozet pencerenin içinde aranır.
      expect(
        find.descendant(
          of: find.byType(NzBottomSheetContent),
          matching: find.text(_l.uiCalendarDoneLc),
        ),
        findsOneWidget,
      );
      expect(find.text('Görev L'), findsOneWidget);
      expect(find.text(_l.uiCalendarLateLc), findsOneWidget);
      // Bu dönemin dışındaki görev pencerede yok.
      expect(find.text('Görev N'), findsNothing);
      handle.dispose();
    },
  );
}
