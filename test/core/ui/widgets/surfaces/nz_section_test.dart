import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_section.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzSection(
        title: 'Bölüm başlığı',
        size: size,
        trailing: const Icon(Icons.chevron_right),
        child: const Text('Bölüm içeriği'),
      ),
      cellGap,
    ],
  ],
);

void main() {
  setUpFonts();

  testWidgets('başlık, içerik ve yuva gösterilir', (tester) async {
    await tester.pumpWidget(
      testApp(
        const NzSection(
          title: 'Başlık',
          trailing: Icon(Icons.add),
          child: Text('İçerik'),
        ),
      ),
    );
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('İçerik'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('yuva yoksa yalnız başlık satırı', (tester) async {
    await tester.pumpWidget(
      testApp(const NzSection(title: 'Başlık', child: Text('İçerik'))),
    );
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('boyut başlık yazı tipini büyütür (sm < md < lg)', (
    tester,
  ) async {
    final sizes = <double>[];
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(NzSection(title: 'B', size: size, child: const Text('c'))),
      );
      sizes.add(tester.widget<Text>(find.text('B')).style!.fontSize!);
    }
    expect(sizes[0], lessThan(sizes[1]));
    expect(sizes[1], lessThan(sizes[2]));
  });

  testWidgets('anlamsal: başlık "header" olarak bildirilir', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(const NzSection(title: 'Başlık', child: Text('İçerik'))),
    );
    expect(
      tester.getSemantics(find.text('Başlık')),
      matchesSemantics(label: 'Başlık', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, açık/koyu zemin', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.background,
      NizamioColors.dark.background,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_section.png'),
      );
    },
  );
}
