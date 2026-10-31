import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_list_tile.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzListTile(
        title: 'Başlık ${size.name}',
        subtitle: 'Alt başlık metni biraz uzun olsun ki satır sarılsın',
        leading: const Icon(Icons.person_outline),
        trailing: const Icon(Icons.more_vert),
        size: size,
        onTap: () {},
      ),
      NzListTile.navigation(title: 'Gezinme', size: size, onTap: () {}),
      NzListTile.danger(title: 'Sil', size: size, onTap: () {}),
    ],
    const NzListTile(title: 'Seçili', selected: true),
    const NzListTile(title: 'Salt okunur', subtitle: 'Dokunma yok'),
  ],
);

bool _near(List<int> a, List<int> b) {
  for (var i = 0; i < 4; i++) {
    if ((a[i] - b[i]).abs() > 2) return false;
  }
  return true;
}

void main() {
  setUpFonts();

  group('davranış', () {
    testWidgets('başlık, alt başlık ve yuvalar gösterilir', (tester) async {
      await tester.pumpWidget(
        testApp(
          const NzListTile(
            title: 'Başlık',
            subtitle: 'Alt',
            leading: Icon(Icons.person_outline),
            trailing: Icon(Icons.more_vert),
          ),
        ),
      );
      expect(find.text('Başlık'), findsOneWidget);
      expect(find.text('Alt'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('dokunuş onTap çağırır', (tester) async {
      var n = 0;
      await tester.pumpWidget(
        testApp(NzListTile(title: 'Başlık', onTap: () => n++)),
      );
      await tester.tap(find.text('Başlık'));
      expect(n, 1);
    });

    testWidgets('onTap null → dokunma tepkisi yok', (tester) async {
      await tester.pumpWidget(testApp(const NzListTile(title: 'Başlık')));
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });

    testWidgets('navigation: trailing yoksa ok simgesi, varsa verilen', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(NzListTile.navigation(title: 'A', onTap: () {})),
      );
      expect(find.byIcon(NzIcons.chevronRight), findsOneWidget);
      await tester.pumpWidget(
        testApp(
          NzListTile.navigation(
            title: 'A',
            trailing: const Icon(Icons.add),
            onTap: () {},
          ),
        ),
      );
      expect(find.byIcon(NzIcons.chevronRight), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('danger: başlık tehlike renginde', (tester) async {
      await tester.pumpWidget(
        testApp(NzListTile.danger(title: 'Sil', onTap: () {})),
      );
      expect(
        tester.widget<Text>(find.text('Sil')).style!.color,
        NizamioColors.light.danger,
      );
    });

    testWidgets('düz satırın başlığı metin renginde', (tester) async {
      await tester.pumpWidget(testApp(const NzListTile(title: 'A')));
      expect(
        tester.widget<Text>(find.text('A')).style!.color,
        NizamioColors.light.text,
      );
    });
  });

  group('boyut ve erişilebilirlik', () {
    testWidgets('her boyutta satır yüksekliği >= 48; büyük boyut daha uzun', (
      tester,
    ) async {
      final heights = <NzSize, double>{};
      for (final size in NzSize.values) {
        await tester.pumpWidget(
          testApp(
            Align(
              alignment: Alignment.topCenter,
              child: NzListTile(title: 'A', size: size, onTap: () {}),
            ),
          ),
        );
        heights[size] = tester.getSize(find.byType(InkWell)).height;
        expect(heights[size], greaterThanOrEqualTo(NizamioSpacing.space12));
      }
      expect(heights[NzSize.sm], lessThan(heights[NzSize.md]!));
      expect(heights[NzSize.md], lessThan(heights[NzSize.lg]!));
    });

    testWidgets('metin ölçeği 2.0: uzun metin satırı uzatır, taşma yok', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: NzListTile(
              title: 'Çok uzun bir başlık metni satır sarmalıdır',
              subtitle: 'Çok uzun bir alt başlık metni de satır sarmalıdır',
              leading: const Icon(Icons.person_outline),
              trailing: const Icon(Icons.more_vert),
              onTap: () {},
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(InkWell)).height,
        greaterThan(NizamioSpacing.space12),
      );
    });

    testWidgets('anlamsal: düğme, seçili ve tek birleşik etiket', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          NzListTile(
            title: 'Başlık',
            subtitle: 'Alt',
            selected: true,
            onTap: () {},
          ),
        ),
      );
      final node = tester
          .getSemantics(find.byType(NzListTile))
          .getSemanticsData();
      expect(node.label, contains('Başlık'));
      expect(node.label, contains('Alt'));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isSelected, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('salt okunur satır düğme değildir', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(testApp(const NzListTile(title: 'Başlık')));
      expect(
        tester
            .getSemantics(find.byType(NzListTile))
            .getSemanticsData()
            .flagsCollection
            .isButton,
        isFalse,
      );
      handle.dispose();
    });
  });

  testWidgets('piksel: tabaka 1024 geniş; seçili zemin tonu ve danger metni', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    final px = await capture(tester);
    expect(px.width, sheetWidth.toInt());
    expect(px.at(0, 0), rgba(NizamioColors.light.background));
    expect(
      px.at(px.width - 1, px.height - 1),
      rgba(NizamioColors.dark.background),
    );
    for (final colors in [NizamioColors.light, NizamioColors.dark]) {
      final tint = Color.alphaBlend(
        colors.primary.withValues(alpha: 0.12),
        colors.background,
      );
      final want = rgba(tint);
      var found = false;
      for (var y = 0; y < px.height && !found; y += 2) {
        for (var x = 0; x < px.width && !found; x += 2) {
          found = _near(px.at(x, y), want);
        }
      }
      expect(found, isTrue, reason: 'seçili zemin tonu bulunamadı');
    }
    expect(px.contains(NizamioColors.light.danger), isTrue);
    expect(px.contains(NizamioColors.dark.danger), isTrue);
    expect(tester.takeException(), isNull);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_list_tile.png'),
      );
    },
  );
}
