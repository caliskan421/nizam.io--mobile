import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_divider.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) NzDivider.horizontal(size: size),
    const SizedBox(
      height: NizamioSpacing.space12,
      child: Row(children: [Text('Sol'), NzDivider.vertical(), Text('Sağ')]),
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('yatay: 1 px kalınlık, boşluk boyuta göre', (tester) async {
    final heights = <double>[];
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(Column(children: [NzDivider.horizontal(size: size)])),
      );
      heights.add(tester.getSize(find.byType(NzDivider)).height);
      expect(
        tester.getSize(find.byType(ColoredBox).last).height,
        NzDivider.thickness,
      );
    }
    expect(heights, [1 + 2 * 4, 1 + 2 * 8, 1 + 2 * 16]);
  });

  testWidgets('dikey: 1 px genişlik, üst yüksekliği doldurur', (tester) async {
    await tester.pumpWidget(
      testApp(
        const SizedBox(
          height: 40,
          child: Row(children: [NzDivider.vertical(size: NzSize.sm)]),
        ),
      ),
    );
    expect(tester.getSize(find.byType(NzDivider)).width, 1 + 2 * 4);
    expect(tester.getSize(find.byType(NzDivider)).height, 40);
  });

  testWidgets('çizgi border rengiyle çizilir; anlamsal ağaçta yok', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzDivider.horizontal()));
    expect(
      tester.widget<ColoredBox>(find.byType(ColoredBox).last).color,
      NizamioColors.light.border,
    );
    expect(find.byType(ExcludeSemantics), findsWidgets);
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, çizgi renkleri', (tester) async {
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
        matchesGoldenFile('goldens/nz_divider.png'),
      );
    },
  );
}
