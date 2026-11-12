import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_selection_card.dart';
import 'package:nizamio/features/timeline/presentation/widgets/timeline_selection_card.dart';

import '../../../../support/harness.dart';
import '../../../coordinatorships/coord_backend.dart';
import '../../../pilot_support.dart';
import '../chart/timeline_fixture.dart';

final _provider = timelineControllerProvider(timelineAllCoordinatorships);

Future<(Harness, CoordBackend, GanttSelection)> _open(
  WidgetTester tester, {
  bool admin = true,
  bool sameDay = false,
}) async {
  final backend = CoordBackend()..admin = admin;
  if (sameDay) {
    final item = backend.workItems.firstWhere(
      (w) => w['work_item_id'] == 'wi-alt-2',
    );
    item['end_on'] = item['start_on'];
  }
  final h = await real(tester, () async {
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    h.container.listen(timelineCatalogProvider, (_, _) {});
    await h.read(taskCatalogControllerProvider.future);
    await h.read(ganttScheduleProvider.future);
    return h;
  });
  final selection = buildGanttView(
    h.read(timelineCatalogProvider).requireValue,
    const GanttState(selected: 'wi-alt-2'),
  ).selection!;
  return (h, backend, selection);
}

Widget _page(GanttSelection selection, {VoidCallback? onClose}) => Scaffold(
  body: Align(
    alignment: Alignment.bottomRight,
    child: SizedBox(
      width: 360,
      child: GanttSelectionCard(
        selection: selection,
        year: 2026,
        onOpen: () {},
        onClose: onClose ?? () {},
      ),
    ),
  ),
);

void main() {
  testWidgets(
    'tablet taslağı yeniden kurulumda korunur; Sıfırla seçimi açık tutar',
    (tester) async {
      final (h, backend, selection) = await _open(tester);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      final current = h.read(_provider).selected;
      expect(current, selection.task.code);
      await tester.tap(find.bySemanticsLabel('bitiş bir gün ileri'));
      await tester.pump();
      final draft = h.read(_provider).draft;
      expect(draft, isNotNull);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      expect(h.read(_provider).draft, draft);
      await tester.tap(find.text('Sıfırla'));
      await tester.pump();
      expect(h.read(_provider).draft, isNull);
      expect(h.read(_provider).selected, current);
      expect(backend.unhandled, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('tablet Kaydet gerçek tarih güncellemesini gönderir ve kapatır', (
    tester,
  ) async {
    final (h, backend, selection) = await _open(tester);
    var closed = false;
    await pumpScreen(tester, h, _page(selection, onClose: () => closed = true));
    await settle(tester);
    final oldDue = h
        .read(timelineCatalogProvider)
        .requireValue
        .task(selection.task.code)!
        .due;
    await tester.tap(find.bySemanticsLabel('bitiş bir gün ileri'));
    await tester.pump();
    await tester.tap(find.text('Kaydet'));
    await settle(tester);
    expect(
      h.backend.count('PATCH', '/v1/work-items/${selection.task.code}'),
      1,
    );
    expect(closed, isTrue);
    expect(
      h
          .read(taskCatalogControllerProvider)
          .requireValue
          .task(selection.task.code)!
          .due,
      oldDue.add(const Duration(days: 1)),
    );
    expect(backend.unhandled, isEmpty);
  });

  testWidgets(
    'tablet Talep gönder koordinatör için gerçek tarih talebi oluşturur',
    (tester) async {
      final (h, backend, selection) = await _open(tester, admin: false);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('bitiş bir gün ileri'));
      await tester.pump();
      await tester.tap(find.text('Talep gönder'));
      await settle(tester);
      expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
      expect(h.read(_provider).draft, isNull);
      expect(h.read(_provider).selected, selection.task.code);
      expect(backend.unhandled, isEmpty);
      // Toast ömrü test sonunda zamanlayıcı bırakmasın.
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'aynı programda departman değişince kart temiz taslakla yeniden açılır',
    (tester) async {
      final (h, backend, selection) = await _open(tester);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('bitiş bir gün ileri'));
      await tester.pump();
      expect(h.read(_provider).draft, isNotNull);
      h.read(scopeControllerProvider).selectDepartment(dEle);
      await settle(tester);
      expect(h.read(_provider).selected, selection.task.code);
      expect(h.read(_provider).draft, isNull);
      expect(find.byType(TimelineSelectionCard), findsOneWidget);
      expect(backend.unhandled, isEmpty);
    },
  );

  testWidgets(
    'eski tarih seçicisi A–B–A seçiminden sonra yeni A taslağına yazmaz',
    (tester) async {
      final (h, backend, selection) = await _open(tester);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      final view = h
          .read(timelineViewProvider(timelineAllCoordinatorships))
          .requireValue;
      final date = seasonDate(view.selection!.draft.end, view.year);
      final pick = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.label?.startsWith('bitiş ') == true &&
            w.properties.label != 'bitiş bir gün ileri' &&
            w.properties.label != 'bitiş bir gün geri',
      );
      await tester.tap(pick.first);
      await settle(tester);
      expect(find.byType(DatePickerDialog), findsOneWidget);
      final other = buildGanttView(
        h.read(timelineCatalogProvider).requireValue,
        const GanttState(selected: 'wi-alt-1'),
      ).selection!;
      await pumpScreen(tester, h, _page(other));
      await settle(tester);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      Navigator.of(tester.element(find.byType(DatePickerDialog)))
          .pop(date.add(const Duration(days: 3)));
      await settle(tester);
      expect(h.read(_provider).selected, selection.task.code);
      expect(h.read(_provider).draft, isNull);
      expect(backend.unhandled, isEmpty);
    },
  );

  testWidgets(
    'tek günlük görevin iki tarih seçicisi de açılır; aynı gün onayı taslak yaratmaz',
    (tester) async {
      final (h, backend, selection) = await _open(tester, sameDay: true);
      await pumpScreen(tester, h, _page(selection));
      await settle(tester);
      final view = h
          .read(timelineViewProvider(timelineAllCoordinatorships))
          .requireValue;
      expect(view.selection!.draft.start, view.selection!.draft.end);
      final date = seasonDate(view.selection!.draft.start, view.year);
      for (final label in ['başlangıç', 'bitiş']) {
        final field = find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label?.startsWith('$label ') == true &&
              w.properties.label != '$label bir gün ileri' &&
              w.properties.label != '$label bir gün geri',
        );
        await tester.tap(field.first);
        await settle(tester);
        expect(find.byType(DatePickerDialog), findsOneWidget);
        Navigator.of(tester.element(find.byType(DatePickerDialog))).pop(date);
        await settle(tester);
        expect(h.read(_provider).draft, isNull);
        expect(tester.takeException(), isNull);
      }
      expect(backend.unhandled, isEmpty);
    },
  );

  testWidgets('erişim bilinmiyorsa tarih yazma düğmeleri kapalıdır', (
    tester,
  ) async {
    final catalog = timelineCatalog(n: 1);
    final selection = timelineViewOf(
      catalog,
      const TimelineState(
        startAll: true,
        selected: 'T0',
        draft: DayRange(0, 8),
      ),
    ).selection!;
    await tester.pumpWidget(
      timelineApp(
        TimelineSelectionCard(
          selection: selection,
          year: 2026,
          bottomInset: 0,
          maxHeight: 700,
          onOpen: () {},
          onClose: () {},
          onNudgeStart: (_) {},
          onNudgeEnd: (_) {},
          onPickStart: () {},
          onPickEnd: () {},
          onShift: (_) {},
          onSave: () {},
          onRequest: () {},
          onRemind: null,
          onReset: () {},
        ),
      ),
    );
    final save = tester.widget<NzButton>(
      find.widgetWithText(NzButton, 'Kaydet'),
    );
    final request = tester.widget<NzButton>(
      find.widgetWithText(NzButton, 'Talep gönder'),
    );
    expect(save.onPressed, isNull);
    expect(request.onPressed, isNull);
  });

  for (final width in [320.0, 390.0, 560.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('seçili görev taşmaz $width / $scale', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final catalog = timelineCatalog(n: 1);
        final selection = timelineViewOf(
          catalog,
          const TimelineState(
            startAll: true,
            selected: 'T0',
            draft: DayRange(-2, 10),
          ),
        ).selection!;
        await tester.pumpWidget(
          timelineApp(
            Align(
              alignment: Alignment.bottomCenter,
              child: TimelineSelectionCard(
                selection: selection,
                year: 2026,
                bottomInset: 20,
                maxHeight: 700,
                canEditDates: true,
                canSave: true,
                canRequest: true,
                onOpen: () {},
                onClose: () {},
                onNudgeStart: (_) {},
                onNudgeEnd: (_) {},
                onPickStart: () {},
                onPickEnd: () {},
                onShift: (_) {},
                onSave: () {},
                onRequest: () {},
                onRemind: null,
                onReset: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
