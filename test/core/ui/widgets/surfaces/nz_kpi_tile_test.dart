import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_kpi_tile.dart';

import '../feedback/feedback_test_support.dart';

Widget _tile({VoidCallback? onTap}) => NzKpiTile(
  icon: Icons.bolt,
  tone: NizamioColors.light.danger,
  label: 'Gecikmede',
  value: '15',
  valueColor: NizamioColors.light.danger,
  progress: 0.38,
  caption: 'Açık görevlerde %38',
  onTap: onTap,
  semanticLabel: 'Gecikmede: 15',
);

void main() {
  setUpFonts();

  testWidgets(
    'rakam, etiket, açıklama; dokununca çağrılır; ok yalnız dokunulabilirken',
    (t) async {
      var n = 0;
      await t.pumpWidget(
        testApp(SizedBox(width: 180, child: _tile(onTap: () => n++))),
      );
      expect(find.text('15'), findsOneWidget);
      expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
      await t.tap(find.text('15'));
      expect(n, 1);
      expect(
        t.widget<Text>(find.text('15')).style!.color,
        NizamioColors.light.danger,
      );
      await t.pumpWidget(testApp(SizedBox(width: 180, child: _tile())));
      expect(find.byIcon(Icons.north_east_rounded), findsNothing);
    },
  );

  testWidgets('dar sütun ve 2.0 metinde taşma yok', (t) async {
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(SizedBox(width: 156, child: _tile(onTap: () {}))),
    );
    expect(t.takeException(), isNull);
  });
}
