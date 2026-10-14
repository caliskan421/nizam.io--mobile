import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_loader.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

Widget _variants(BuildContext context) => const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        NzLoader(size: NzSize.sm),
        cellGap,
        NzLoader(),
        cellGap,
        NzLoader(size: NzSize.lg),
      ],
    ),
    cellGap,
    SizedBox(height: 120, child: NzLoader.page()),
  ],
);

void main() {
  setUpFonts();

  testWidgets('boyutlar sm 24 · md 32 · lg 48; page alanı ortalar', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const Column(
          children: [
            NzLoader(size: NzSize.sm, key: Key('sm')),
            NzLoader(key: Key('md')),
            NzLoader(size: NzSize.lg, key: Key('lg')),
          ],
        ),
      ),
    );
    Size sizeOf(String k) => tester.getSize(
      find.descendant(
        of: find.byKey(Key(k)),
        matching: find.byType(CircularProgressIndicator),
      ),
    );
    expect(sizeOf('sm'), const Size.square(NizamioSpacing.space6));
    expect(sizeOf('md'), const Size.square(NizamioSpacing.space8));
    expect(sizeOf('lg'), const Size.square(NizamioSpacing.space12));

    await tester.pumpWidget(testApp(const NzLoader.page()));
    final scaffold = tester.getRect(find.byType(Scaffold));
    final indicator = tester.getRect(find.byType(CircularProgressIndicator));
    expect(indicator.center, scaffold.center);
    expect(indicator.size, const Size.square(NizamioSpacing.space12));
  });

  testWidgets('anlamsal etiket: varsayılan ARB, verilirse özel', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzLoader()));
    expect(find.bySemanticsLabel('Yükleniyor'), findsOneWidget);

    await tester.pumpWidget(
      testApp(const NzLoader(semanticLabel: 'Liste yükleniyor')),
    );
    expect(find.bySemanticsLabel('Liste yükleniyor'), findsOneWidget);
    expect(find.bySemanticsLabel('Yükleniyor'), findsNothing);
    handle.dispose();
  });

  testWidgets('göstergenin rengi birincil roldür', (tester) async {
    await tester.pumpWidget(testApp(const NzLoader(), dark: true));
    final p = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(p.color, NizamioColors.dark.primary);
  });

  testWidgets('piksel: tabaka 1024 geniş, zeminler ve gösterge rengi', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.dark.primary,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_loader.png'),
      );
    },
  );
}
