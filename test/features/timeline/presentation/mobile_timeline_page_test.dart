import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/mobile/mobile_timeline_chart.dart';
import 'package:nizamio/features/timeline/presentation/mobile/mobile_timeline_layout.dart';
import 'package:nizamio/features/timeline/presentation/mobile/mobile_timeline_strip.dart';
import 'package:nizamio/features/timeline/presentation/timeline_page.dart';
import 'package:nizamio/features/timeline/presentation/timeline_texts.dart';
import 'package:nizamio/features/timeline/presentation/widgets/timeline_selection_card.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();
const _screen = ValueKey('timeline-capture');
final _provider = timelineControllerProvider(null);

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester t, {
  double width = 390,
  double scale = 1,
  CoordBackend? backend,
}) async {
  t.view.devicePixelRatio = 1;
  t.view.physicalSize = Size(width, 844);
  t.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(t.view.reset);
  addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
  final h = await real(t, () async {
    final h = await pilotHarness(backend ?? CoordBackend(), signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    h.container.listen(timelineViewProvider(null), (_, _) {});
    await h.container.read(taskCatalogControllerProvider.future);
    await h.container.read(ganttScheduleProvider.future);
    return h;
  });
  final nav = RecordingAppNav();
  await pumpScreen(
    t,
    h,
    const RepaintBoundary(key: _screen, child: TimelinePage()),
    dark: true,
    nav: nav,
  );
  await settle(t);
  return (h, nav);
}

Future<void> _tap(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.tap(f);
  await settle(t);
}

Future<void> _pickBar(WidgetTester t, String code) async {
  final bar = find.byKey(MobileTimelineChart.barKey(code));
  await t.ensureVisible(bar);
  await settle(t);
  // Gerçek çubuğun görünür kesitini kullan; uzun çubuğun merkezi pencerenin dışında olabilir.
  final visible = t
      .getRect(bar)
      .intersect(t.getRect(find.byType(MobileTimelineChart)));
  expect(visible.isEmpty, isFalse);
  await t.tapAt(visible.center);
  await settle(t);
}

Future<void> _capture(WidgetTester t, String name) async {
  if (!const bool.fromEnvironment('TIMELINE_CAPTURE')) return;
  final boundary = t.renderObject<RenderRepaintBoundary>(find.byKey(_screen));
  await t.runAsync(() async {
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('/tmp/$name.png').writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpFonts();
  testWidgets(
    'mobil yatay çizelgede ölçek, katlama, seçim ve tarih önizlemesi gerçek durumda kalır',
    (t) async {
      final (h, nav) = await _open(t);
      final container = h.container;
      final controller = container.read(_provider.notifier);
      TimelineView view() =>
          container.read(timelineViewProvider(null)).requireValue;
      final task = view().shown.first;
      expect(find.byType(MobileTimelineChart), findsOneWidget);
      expect(find.byType(MobileTimelineStrip), findsOneWidget);
      await _capture(t, 'nizam-timeline-mobile');
      final initial = view().state.scale;
      for (var i = 0; i < 3; i++) {
        await _tap(t, find.bySemanticsLabel(RegExp('^Ölçek:')));
      }
      expect(view().state.scale, initial);
      final group = task.item.coordinatorship;
      await _tap(t, find.byKey(MobileTimelineChart.groupKey(group)));
      expect(view().state.closedGroups, contains(group));
      expect(find.byKey(MobileTimelineChart.barKey(task.code)), findsNothing);
      await _tap(t, find.byKey(MobileTimelineChart.groupKey(group)));
      await _pickBar(t, task.code);
      expect(view().state.selected, task.code);
      expect(find.byType(TimelineSelectionCard), findsOneWidget);
      final current = view().selection!.current;
      for (var i = 0; i < 2; i++) {
        await _tap(
          t,
          find.bySemanticsLabel(
            '${_l.uiTimelineEnd} ${_l.uiTimelineDayForward}',
          ),
        );
      }
      expect(
        MobileTimelineLayout(view()).barOf(task.code)!.task.range,
        DayRange(current.start, current.end + 2),
      );
      expect(h.backend.count('PATCH', '/v1/work-items/${task.item.id}'), 0);
      await _capture(t, 'nizam-timeline-mobile-selected');
      controller.closeSelection();
      await settle(t);
      await _tap(t, find.bySemanticsLabel(_l.uiTasksModeList));
      expect(nav.calls, contains('tasks'));
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'önceki yılın tek günlük görevi tarih seçicilerinde değişmeden kalır',
    (t) async {
      final backend = CoordBackend();
      final date = '${DateTime.now().year - 1}-12-31';
      final item = backend.workItems.firstWhere(
        (item) => item['work_item_id'] == tAltLate30,
      );
      item['start_on'] = date;
      item['end_on'] = date;
      final (h, _) = await _open(t, backend: backend);
      final controller = h.container.read(_provider.notifier);
      controller.select(tAltLate30);
      await settle(t);
      TimelineSelection selection() =>
          h.container.read(timelineViewProvider(null)).requireValue.selection!;
      final original = selection().current;
      expect(original.start, original.end);
      for (final start in [true, false]) {
        final label = start ? _l.uiTimelineStart : _l.uiTimelineEnd;
        final year = h.container
            .read(timelineViewProvider(null))
            .requireValue
            .year;
        await _tap(
          t,
          find.bySemanticsLabel('$label ${_l.fullDay(original.start, year)}'),
        );
        expect(find.byType(DatePickerDialog), findsOneWidget);
        final dialogContext = t.element(find.byType(DatePickerDialog));
        final ok = MaterialLocalizations.of(dialogContext).okButtonLabel;
        await _tap(t, find.text(ok));
        expect(selection().draft, original);
        expect(selection().changed, isFalse);
        expect(t.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'arama ve filtreler çizelgeyi süzer; boş koordinatörlük seçimi hepsi olmaz',
    (t) async {
      final (h, _) = await _open(t);
      final container = h.container;
      TimelineView view() =>
          container.read(timelineViewProvider(null)).requireValue;
      final task = view().shown.first;
      await _tap(t, find.bySemanticsLabel(_l.uiTasksSearch));
      await t.enterText(find.byType(EditableText), task.item.title);
      await settle(t);
      expect(
        view().shown.every((item) => item.item.title == task.item.title),
        isTrue,
      );
      await t.testTextInput.receiveAction(TextInputAction.search);
      await settle(t);
      await _tap(t, find.bySemanticsLabel(_l.uiTimelineFilterLabel));
      await _tap(t, find.text(_l.uiTimelineStatusDone));
      expect(view().state.status, TimelineStatusFilter.done);
      expect(
        view().shown.every((item) => item.status == TaskStatus.done),
        isTrue,
      );
      Navigator.of(t.element(find.text(_l.uiTimelineFilters))).pop();
      await settle(t);
      await _tap(t, find.bySemanticsLabel(RegExp('^Koordinatörlük ·')));
      await _tap(t, find.text(_l.uiTimelineCoordClear));
      expect(view().noneSelected, isTrue);
      expect(view().shown, isEmpty);
      expect(find.text(_l.uiTimelineEmptyNoCoord), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'dar ekran ve büyük metin: seçim ve tam ekran arasında taşma olmaz',
    (t) async {
      final (h, _) = await _open(t, width: 360, scale: 2);
      final controller = h.container.read(_provider.notifier);
      final task = h.container
          .read(timelineViewProvider(null))
          .requireValue
          .shown
          .first;
      await _pickBar(t, task.code);
      expect(find.byType(TimelineSelectionCard), findsOneWidget);
      expect(t.takeException(), isNull);
      controller.closeSelection();
      await settle(t);
      final chart = t.getRect(find.byType(MobileTimelineChart));
      await t.tapAt(Offset(chart.left + 30, chart.bottom - 100));
      await settle(t);
      expect(find.text(_l.uiTimelineFullscreenHint), findsOneWidget);
      expect(t.takeException(), isNull);
      await t.tapAt(Offset(chart.left + 30, chart.bottom - 100));
      await settle(t);
      expect(find.bySemanticsLabel(_l.uiTasksSearch), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
}
