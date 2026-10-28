// Ortak yüzey dolguları, cam tonları ve iç ışık boyayıcısı.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/nz_motion.dart';
import 'package:nizamio/core/ui/theme/nz_surfaces.dart';

void main() {
  for (final c in [NizamioColors.light, NizamioColors.dark]) {
    test(
      'degradeler token rollerinden (${c == NizamioColors.dark ? 'koyu' : 'açık'})',
      () {
        expect(c.cardFill.colors, [c.surfaceTop, c.surface]);
        expect(c.secondaryFill.colors, [c.buttonTop, c.buttonBottom]);
        expect(c.primaryFill.colors, [c.primaryTop, c.primary]);
        expect(NzGlassTone.bar.fill(c), c.glassBar);
        expect(NzGlassTone.float.fill(c), c.glassFloat);
        expect(NzGlassTone.menu.fill(c), c.glassMenu);
      },
    );
  }

  test('cam filtreleri kurulur', () {
    for (final tone in NzGlassTone.values) {
      expect(tone.filter(), isNotNull);
    }
  });

  testWidgets('iç ışık: kenarlığın içinde 1 px şerit; yeniden çizim koşulu', (
    t,
  ) async {
    const p = NzEdgeLightPainter(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    await t.pumpWidget(
      const Center(
        child: RepaintBoundary(
          child: CustomPaint(size: Size(100, 40), painter: p),
        ),
      ),
    );
    expect(p.shouldRepaint(p), isFalse);
    expect(
      p.shouldRepaint(
        const NzEdgeLightPainter(
          color: Color(0xFF000000),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      isTrue,
    );
  });

  testWidgets('NzMotion: hareketi azalt açıkken süre sıfır', (t) async {
    late Duration on;
    late Duration off;
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            on = NzMotion.of(context, NizamioMotion.durSheet);
            return const SizedBox();
          },
        ),
      ),
    );
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Builder(
          builder: (context) {
            off = NzMotion.of(context, NizamioMotion.durSheet);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(on, Duration.zero);
    expect(off, NizamioMotion.durSheet);
  });
}
