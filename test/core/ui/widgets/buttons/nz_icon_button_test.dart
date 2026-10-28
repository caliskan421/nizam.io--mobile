import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_icon_button.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Wrap(
  spacing: NizamioSpacing.space2,
  runSpacing: NizamioSpacing.space2,
  children: [
    for (final size in NzSize.values)
      NzIconButton(
        icon: Icons.add,
        semanticLabel: 'Ekle',
        onPressed: () {},
        size: size,
      ),
    const NzIconButton(
      icon: Icons.delete_outline,
      semanticLabel: 'Sil',
      onPressed: null,
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('ikon çizilir, dokunuşta çağrılır', (tester) async {
    var n = 0;
    await tester.pumpWidget(
      testApp(
        NzIconButton(
          icon: Icons.add,
          semanticLabel: 'Ekle',
          onPressed: () => n++,
        ),
      ),
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byType(NzIconButton));
    expect(n, 1);
  });

  testWidgets('onPressed null → devre dışı, çağrı yok', (tester) async {
    await tester.pumpWidget(
      testApp(
        const NzIconButton(
          icon: Icons.add,
          semanticLabel: 'Ekle',
          onPressed: null,
        ),
      ),
    );
    await tester.tap(find.byType(NzIconButton), warnIfMissed: false);
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
  });

  testWidgets('anlamsal: görünmez etiket', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        NzIconButton(icon: Icons.add, semanticLabel: 'Ekle', onPressed: () {}),
      ),
    );
    expect(find.bySemanticsLabel('Ekle'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(NzIconButton)),
      matchesSemantics(
        label: 'Ekle',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          Center(
            child: NzIconButton(
              icon: Icons.add,
              semanticLabel: 'Ekle',
              onPressed: () {},
              size: size,
            ),
          ),
        ),
      );
      final box = tester.getSize(find.byType(NzIconButton));
      expect(box.width, greaterThanOrEqualTo(NizamioSpacing.space12));
      expect(box.height, greaterThanOrEqualTo(NizamioSpacing.space12));
    }
  });

  testWidgets('metin ölçeği 2.0: taşma yok', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: testApp(
          NzIconButton(
            icon: Icons.add,
            semanticLabel: 'Ekle',
            onPressed: () {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('piksel: tabaka 1024 geniş, ikon rengi', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.text,
      NizamioColors.dark.text,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün boyutlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_icon_button.png'),
      );
    },
  );

  group('circle', () {
    Material circleMaterial(WidgetTester t) => t.widget<Material>(
      find
          .descendant(
            of: find.byType(NzIconButton),
            matching: find.byType(Material),
          )
          .first,
    );

    testWidgets(
      'circle: surface dolgu + border-control kenar; 44 görsel, 48 dokunma',
      (t) async {
        for (final dark in [false, true]) {
          final c = dark ? NizamioColors.dark : NizamioColors.light;
          var n = 0;
          await t.pumpWidget(
            testApp(
              Center(
                child: NzIconButton.circle(
                  icon: Icons.search,
                  semanticLabel: 'Ara',
                  onPressed: () => n++,
                ),
              ),
              dark: dark,
            ),
          );
          await t.pumpAndSettle();
          final m = circleMaterial(t);
          expect(m.color, c.surface);
          expect((m.shape! as CircleBorder).side.color, c.borderControl);
          expect(t.getSize(find.byType(NzIconButton)), const Size.square(48));
          expect(
            t.getSize(find.byType(InkWell)),
            const Size.square(NizamioSize.tap),
          );
          await t.tap(find.byType(NzIconButton));
          expect(n, 1);
        }
      },
    );

    testWidgets('circleAccent: accent dolgu, accent-ink ikon', (t) async {
      await t.pumpWidget(
        testApp(
          Center(
            child: NzIconButton.circleAccent(
              icon: Icons.add,
              semanticLabel: 'Yeni görev',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(circleMaterial(t).color, NizamioColors.light.primary);
      expect(
        t.widget<Icon>(find.byIcon(Icons.add)).color,
        NizamioColors.light.onPrimary,
      );
    });

    testWidgets('nokta yalnız verilince; etiket okuyucuda', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(
        testApp(
          Center(
            child: NzIconButton.circle(
              icon: Icons.tune,
              semanticLabel: 'Filtreler',
              dot: NizamioColors.light.accentText,
              onPressed: () {},
            ),
          ),
        ),
      );
      final dots = find.descendant(
        of: find.byType(NzIconButton),
        matching: find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration?)?.color ==
                  NizamioColors.light.accentText,
        ),
      );
      expect(dots, findsOneWidget);
      expect(find.bySemanticsLabel('Filtreler'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('devre dışı: çağrı yok', (t) async {
      await t.pumpWidget(
        testApp(
          const Center(
            child: NzIconButton.circle(
              icon: Icons.search,
              semanticLabel: 'Ara',
              onPressed: null,
            ),
          ),
        ),
      );
      await t.tap(find.byType(NzIconButton));
      expect(t.takeException(), isNull);
    });
  });
}
