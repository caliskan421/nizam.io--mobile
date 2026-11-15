import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart';
import 'package:nizamio/features/timeline/presentation/horizontal_timeline_page.dart';
import 'package:nizamio/features/timeline/presentation/mobile/mobile_timeline_chart.dart';
import 'package:nizamio/features/timeline/presentation/timeline_page.dart';
import 'package:nizamio/features/timeline/presentation/widgets/timeline_selection_card.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

void main() {
  setUpFonts();
  for (final tablet in [false, true]) {
    testWidgets(
      'tarih kaydı kartı kapatır; çizelge aynı yerde ve yeni tarihte kalır (tablet=$tablet)',
      (t) async {
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = Size(tablet ? 1180 : 390, tablet ? 700 : 844);
        addTearDown(t.view.reset);
        final backend = CoordBackend();
        final h = await real(t, () async {
          final h = await pilotHarness(backend, signedIn: true);
          h.read(scopeControllerProvider).selectProgram(coordProgram);
          h.container.listen(timelineCatalogProvider, (_, _) {});
          await h.read(taskCatalogControllerProvider.future);
          await h.read(ganttScheduleProvider.future);
          return h;
        });
        final oldDue = h
            .read(taskCatalogControllerProvider)
            .requireValue
            .task(tAltLate30)!
            .due;
        await pumpScreen(
          t,
          h,
          tablet
              ? HorizontalTimelinePage(onBack: () {}, onOpenTask: (_) {})
              : const TimelinePage(),
        );
        await settle(t);
        final chart = find.byType(tablet ? GanttChart : MobileTimelineChart);
        final chartState = t.state(chart);
        final x = t
            .widget<SingleChildScrollView>(
              find.byKey(
                tablet
                    ? GanttChart.horizontalKey
                    : MobileTimelineChart.horizontalKey,
              ),
            )
            .controller!;
        final y = tablet
            ? t
                  .widget<Scrollable>(find.byKey(GanttChart.verticalKey))
                  .controller!
            : t
                  .widget<SingleChildScrollView>(
                    find.byKey(MobileTimelineChart.verticalKey),
                  )
                  .controller!;
        if (tablet) {
          final layout = t.widget<GanttChart>(chart).layout;
          x.jumpTo(
            (layout.barOf(tAltLate30)!.left - 100).clamp(
              0.0,
              x.position.maxScrollExtent,
            ),
          );
          y.jumpTo(20.0.clamp(0.0, y.position.maxScrollExtent));
          await t.pump();
          await t.tap(find.text('İletim hattı yapımı'));
        } else {
          final bar = find.byKey(MobileTimelineChart.barKey(tAltLate30));
          await t.ensureVisible(bar);
          await settle(t);
          await t.tapAt(t.getRect(bar).intersect(t.getRect(chart)).center);
        }
        await settle(t);
        await t.tap(find.bySemanticsLabel('bitiş bir gün ileri'));
        await t.pump();
        final save = find.descendant(
          of: find.byType(TimelineSelectionCard),
          matching: find.text('Kaydet'),
        );
        await t.ensureVisible(save);
        await t.pump();
        final offsets = (x.offset, y.offset);
        // Kaydın ardından katalog ve Gantt yanıtları farklı karelerde tamamlanır.
        h.backend.handler = (request) async {
          if (request.path == '/v1/program/work-items' ||
              request.path.contains('/gantt')) {
            await Future<void>.delayed(const Duration(milliseconds: 60));
          }
          return backend.handle(request);
        };
        await t.tap(save);
        for (var i = 0; i < 30; i++) {
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await t.pump(const Duration(milliseconds: 16));
          expect(
            chart,
            findsOneWidget,
            reason: 'Aynı kapsamda yenileme çizelgeyi sökmemeli.',
          );
          expect(t.state(chart), same(chartState));
          expect((x.offset, y.offset), offsets);
        }
        await settle(t);
        expect(find.byType(TimelineSelectionCard), findsNothing);
        expect(h.backend.count('PATCH', '/v1/work-items/$tAltLate30'), 1);
        final saved = h
            .read(timelineCatalogProvider)
            .requireValue
            .task(tAltLate30)!;
        expect(saved.due, oldDue.add(const Duration(days: 1)));
        if (tablet) {
          final layout = t.widget<GanttChart>(chart).layout;
          final row = layout.boxOf(tAltLate30)!.row as GanttTaskRow;
          // Gantt çubuğu bitiş gününü de içerir; sağ kenarı ertesi gündür.
          expect(row.task.end, seasonDay(saved.due, layout.view.year) + 1);
        } else {
          final view = t.widget<MobileTimelineChart>(chart).view;
          final bar = view.shown.firstWhere((task) => task.code == tAltLate30);
          expect(bar.range.end, seasonDay(saved.due, view.year));
        }
        expect((x.offset, y.offset), offsets);
        expect(t.takeException(), isNull);
      },
    );
  }
}
