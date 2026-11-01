import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_reveal.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  Widget host(bool open) => Column(
    children: [
      NzReveal(
        open: open,
        child: const SizedBox(height: 100, child: Text('iç')),
      ),
    ],
  );

  testWidgets('kapalıyken içerik ağaçta yok; açılınca animasyonla gelir', (
    t,
  ) async {
    await t.pumpWidget(testApp(host(false)));
    expect(find.text('iç'), findsNothing);
    await t.pumpWidget(testApp(host(true)));
    await t.pump(const Duration(milliseconds: 50));
    final mid = t.getSize(find.byType(NzReveal)).height;
    expect(mid, inExclusiveRange(0, 100));
    await t.pumpAndSettle();
    expect(t.getSize(find.byType(NzReveal)).height, 100);
    await t.pumpWidget(testApp(host(false)));
    await t.pumpAndSettle();
    expect(find.text('iç'), findsNothing);
  });

  testWidgets('hareketi azalt: anlık', (t) async {
    t.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(t.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await t.pumpWidget(testApp(host(false)));
    await t.pumpWidget(testApp(host(true)));
    await t.pump();
    expect(t.getSize(find.byType(NzReveal)).height, 100);
  });

  testWidgets('onOpened yalnız açılış bitince; yarıda kapanırsa çağrılmaz', (
    t,
  ) async {
    var opened = 0;
    Widget host(bool open) => testApp(
      NzReveal(
        open: open,
        onOpened: () => opened++,
        child: const SizedBox(height: 100),
      ),
    );
    await t.pumpWidget(host(false));
    await t.pumpWidget(host(true));
    await t.pump(const Duration(milliseconds: 50));
    expect(opened, 0);
    await t.pumpWidget(host(false));
    await t.pumpAndSettle();
    expect(opened, 0);
    await t.pumpWidget(host(true));
    await t.pumpAndSettle();
    expect(opened, 1);
  });
}
