import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_skeleton.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

Widget _variants(BuildContext context) => const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    NzSkeleton.text(),
    cellGap,
    NzSkeleton.text(lines: 3),
    cellGap,
    NzSkeleton.block(height: 80),
    cellGap,
    NzSkeleton.list(),
  ],
);

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byType(NzSkeleton),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

void main() {
  setUpFonts();

  testWidgets('text: satır sayısı kadar çubuk, son satır kısa', (tester) async {
    await tester.pumpWidget(
      testApp(const Align(child: NzSkeleton.text(lines: 3))),
    );
    final bars = find.descendant(
      of: find.byType(NzSkeleton),
      matching: find.byType(Container),
    );
    expect(bars, findsNWidgets(3));
    final w = [
      for (final e in bars.evaluate())
        tester.getSize(find.byWidget(e.widget)).width,
    ];
    expect(w[0], w[1]);
    expect(w[2], lessThan(w[1]));
  });

  testWidgets('block: verilen yükseklik, genişlik üst kısıttan', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const NzSkeleton.block(height: 80)));
    final size = tester.getSize(find.byType(Container));
    expect(size.height, 80);
    expect(size.width, tester.getSize(find.byType(Scaffold)).width);
  });

  testWidgets('list: count satır, her biri avatar + iki çubuk', (tester) async {
    await tester.pumpWidget(testApp(const NzSkeleton.list(count: 4)));
    // 4 avatar + 4 × 2 çubuk
    expect(find.byType(Container), findsNWidgets(4 + 8));
    expect(find.byType(Row), findsNWidgets(4));
  });

  testWidgets('animasyon: soluklaşır; hareketi azalt açıkken durağan', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const NzSkeleton.text()));
    final first = _opacity(tester);
    await tester.pump(const Duration(milliseconds: 600));
    expect(_opacity(tester), lessThan(first));

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(testApp(const NzSkeleton.text(lines: 2)));
    await tester.pump(const Duration(milliseconds: 600));
    expect(_opacity(tester), 1);
    await tester.pump(const Duration(milliseconds: 600));
    expect(_opacity(tester), 1);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('anlamsal etiket yükleniyor', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzSkeleton.list()));
    expect(find.bySemanticsLabel('Yükleniyor'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, çubuk rengi kenarlık rolü', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.border,
      NizamioColors.dark.border,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_skeleton.png'),
      );
    },
  );
}
