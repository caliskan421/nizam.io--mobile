import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_icon.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';

import 'feedback/feedback_test_support.dart';

Future<void> _pump(WidgetTester tester, double width, Widget child) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(testApp(Center(child: child)));
}

void main() {
  setUpFonts();

  for (final (device, width) in [('telefon', 390.0), ('tablet', 1180.0)]) {
    testWidgets('$device: Material Icon; boyut, renk ve anlam korunur', (
      tester,
    ) async {
      await _pump(
        tester,
        width,
        const NzIcon(
          NzIcons.search,
          size: 16,
          color: Color(0xFFFF0000),
          semanticLabel: 'Ara',
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(NzIcons.search));
      expect(icon.size, 16);
      expect(icon.color, const Color(0xFFFF0000));
      expect(find.bySemanticsLabel('Ara'), findsOneWidget);
    });
  }

  test('aynı anlam tek ada iner (telefon tasarımı)', () {
    expect(NzIcons.back, Icons.arrow_back_ios_new_rounded);
    expect(NzIcons.close, Icons.close_rounded);
    expect(NzIcons.add, Icons.add_rounded);
  });
}
