import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_filter_rail.dart';

import '../feedback/feedback_test_support.dart';

Widget _rail(int selected, ValueChanged<int> onSelected) => NzFilterRail(
  semanticLabel: 'Durum',
  selected: selected,
  onSelected: onSelected,
  options: const [
    NzFilterOption(label: 'Tümü', count: 11),
    NzFilterOption(label: 'Gecikmesi olan', count: 7),
    NzFilterOption(label: 'Yolunda'),
    NzFilterOption(label: 'Koordinatörsüz', count: 1),
  ],
);

void main() {
  setUpFonts();

  testWidgets(
    'seçim bildirilir; seçili öğe anlamsal olarak seçili; yatay kayar',
    (t) async {
      final handle = t.ensureSemantics();
      final picked = <int>[];
      await t.pumpWidget(
        testApp(SizedBox(width: 300, child: _rail(0, picked.add))),
      );
      await t.tap(find.text('Yolunda'));
      expect(picked, [2]);
      expect(
        t.getSemantics(find.bySemanticsLabel('Tümü, 11')),
        matchesSemantics(
          label: 'Tümü, 11',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      handle.dispose();
    },
  );

  for (final dark in [false, true]) {
    testWidgets('seçili parça zemini (${dark ? 'koyu' : 'açık'}); öğe 36', (
      t,
    ) async {
      final c = dark ? NizamioColors.dark : NizamioColors.light;
      await t.pumpWidget(testApp(_rail(1, (_) {}), dark: dark));
      await t.pumpAndSettle();
      final selected = t.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text('Gecikmesi olan'),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final deco = selected.decoration! as BoxDecoration;
      expect(deco.color, dark ? c.background : c.surface);
      expect(
        t.getSize(find.byType(AnimatedContainer).first).height,
        NizamioSize.tabH,
      );
    });
  }

  testWidgets('2.0 metinde taşma yok', (t) async {
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(testApp(SizedBox(width: 328, child: _rail(0, (_) {}))));
    expect(t.takeException(), isNull);
  });
}
