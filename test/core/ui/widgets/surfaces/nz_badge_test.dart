import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_badge.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Wrap(
  spacing: NizamioSpacing.space2,
  runSpacing: NizamioSpacing.space2,
  children: [
    for (final size in NzSize.values) ...[
      NzBadge.neutral(label: 'Nötr', size: size),
      NzBadge.info(label: 'Bilgi', size: size, leading: Icons.info_outline),
      NzBadge.success(label: 'Başarılı', size: size),
      NzBadge.warning(label: 'Uyarı', size: size),
      NzBadge.danger(label: 'Hata', size: size),
    ],
  ],
);

void main() {
  setUpFonts();

  testWidgets('etiketi gösterir; simge yuvası isteğe bağlı', (tester) async {
    await tester.pumpWidget(testApp(const NzBadge.info(label: 'Etiket')));
    expect(find.text('Etiket'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
    await tester.pumpWidget(
      testApp(const NzBadge.info(label: 'Etiket', leading: Icons.check)),
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('tonlar rol rengiyle çizilir (kenarlık)', (tester) async {
    final expected = <Widget, Color>{
      const NzBadge.neutral(label: 'a'): NizamioColors.light.textMuted,
      const NzBadge.info(label: 'a'): NizamioColors.light.info,
      const NzBadge.success(label: 'a'): NizamioColors.light.success,
      const NzBadge.warning(label: 'a'): NizamioColors.light.warning,
      const NzBadge.danger(label: 'a'): NizamioColors.light.danger,
    };
    for (final e in expected.entries) {
      await tester.pumpWidget(testApp(e.key));
      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(NzBadge),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(
        ((box.decoration as BoxDecoration).border! as Border).top.color,
        e.value,
      );
    }
  });

  testWidgets('boyut yüksekliği büyütür (sm <= md < lg)', (tester) async {
    final heights = <double>[];
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          Row(
            children: [NzBadge.info(label: 'a', size: size)],
          ),
        ),
      );
      heights.add(tester.getSize(find.byType(NzBadge)).height);
    }
    expect(heights[0], lessThanOrEqualTo(heights[1]));
    expect(heights[1], lessThan(heights[2]));
  });

  testWidgets('anlamsal: tek etiket, çocuklar gizli', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(const NzBadge.danger(label: 'Hata', leading: Icons.error)),
    );
    expect(
      tester.getSemantics(find.byType(NzBadge)),
      matchesSemantics(label: 'Hata'),
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, ton kenarlıkları', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.textMuted,
      NizamioColors.light.info,
      NizamioColors.light.success,
      NizamioColors.light.warning,
      NizamioColors.light.danger,
      NizamioColors.dark.info,
      NizamioColors.dark.success,
      NizamioColors.dark.warning,
      NizamioColors.dark.danger,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_badge.png'),
      );
    },
  );
}
