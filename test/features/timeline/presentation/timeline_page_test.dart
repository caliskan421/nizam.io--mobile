// TimelinePage: bölümler (anahtar, seçici, filtre, çizelge, sezon şeridi), çubuk seçimi ve
// seçili görev kartı (ayrıntıda aç, −/+, kaydet → geri al, talep, hatırlat), koordinatörlük
// seçici, filtre/lejant alt sayfası, bugüne dön, Liste anahtarı; 360/390 × 1.0/2.0 × açık/koyu
// taşma yok.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_chart.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_layout.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_painters.dart';
import 'package:nizamio/features/timeline/presentation/timeline_texts.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<RecordingAppNav> _open(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
  bool dark = false,
  String? coordinatorship,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    TimelinePage(coordinatorship: coordinatorship),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return nav;
}

TimelineLayout _layout(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byKey(TimelineChart.canvasKey),
      matching: find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is TimelineChartPainter,
      ),
    ),
  );
  return (paint.painter! as TimelineChartPainter).layout;
}

/// Görevin çubuğunun görünür kısmının ortasına dokunur.
Future<void> _tapBar(WidgetTester tester, String code) async {
  final rect = _layout(tester).barOf(code)!.rect;
  final origin = tester.getTopLeft(find.byKey(TimelineChart.canvasKey));
  final viewport = tester.getRect(find.byType(TimelineChart));
  final visible = rect
      .shift(origin)
      .intersect(
        Rect.fromLTRB(
          viewport.left,
          viewport.top + 60,
          viewport.right,
          viewport.bottom - 80,
        ),
      );
  expect(visible.height, greaterThan(0), reason: '$code görünür değil');
  await tester.tapAt(visible.center);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    for (final scale in const [1.0, 2.0]) {
      for (final dark in const [false, true]) {
        testWidgets('bölümler; taşma yok [${size.width.toInt()} × $scale × '
            '${dark ? 'koyu' : 'açık'}]', (tester) async {
          await _open(tester, size: size, textScale: scale, dark: dark);
          expect(find.text(_l.uiTimelineList), findsOneWidget);
          expect(find.text(_l.uiTimelineTitle), findsOneWidget);
          expect(find.text(_l.uiTimelineCoord), findsOneWidget);
          expect(find.text('Altyapı ve tesisat'), findsOneWidget);
          expect(find.text(_l.uiTimelineFilter), findsOneWidget);
          expect(find.byKey(TimelineChart.canvasKey), findsOneWidget);
          expect(find.byKey(const ValueKey('timeline-strip')), findsOneWidget);
          expect(_layout(tester).bars, hasLength(13));
          expect(tester.takeException(), isNull);

          // Seçili kart da taşmadan çizilir.
          await _tapBar(tester, 'ALT-10');
          expect(find.text(_l.uiTimelineSave), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('çubuğa dokun → kart; ayrıntıda aç; kapat', (tester) async {
    final nav = await _open(tester);
    await _tapBar(tester, 'ALT-10');
    expect(find.text('Montaj, test ve devreye alma aşaması'), findsOneWidget);
    expect(find.text(_l.uiTimelineStDoing), findsOneWidget);
    expect(find.text('21 ${_l.uiTimelineDaysLate}'), findsOneWidget);
    // Kart açıkken sezon şeridi gizli.
    expect(find.byKey(const ValueKey('timeline-strip')), findsNothing);
    await tester.tap(find.bySemanticsLabel(_l.uiTimelineOpenTask));
    await settle(tester);
    expect(nav.calls, ['task:ALT-10']);
    await tester.tap(find.bySemanticsLabel(_l.uiCommonClose).last);
    await settle(tester);
    expect(find.text(_l.uiTimelineSave), findsNothing);
    expect(find.byKey(const ValueKey('timeline-strip')), findsOneWidget);
  });

  testWidgets('tarih taslağı → kaydet → geri al; talep ve hatırlat bildirimi', (
    tester,
  ) async {
    await _open(tester);
    await _tapBar(tester, 'ALT-10');
    // Değişiklik yokken talep → uyarı.
    await tester.tap(find.bySemanticsLabel(_l.uiTimelineSendRequest));
    await tester.pump();
    expect(find.text(_l.uiTimelineRequestNoChange), findsOneWidget);

    await tester.tap(find.text(_l.uiTimelineShiftWeekForward));
    await tester.pump();
    expect(find.textContaining('${_l.uiTimelineStart} +7'), findsOneWidget);
    await tester.tap(find.text(_l.uiTimelineSave));
    await settle(tester);
    expect(
      find.text('ALT-10 7 ${_l.uiTimelineShiftedForward}'),
      findsOneWidget,
    );
    await tester.tap(find.text(_l.uiTimelineUndo));
    await tester.pump();
    expect(find.text('ALT-10 ${_l.uiTimelineUndoneTail}'), findsOneWidget);

    await _tapBar(tester, 'ALT-10');
    await tester.tap(find.bySemanticsLabel(_l.uiTimelineRemind));
    await tester.pump();
    expect(find.textContaining(_l.uiTimelineReminded), findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel(
        RegExp('${_l.uiTimelineEnd} ${_l.uiTimelineDayForward}'),
      ),
    );
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(_l.uiTimelineSendRequest));
    await tester.pump();
    expect(find.textContaining(_l.uiTimelineRequestSent), findsOneWidget);
    // Bildirim süresi dolunca kaybolur.
    await tester.pump(const Duration(seconds: 3));
    expect(find.textContaining(_l.uiTimelineRequestSent), findsNothing);
  });

  testWidgets('koordinatörlük seçici: çoklu seçim, seçimi kaldır', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text(_l.uiTimelineCoord));
    await settle(tester);
    expect(find.text('Mekanik sistemler'), findsOneWidget);
    expect(find.text('1 / 11 ${_l.uiTimelineCoordOpenTail}'), findsOneWidget);
    await tester.tap(find.text('Mekanik sistemler'));
    await settle(tester);
    expect(find.text('2 ${_l.uiTimelineCoordSelected}'), findsOneWidget);
    expect(_layout(tester).heads, hasLength(2));
    await tester.tap(find.text(_l.uiTimelineCoordClear));
    await settle(tester);
    expect(find.text(_l.uiTimelineCoordNone), findsOneWidget);
    expect(find.text(_l.uiTimelineCoordSelectAll), findsOneWidget);
    // Kapatma alanı menüyü kapatır.
    await tester.tapAt(const Offset(200, 780));
    await settle(tester);
    expect(find.text(_l.uiTimelineCoordSelectAll), findsNothing);
    expect(find.text(_l.uiTimelineEmptyNoCoord), findsOneWidget);
  });

  testWidgets('filtre sayfası: durum, ölçek, genel bakış; lejant', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text(_l.uiTimelineFilter));
    await settle(tester);
    expect(find.text(_l.uiTimelineFilters), findsWidgets);
    expect(find.text(_l.uiTimelinePerson), findsOneWidget);
    expect(find.text(_l.showTasks(13)), findsOneWidget);
    await tester.tap(find.text(_l.uiTimelineStatusLate));
    await settle(tester);
    expect(find.text(_l.showTasks(13)), findsNothing);
    await tester.tap(find.text(_l.uiTimelineScaleDay));
    await settle(tester);
    final apply = find.textContaining(_l.uiTimelineShowTasksTail);
    await tester.ensureVisible(apply);
    await tester.tap(apply);
    await settle(tester);
    expect(_layout(tester).ppd, 30);
    // Durum süzgeci rozeti.
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.text(_l.uiTimelineFilter));
    await settle(tester);
    await tester.tap(find.text(_l.uiTimelineOverview));
    await settle(tester);
    final legend = find.text(_l.uiTimelineLegendOpen);
    await tester.ensureVisible(legend);
    await tester.tap(legend);
    await settle(tester);
    expect(find.text(_l.uiTimelineStDoneLate), findsOneWidget);
    expect(find.text(_l.uiTimelineLegendStrip), findsOneWidget);
    await tester.tapAt(const Offset(200, 20));
    await settle(tester);
    expect(_layout(tester).overview, hasLength(11));
  });

  testWidgets('bugüne dön: uzağa kayınca düğme çıkar, dokununca bugüne döner', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text(_l.uiTimelineToday), findsNothing);
    await tester.dragFrom(
      tester.getCenter(find.byType(TimelineChart)),
      const Offset(0, 1500),
    );
    await settle(tester);
    expect(find.text(_l.uiTimelineToday), findsOneWidget);
    await tester.tap(find.text(_l.uiTimelineToday));
    await settle(tester);
    expect(find.text(_l.uiTimelineToday), findsNothing);
  });

  testWidgets('Liste: yığın yoksa görev listesine gider', (tester) async {
    final nav = await _open(tester);
    await tester.tap(find.text(_l.uiTimelineList));
    await settle(tester);
    expect(nav.calls, ['tasks']);
  });

  testWidgets('rota koordinatörlüğü seçili açılır', (tester) async {
    await _open(tester, coordinatorship: 'İDA');
    expect(find.text('İdari işler'), findsOneWidget);
  });
}
