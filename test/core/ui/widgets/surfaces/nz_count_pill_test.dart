import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_count_pill.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('sayı ve okuyucu etiketi; ton mürekkebi', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      testApp(const NzCountPill.danger(4, semanticLabel: 'geciken')),
    );
    expect(
      t.widget<Text>(find.text('4')).style!.color,
      NizamioColors.light.onDanger,
    );
    expect(
      t.getSemantics(find.byType(NzCountPill)),
      matchesSemantics(label: 'geciken 4'),
    );
    await t.pumpWidget(testApp(const NzCountPill.warning(3)));
    expect(
      t.widget<Text>(find.text('3')).style!.color,
      NizamioColors.light.warning,
    );
    handle.dispose();
  });
}
