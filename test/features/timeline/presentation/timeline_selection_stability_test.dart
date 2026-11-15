import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
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
      'görev seçilince çizelge ve seçim kartı sabit kalır (tablet=$tablet)',
      (t) async {
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = Size(tablet ? 1376 : 390, tablet ? 1032 : 844);
        addTearDown(t.view.reset);
        final backend = CoordBackend();
        final h = await real(t, () async {
          final h = await pilotHarness(backend, signedIn: true);
          h.read(scopeControllerProvider).selectProgram(coordProgram);
          h.container.listen(timelineCatalogProvider, (_, _) {});
          await h.read(taskCatalogControllerProvider.future);
          await h.read(ganttScheduleProvider.future);
          // Gerçek ağda Gantt yanıtı bir sonraki kareye kalır; anlık sahte yanıt
          // seçimin sökülüp yeniden kurulmasını gizlememeli.
          h.backend.handler = (request) async {
            if (request.path.contains('/gantt')) {
              await Future<void>.delayed(const Duration(milliseconds: 60));
            }
            return backend.handle(request);
          };
          return h;
        });
        await pumpScreen(
          t,
          h,
          tablet
              ? HorizontalTimelinePage(onBack: () {}, onOpenTask: (_) {})
              : const TimelinePage(),
        );
        await settle(t);
        final before = h.backend.count('GET', '/v1/work-items/gantt/admin');
        final chart = find.byType(tablet ? GanttChart : MobileTimelineChart);
        final chartState = t.state(chart);
        if (tablet) {
          final current = t.widget<GanttChart>(chart);
          final scroll = t
              .widget<SingleChildScrollView>(
                find.byKey(GanttChart.horizontalKey),
              )
              .controller!;
          scroll.jumpTo(
            (current.layout.barOf(tAltLate30)!.left - 100).clamp(
              0.0,
              scroll.position.maxScrollExtent,
            ),
          );
          await t.pump();
          final title = find.text('İletim hattı yapımı');
          await t.ensureVisible(title);
          await t.tap(title);
        } else {
          final bar = find.byKey(MobileTimelineChart.barKey(tAltLate30));
          await t.ensureVisible(bar);
          await settle(t);
          final visible = t
              .getRect(bar)
              .intersect(t.getRect(find.byType(MobileTimelineChart)));
          await t.tapAt(visible.center);
        }
        // Ayrıntı isteği ve olası Gantt yanıtı henüz sürerken her kareyi kontrol et.
        // Yalnız pumpAndSettle sonuna bakmak aradaki sökülmeyi gizler.
        for (var i = 0; i < 12; i++) {
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await t.pump(const Duration(milliseconds: 16));
          expect(chart, findsOneWidget);
          expect(t.state(chart), same(chartState));
        }
        expect(find.byType(TimelineSelectionCard), findsOneWidget);
        final card = t.element(find.byType(TimelineSelectionCard));
        for (var i = 0; i < 3; i++) {
          await settle(t);
          expect(find.byType(TimelineSelectionCard), findsOneWidget);
          expect(t.element(find.byType(TimelineSelectionCard)), same(card));
          expect(t.state(chart), same(chartState));
        }
        expect(
          h.backend.count('GET', '/v1/work-items/gantt/admin'),
          before,
          reason: 'Görev ayrıntısı okuması Gantt isteğini tekrar başlatmamalı.',
        );
        expect(h.backend.count('GET', '/v1/work-items/$tAltLate30'), 1);
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
        final offsets = (x.offset, y.offset);
        final blank = t.getTopLeft(chart) + const Offset(10, 10);
        await t.dragFrom(blank, const Offset(100, 60));
        await settle(t);
        expect((x.offset, y.offset), offsets);
        expect(find.byType(TimelineSelectionCard), findsOneWidget);

        if (tablet) {
          await t.tapAt(t.getCenter(find.text('Hidrofor montajı')));
        } else {
          final other = find.byKey(MobileTimelineChart.barKey(tAltLate12));
          final chartRect = t.getRect(chart);
          final sheetTop = t.getTopLeft(find.byType(TimelineSelectionCard)).dy;
          final visible = t
              .getRect(other)
              .intersect(
                Rect.fromLTRB(
                  chartRect.left,
                  chartRect.top,
                  chartRect.right,
                  sheetTop,
                ),
              );
          expect(
            visible.isEmpty,
            isFalse,
            reason: 'Diğer görev kartın üstünde seçilebilmeli.',
          );
          await t.tapAt(visible.center);
        }
        await t.pump();
        expect(find.byType(TimelineSelectionCard), findsOneWidget);
        expect(t.element(find.byType(TimelineSelectionCard)), same(card));
        await settle(t);
        expect(
          t
              .widget<TimelineSelectionCard>(find.byType(TimelineSelectionCard))
              .selection
              .task
              .code,
          tAltLate12,
        );
        expect((x.offset, y.offset), offsets);
        if (tablet) {
          final layout = t.widget<GanttChart>(chart).layout;
          final globalBar = layout
              .barOf(tAltLate30)!
              .shift(t.getTopLeft(find.byKey(GanttChart.barsKey)));
          final viewport = t.getRect(chart);
          final visible = globalBar.intersect(
            Rect.fromLTRB(
              viewport.left + layout.labelWidth,
              viewport.top,
              viewport.right,
              viewport.bottom,
            ),
          );
          expect(visible.isEmpty, isFalse);
          await t.tapAt(visible.center);
          await settle(t);
          expect(
            t
                .widget<TimelineSelectionCard>(
                  find.byType(TimelineSelectionCard),
                )
                .selection
                .task
                .code,
            tAltLate30,
          );
          expect(t.element(find.byType(TimelineSelectionCard)), same(card));
          // Geçerli göreve yeniden dokunmak kartı kapatmamalı.
          await t.tapAt(visible.center);
          await settle(t);
          expect(find.byType(TimelineSelectionCard), findsOneWidget);
          expect((x.offset, y.offset), offsets);
        }
        await t.tapAt(blank);
        await settle(t);
        expect(find.byType(TimelineSelectionCard), findsNothing);
        expect((x.offset, y.offset), offsets);
        expect(t.takeException(), isNull);
      },
    );
  }
}
