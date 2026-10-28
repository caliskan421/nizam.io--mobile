import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_card.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzCard.filled(size: size, child: const Text('Dolu kart')),
      cellGap,
      NzCard.outlined(size: size, child: const Text('Kenarlıklı kart')),
      cellGap,
    ],
    NzCard.outlined(
      onTap: () {},
      semanticLabel: 'Dokunulabilir',
      child: const Text('Dokunulabilir kart'),
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('içeriği gösterir; onTap yoksa dokunulamaz', (tester) async {
    await tester.pumpWidget(
      testApp(const NzCard.filled(child: Text('İçerik'))),
    );
    expect(find.text('İçerik'), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('onTap: dokunuşta çağrılır, yükseklik >= 48', (tester) async {
    var n = 0;
    await tester.pumpWidget(
      testApp(NzCard.outlined(onTap: () => n++, child: const Text('x'))),
    );
    expect(
      tester.getSize(find.byType(InkWell)).height,
      greaterThanOrEqualTo(NizamioSpacing.space12),
    );
    await tester.tap(find.text('x'));
    expect(n, 1);
  });

  testWidgets('boyut iç boşluğu belirler (sm < md < lg)', (tester) async {
    final heights = <double>[];
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(NzCard.filled(size: size, child: const SizedBox(height: 10))),
      );
      heights.add(tester.getSize(find.byType(NzCard)).height);
    }
    expect(heights, [10 + 2 * 12, 10 + 2 * 16, 10 + 2 * 24]);
  });

  testWidgets('varyant: dolu zemin / kenarlık rengi', (tester) async {
    await tester.pumpWidget(testApp(const NzCard.filled(child: Text('a'))));
    var material = tester.widget<Material>(
      find.descendant(of: find.byType(NzCard), matching: find.byType(Material)),
    );
    expect(material.color, NizamioColors.light.surfaceRaised);
    await tester.pumpWidget(testApp(const NzCard.outlined(child: Text('a'))));
    material = tester.widget<Material>(
      find.descendant(of: find.byType(NzCard), matching: find.byType(Material)),
    );
    expect(material.color, NizamioColors.light.surface);
    expect(
      (material.shape! as RoundedRectangleBorder).side.color,
      NizamioColors.light.border,
    );
  });

  testWidgets('anlamsal: dokunulabilir kart düğme olarak bildirilir', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        NzCard.filled(
          onTap: () {},
          semanticLabel: 'Kart',
          child: const Text('x'),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(NzCard)),
      matchesSemantics(label: 'Kart', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, kart zemin/kenarlık renkleri', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.surfaceRaised,
      NizamioColors.light.border,
      NizamioColors.dark.surfaceRaised,
      NizamioColors.dark.border,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_card.png'),
      );
    },
  );
}
