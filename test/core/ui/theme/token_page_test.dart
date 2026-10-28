// Token sayfası: etiketsiz piksel/boyut kanıtı (her platformda) + golden (yalnız Linux).
// Referans: test/core/ui/theme/goldens/token_page_{light,dark}.png — Linux'ta üretilir,
// yerelde commit'lenmez.
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';

import '../../../support/golden.dart';
import 'token_page.dart';

List<int> _rgba(Color c) => [
  (c.r * 255).round(),
  (c.g * 255).round(),
  (c.b * 255).round(),
  (c.a * 255).round(),
];

/// Sayfa (20 rol + 14 metin rolü) 800x600 varsayılan yüzeye sığmaz.
void _tallView(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final (name, dark, colors) in [
    ('açık', false, NizamioColors.light),
    ('koyu', true, NizamioColors.dark),
  ]) {
    testWidgets(
      '$name: hedef 400 genişlikte, rol kutuları token rengiyle dolu',
      (tester) async {
        _tallView(tester);
        await tester.pumpWidget(tokenPage(dark: dark));
        final size = tester.getSize(find.byKey(tokenPageKey));
        expect(size.width, tokenPageWidth);
        expect(size.height, greaterThan(300));

        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(tokenPageKey),
        );
        final bytes = (await tester.runAsync(() async {
          final image = await boundary.toImage();
          expect(
            (image.width, image.height),
            (size.width.round(), size.height.round()),
          );
          return image.toByteData(format: ui.ImageByteFormat.rawRgba);
        }))!;
        List<int> px(Offset p) {
          final o = (p.dy.round() * size.width.round() + p.dx.round()) * 4;
          return [for (var i = 0; i < 4; i++) bytes.getUint8(o + i)];
        }

        final roles = tokenRoles(colors);
        for (var i = 0; i < roles.length; i++) {
          expect(px(tokenSwatchCenter(i)), _rgba(roles[i]), reason: 'rol #$i');
        }
        // Sayfa zemi (kutuların dışı) background rengi, opak.
        expect(px(const Offset(2, 2)), _rgba(colors.background));
      },
    );

    goldenTestWidgets('$name: token sayfası golden', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(tokenPage(dark: dark));
      await expectLater(
        find.byKey(tokenPageKey),
        matchesGoldenFile('goldens/token_page_${dark ? 'dark' : 'light'}.png'),
      );
    });
  }
}
