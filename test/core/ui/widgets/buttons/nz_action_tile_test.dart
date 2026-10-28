import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_action_tile.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('dokununca çağrılır; ≥ 48; anlamsal düğme etiketi', (t) async {
    final handle = t.ensureSemantics();
    var n = 0;
    await t.pumpWidget(
      testApp(
        NzActionTile(icon: Icons.add, label: 'Yeni', onPressed: () => n++),
      ),
    );
    await t.tap(find.text('Yeni'));
    expect(n, 1);
    expect(
      t.getSize(find.byType(NzActionTile)).height,
      greaterThanOrEqualTo(NizamioSpacing.space12),
    );
    expect(
      t.getSemantics(find.byType(NzActionTile)),
      matchesSemantics(
        label: 'Yeni',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('primary: ikon kutusu ana eylem dolgusu', (t) async {
    await t.pumpWidget(
      testApp(
        NzActionTile(
          icon: Icons.add,
          label: 'Yeni',
          primary: true,
          onPressed: () {},
        ),
      ),
    );
    final box = t
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .firstWhere(
          (d) =>
              (d.decoration as BoxDecoration).color ==
              NizamioColors.light.primary,
        );
    expect(box, isNotNull);
  });
}
