// Gündem işaret hareketi: işaretlenen madde hemen tamamlanır ama 360 ms yerinde kalır, sonra
// tamamlananların arasına (işaretlenme anına göre) geçer; geri alma beklemesiz. Ardışık
// işaretlerde zamanlayıcı yeniden kurulur, tutulanlar birlikte bırakılır. Hareketi azalt
// açıkken bekleme yoktur.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/ui/motion/nz_check_motion.dart';
import 'package:nizamio/features/meetings/meetings.dart';

import '../../pilot_support.dart';
import '../meetings_server.dart';

List<String> _order(WidgetTester tester) => [
  for (final w in tester.widgetList<NzStrikeText>(find.byType(NzStrikeText)))
    w.text,
];

bool _struck(WidgetTester tester, String title) => tester
    .widget<NzStrikeText>(
      find.byWidgetPredicate((w) => w is NzStrikeText && w.text == title),
    )
    .done;

Future<void> _check(WidgetTester tester, String title) async {
  await tester.tap(find.bySemanticsLabel(title).first);
  await tester.pump();
}

Future<void> _open(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 1400);
  addTearDown(tester.view.reset);
  final s = MeetingsServer()
    ..agenda = [
      agendaWire('g1', title: 'Bir'),
      agendaWire('g2', order: 2, title: 'İki'),
      agendaWire('g3', order: 3, title: 'Üç'),
    ];
  final (h, _) = await real(tester, () => openMeetings(s));
  await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('işaret: yerinde 360 ms, sonra alta; geri alma hemen', (
    tester,
  ) async {
    await _open(tester);
    expect(_order(tester), ['Bir', 'İki', 'Üç']);

    await _check(tester, 'Bir');
    expect(_struck(tester, 'Bir'), isTrue, reason: 'hemen tamamlandı');
    expect(_order(tester), ['Bir', 'İki', 'Üç'], reason: 'yerinde');
    await tester.pump(const Duration(milliseconds: 300));
    expect(_order(tester).first, 'Bir');
    await tester.pump(const Duration(milliseconds: 80));
    expect(_order(tester), ['İki', 'Üç', 'Bir']);

    await _check(tester, 'Bir');
    expect(_struck(tester, 'Bir'), isFalse);
    expect(_order(tester), ['Bir', 'İki', 'Üç'], reason: 'beklemesiz döner');
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'ardışık işaret: zamanlayıcı yeniden kurulur, birlikte bırakılır',
    (tester) async {
      await _open(tester);
      await _check(tester, 'Bir');
      await tester.pump(const Duration(milliseconds: 300));
      await _check(tester, 'İki');
      await tester.pump(const Duration(milliseconds: 300));
      expect(_order(tester), [
        'Bir',
        'İki',
        'Üç',
      ], reason: 'ilk zamanlayıcı iptal');
      await tester.pump(const Duration(milliseconds: 80));
      expect(_order(tester), [
        'Üç',
        'Bir',
        'İki',
      ], reason: 'işaretlenme sırasıyla');
      await settle(tester);
    },
  );

  testWidgets('hareketi azalt: bekleme yok, sıra anında değişir', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _open(tester);
    await _check(tester, 'Bir');
    expect(_order(tester), ['İki', 'Üç', 'Bir']);
    await settle(tester);
  });
}
