import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/dev/catalog/catalog_entry.dart';
import 'package:nizamio/app/dev/catalog_page.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/layout/layout.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_banner.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';

final _entries = [
  CatalogEntry(
    group: 'g1',
    name: 'Birinci',
    builder: (c) => Text(
      '${c.layout.resolvedClass}|${c.colors.background == NizamioColors.dark.background}|${MediaQuery.textScalerOf(c).scale(10)}',
    ),
  ),
  CatalogEntry(
    group: 'g1',
    name: 'Banner',
    builder: (_) => const NzBanner.info(message: 'ileti'),
  ),
  CatalogEntry(group: 'g2', name: 'İkinci', builder: (_) => const Text('iki')),
];

Future<void> _pump(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 1600);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(testApp(CatalogPage(entries: _entries)));
}

void main() {
  setUpFonts();

  testWidgets('girişler gruplanır ve adlarıyla listelenir', (tester) async {
    await _pump(tester);
    for (final t in [
      'g1',
      'g2',
      'Birinci',
      'Banner',
      'İkinci',
      'iki',
      'ileti',
    ]) {
      expect(find.text(t), findsOneWidget, reason: t);
    }
  });

  testWidgets('varsayılan: açık tema, 360 genişlik (compact), metin 1.0', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('WindowClass.compact|false|10.0'), findsOneWidget);
    expect(tester.getSize(find.byType(NzBanner)).width, lessThanOrEqualTo(360));
  });

  testWidgets('koyu / 700 / 1024 / metin 2x seçimleri önizlemeye yansır', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.text('dark'));
    await tester.pump();
    expect(find.text('WindowClass.compact|true|10.0'), findsOneWidget);

    await tester.tap(find.text('700'));
    await tester.pump();
    expect(find.textContaining('WindowClass.medium'), findsOneWidget);

    await tester.tap(find.text('1024'));
    await tester.pump();
    expect(find.textContaining('WindowClass.expanded'), findsOneWidget);
    expect(tester.getSize(find.byType(NzBanner)).width, greaterThan(700));

    await tester.tap(find.text('2.0x'));
    await tester.pump();
    expect(find.textContaining('|20.0'), findsOneWidget);
  });

  testWidgets('gerçek kayıt defteri: metin 2x ve her genişlikte taşma yok', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(testApp(const CatalogPage()));
    await tester.tap(find.widgetWithText(ChoiceChip, '2.0x'));
    await tester.pump();
    for (final w in ['360', '700', '1024']) {
      await tester.tap(find.widgetWithText(ChoiceChip, w));
      await tester.pump();
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pump();
      }
      expect(tester.takeException(), isNull, reason: w);
    }
    await tester.pump(const Duration(seconds: 31));
  });
}
