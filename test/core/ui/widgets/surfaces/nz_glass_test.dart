import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/nz_surfaces.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_glass.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  for (final dark in [false, true]) {
    testWidgets('ton dolgusu ve bulanıklık (${dark ? 'koyu' : 'açık'})', (
      t,
    ) async {
      final c = dark ? NizamioColors.dark : NizamioColors.light;
      for (final tone in NzGlassTone.values) {
        await t.pumpWidget(
          testApp(
            NzGlass(tone: tone, child: const Text('x')),
            dark: dark,
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
        final m = t.widget<Material>(
          find.descendant(
            of: find.byType(NzGlass),
            matching: find.byType(Material),
          ),
        );
        expect(m.color, tone.fill(c));
      }
    });
  }

  testWidgets('daire biçimi ve kenarsız', (t) async {
    await t.pumpWidget(
      testApp(
        const NzGlass.circle(
          tone: NzGlassTone.float,
          edge: false,
          child: Text('x'),
        ),
      ),
    );
    final m = t.widget<Material>(
      find.descendant(
        of: find.byType(NzGlass),
        matching: find.byType(Material),
      ),
    );
    expect(m.shape, isA<CircleBorder>());
    expect((m.shape! as CircleBorder).side, BorderSide.none);
  });
}
