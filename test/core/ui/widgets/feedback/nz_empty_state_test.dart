import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_empty_state.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const NzEmptyState(title: 'Kayıt yok'),
    cellGap,
    const NzEmptyState(
      title: 'Sonuç bulunamadı',
      message: 'Arama ölçütünüzü değiştirip yeniden deneyin.',
      icon: Icons.search_off,
    ),
    cellGap,
    NzEmptyState(
      title: 'Henüz öğe yok',
      message: 'İlk öğeyi ekleyin.',
      actionLabel: 'Ekle',
      onAction: () {},
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('başlık, ileti ve varsayılan simge gösterilir', (tester) async {
    await tester.pumpWidget(
      testApp(const NzEmptyState(title: 'Başlık', message: 'İleti')),
    );
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('İleti'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('verilen simge varsayılanın yerine geçer', (tester) async {
    await tester.pumpWidget(
      testApp(const NzEmptyState(title: 'B', icon: Icons.search_off)),
    );
    expect(find.byIcon(Icons.search_off), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsNothing);
  });

  testWidgets('eylem düğmesi dokunuşta çağrılır ve dokunma alanı >= 48', (
    tester,
  ) async {
    var n = 0;
    await tester.pumpWidget(
      testApp(
        NzEmptyState(title: 'B', actionLabel: 'Ekle', onAction: () => n++),
      ),
    );
    expect(
      tester.getSize(find.byType(FilledButton)).height,
      greaterThanOrEqualTo(NizamioSpacing.space12),
    );
    await tester.tap(find.text('Ekle'));
    expect(n, 1);
  });

  test('actionLabel ve onAction birlikte verilmelidir', () {
    expect(
      () => NzEmptyState(title: 'B', actionLabel: 'Ekle'),
      throwsAssertionError,
    );
    expect(
      () => NzEmptyState(title: 'B', onAction: () {}),
      throwsAssertionError,
    );
  });

  testWidgets('başlık başlık anlamsal rolündedir', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzEmptyState(title: 'Kayıt yok')));
    expect(
      tester.getSemantics(find.text('Kayıt yok')),
      matchesSemantics(label: 'Kayıt yok', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, düğme birincil rengi', (
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
        matchesGoldenFile('goldens/nz_empty_state.png'),
      );
    },
  );
}
