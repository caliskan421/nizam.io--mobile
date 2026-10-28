import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_split_button.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('iki parça ayrı eylem; ikon dönüşü; her parça ≥ 48 yükseklik', (
    t,
  ) async {
    var label = 0;
    var icon = 0;
    await t.pumpWidget(
      testApp(
        Center(
          child: NzSplitButton(
            label: 'Gecikme',
            semanticLabel: 'Sırala: Gecikme',
            onPressed: () => label++,
            icon: Icons.keyboard_arrow_down_rounded,
            iconTurns: 0.5,
            iconSemanticLabel: 'Ters çevir',
            onIconPressed: () => icon++,
          ),
        ),
      ),
    );
    await t.tap(find.text('Gecikme'));
    await t.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    expect((label, icon), (1, 1));
    expect(
      t.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
      0.5,
    );
    expect(
      t.getSize(find.byType(NzSplitButton)).height,
      greaterThanOrEqualTo(48),
    );
    expect(find.bySemanticsLabel('Ters çevir'), findsOneWidget);
  });
}
