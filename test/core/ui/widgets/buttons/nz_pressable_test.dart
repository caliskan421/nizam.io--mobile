import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_pressable.dart';

import '../feedback/feedback_test_support.dart';

double _scale(WidgetTester t) =>
    t.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

void main() {
  setUpFonts();

  testWidgets('basılıyken token ölçeğine küçülür, bırakınca döner', (t) async {
    await t.pumpWidget(testApp(const NzPressable(child: Text('x'))));
    final g = await t.startGesture(t.getCenter(find.text('x')));
    await t.pump();
    expect(_scale(t), NizamioMotion.pressButton);
    await g.up();
    await t.pump();
    expect(_scale(t), 1);
  });

  testWidgets('kart ölçeği; devre dışıyken küçülmez', (t) async {
    await t.pumpWidget(testApp(const NzPressable.card(child: Text('x'))));
    var g = await t.startGesture(t.getCenter(find.text('x')));
    await t.pump();
    expect(_scale(t), NizamioMotion.pressCard);
    await g.cancel();
    await t.pumpWidget(
      testApp(const NzPressable(enabled: false, child: Text('x'))),
    );
    g = await t.startGesture(t.getCenter(find.text('x')));
    await t.pump();
    expect(_scale(t), 1);
    await g.up();
  });

  testWidgets('hareketi azalt: süre sıfır', (t) async {
    await t.pumpWidget(
      testApp(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: NzPressable(child: Text('x')),
        ),
      ),
    );
    expect(
      t.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
      Duration.zero,
    );
  });
}
