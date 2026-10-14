import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_banner.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const NzBanner.info(message: 'Bilgi iletisi'),
    cellGap,
    NzBanner.warning(
      message: 'Uyarı iletisi',
      actionLabel: 'Ayrıntı',
      onAction: () {},
    ),
    cellGap,
    const NzBanner.danger(message: 'Hata iletisi'),
    cellGap,
    const NzBanner.offline(),
    cellGap,
    NzBanner.offline(onAction: () {}),
  ],
);

void main() {
  setUpFonts();

  testWidgets('info/warning/danger iletiyi gösterir; eylem yoksa düğme yok', (
    tester,
  ) async {
    for (final b in const [
      NzBanner.info(message: 'İleti'),
      NzBanner.warning(message: 'İleti'),
      NzBanner.danger(message: 'İleti'),
    ]) {
      await tester.pumpWidget(testApp(b));
      expect(find.text('İleti'), findsOneWidget);
      expect(find.byType(TextButton), findsNothing);
    }
  });

  testWidgets('eylem: etiket gösterilir, dokunuşta çağrılır, alan >= 48', (
    tester,
  ) async {
    var n = 0;
    await tester.pumpWidget(
      testApp(
        NzBanner.danger(
          message: 'İleti',
          actionLabel: 'Aç',
          onAction: () => n++,
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(TextButton)).height,
      greaterThanOrEqualTo(NizamioSpacing.space12),
    );
    await tester.tap(find.text('Aç'));
    expect(n, 1);
  });

  testWidgets('tonlar rol rengiyle çizilir (kenarlık)', (tester) async {
    final expected = {
      'info': NizamioColors.light.info,
      'warning': NizamioColors.light.warning,
      'danger': NizamioColors.light.danger,
    };
    for (final (name, banner) in const [
      ('info', NzBanner.info(message: 'İ')),
      ('warning', NzBanner.warning(message: 'İ')),
      ('danger', NzBanner.danger(message: 'İ')),
    ]) {
      await tester.pumpWidget(testApp(banner));
      final box = tester.widget<Container>(find.byType(Container).first);
      final border = (box.decoration! as BoxDecoration).border! as Border;
      expect(border.top.color, expected[name], reason: name);
    }
  });

  group('offline', () {
    testWidgets('metin ARB\'den; onAction yoksa düğme yok', (tester) async {
      await tester.pumpWidget(testApp(const NzBanner.offline()));
      expect(
        find.text('Çevrimdışısınız. Sunucuya ulaşılamıyor.'),
        findsOneWidget,
      );
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('onAction varsa "Yeniden dene"; yalnız dokunuşla çağrılır', (
      tester,
    ) async {
      var n = 0;
      await tester.pumpWidget(testApp(NzBanner.offline(onAction: () => n++)));
      expect(find.text('Yeniden dene'), findsOneWidget);
      await tester.pump(const Duration(seconds: 30));
      expect(n, 0, reason: 'otomatik yeniden deneme yok');
      await tester.tap(find.text('Yeniden dene'));
      expect(n, 1);
    });
  });

  test('actionLabel ve onAction birlikte verilmelidir', () {
    expect(
      () => NzBanner.info(message: 'x', actionLabel: 'a'),
      throwsAssertionError,
    );
    expect(
      () => NzBanner.danger(message: 'x', onAction: () {}),
      throwsAssertionError,
    );
  });

  testWidgets('anlamsal: canlı bölge ve ileti etiketi', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(const NzBanner.danger(message: 'Hata iletisi')),
    );
    expect(
      tester.getSemantics(find.text('Hata iletisi')),
      matchesSemantics(label: 'Hata iletisi', isLiveRegion: true),
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, ton kenarlıkları', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.info,
      NizamioColors.light.warning,
      NizamioColors.light.danger,
      NizamioColors.dark.info,
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
        matchesGoldenFile('goldens/nz_banner.png'),
      );
    },
  );
}
