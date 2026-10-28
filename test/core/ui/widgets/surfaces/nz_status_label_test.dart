import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_status_label.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  test('ton → token rengi', () {
    for (final c in [NizamioColors.light, NizamioColors.dark]) {
      expect(NzTone.neutral.color(c), c.textFaint);
      expect(NzTone.progress.color(c), c.inProgress);
      expect(NzTone.waiting.color(c), c.warning);
      expect(NzTone.danger.color(c), c.danger);
      expect(NzTone.done.color(c), c.accentText);
      expect(NzTone.info.color(c), c.info);
    }
  });

  testWidgets('nokta ton renginde, kelime ink (renk yalnız noktada)', (
    t,
  ) async {
    for (final dark in [false, true]) {
      final c = dark ? NizamioColors.dark : NizamioColors.light;
      await t.pumpWidget(
        testApp(
          const Center(
            child: NzStatusLabel(label: 'Devam ediyor', tone: NzTone.progress),
          ),
          dark: dark,
        ),
      );
      await t.pumpAndSettle();
      expect(t.widget<NzDot>(find.byType(NzDot)).color, c.inProgress);
      expect(t.widget<Text>(find.text('Devam ediyor')).style!.color, c.text);
    }
  });

  testWidgets('rozet: yarı saydam dolgu, danger yazı, mono', (t) async {
    await t.pumpWidget(
      testApp(
        const Center(
          child: NzStatusLabel.badge(
            label: '98 gün gecikti',
            tone: NzTone.danger,
          ),
        ),
      ),
    );
    final c = NizamioColors.light;
    final box = t.widget<DecoratedBox>(find.byType(DecoratedBox).first);
    final fill = (box.decoration as BoxDecoration).color!;
    expect(fill.a, lessThan(0.5));
    final text = t.widget<Text>(find.text('98 gün gecikti')).style!;
    expect(text.color, c.danger);
    expect(text.fontSize, NizamioTypography.monoSm.size);
  });

  testWidgets('anlamsal: kelime okunur; 360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 400);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        const Row(
          children: [
            Expanded(
              child: NzStatusLabel(
                label: 'Onay bekliyor ve uzun bir açıklama',
                tone: NzTone.waiting,
              ),
            ),
            Flexible(
              child: NzStatusLabel.badge(
                label: '3 gecikmede',
                tone: NzTone.danger,
              ),
            ),
          ],
        ),
      ),
    );
    expect(t.takeException(), isNull);
    expect(find.text('Onay bekliyor ve uzun bir açıklama'), findsOneWidget);
  });
}
