import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_icon_tile.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('36 px çip; renk verilmezse ikincil metin rengi', (t) async {
    await t.pumpWidget(
      testApp(const Center(child: NzIconTile(icon: Icons.add))),
    );
    expect(
      t.getSize(find.byType(NzIconTile)),
      const Size.square(NizamioSize.iconTile),
    );
    expect(
      t.widget<Icon>(find.byType(Icon)).color,
      NizamioColors.light.textMuted,
    );
    await t.pumpWidget(
      testApp(
        Center(
          child: NzIconTile(icon: Icons.add, color: NizamioColors.light.danger),
        ),
      ),
    );
    expect(t.widget<Icon>(find.byType(Icon)).color, NizamioColors.light.danger);
  });
}
